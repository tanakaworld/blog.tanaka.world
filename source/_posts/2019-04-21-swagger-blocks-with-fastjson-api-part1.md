---
title: Rails で swagger-blocks と fastjson_api を組み合わせる (API定義編)
date: 2019-04-21 11:48:00
tags:
	- rails
	- swagger
	- fastjson-api
---

Rails プロジェクトで クライアント向けの APIClient を自動生成するときの構成を試してみた．
Swagger で記述した API 定義からコード生成する例はちらほら見かけるが，Netflix 製の [fast_jsonapi](https://github.com/Netflix/fast_jsonapi) を使った記事は見かけなかったので，まとめておく．

完成版のソースコードはこちら 👉 [tanakaworld/swagger-blocks-fastjson-api](https://github.com/tanakaworld/swagger-blocks-fastjson-api)

## TL;DR;

**Part1: API定義編 (本記事)**
- Backend は Rails で API を実装
- JSON シリアライザとして，Netflix 製の [fastjson_api](https://github.com/Netflix/fast_jsonapi)
- API 定義は [swagger-blocks](https://github.com/fotinakis/swagger-blocks) を使用

Part2: コード生成編 (作成中)
- [openapi-generator](https://github.com/OpenAPITools/openapi-generator) で TypeScript の APIClient を自動生成

Part3: 自動テスト編 (作成中)
- RSpec で Reqeuests 自動テスト
- [committee-rails](https://github.com/willnet/committee-rails) で Swagger 定義との整合性チェック


## Scaffold Books

書籍情報の CRUD を題材に考える．
Rails 6.0.0.beta3 を使った．

scaffold で Books を生成し，画像アップロードは [Active Storage](https://edgeguides.rubyonrails.org/active_storage_overview.html) を使う．

```bash
$ bundle exec rails g scaffold books title:string description:text
$ bundle exec rails db:migrate
```

Active Storage を有効化し，Model / View / Controller で `image` の記述を追加する．

```bash
$ bundle exec rails active_storage:install
$ bundle exec rails db:migrate
```

```ruby
# app/models/book.rb
class Book < ApplicationRecord
  has_one_attached :image
end
```

![scaffold_books_list](scaffold_books_list.png  'scaffold_books_list.png')


## Serializer

Books 向けとエラーハンドリング用の Serializer を用意する．

```ruby
# Gemfile
gem 'fast_jsonapi'
```

```bash
$ bundle exec rails g serializer books
$ bundle exec rails g serializer error
```

```ruby
# app/serializers/book_serializer.rb
class BookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
             :title,
             :description,
             :created_at,
             :updated_at

  attribute :image_url do |object|
    Rails.application.routes.url_helpers.rails_blob_url(object.image) if object.image.attached?
  end
end

# app/serializers/error_serializer.rb
class ErrorSerializer
  include FastJsonapi::ObjectSerializer
  attributes :errors
end
```

## API 実装

`app/controllers/api/books_controller.rb` を実装する．`app/controllers/books_controller.rb` とほぼ同じだが，APIレスポンス箇所で Serializer を使う．

> render json: BookSerializer.new(@books).serialized_json

```ruby
class Api::BooksController < ApplicationController
  before_action :set_book, only: [:show, :update, :destroy]

  def index
    @books = Book.all
    render json: BookSerializer.new(@books).serialized_json
  end

  def show
    render json: BookSerializer.new(@book).serialized_json
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      render json: BookSerializer.new(@book).serialized_json, status: :created
    else
      render json: ErrorSerializer.new(@book).serialized_json, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: BookSerializer.new(@book).serialized_json, status: :ok
    else
      render json: ErrorSerializer.new(@book).serialized_json, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    render json: nil, status: :no_content
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.permit(:title, :description, :image)
  end
end
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :books

  namespace :api, defaults: {format: :json} do
    resources :books, except: [:new, :edit]
  end
end
```

`/api/books` のレスポンスはこうなる．

![api_books_response](api_books_response.png 'api_books_response.png')


## Swagger 定義のディレクトリ構成

各 controller 上に swgger 定義を普通に記述してもよいが，一瞬で見通しが悪くなる．
Swagger 定義と API 実装の記述箇所を分離するために次の構成にした．
（参考：[Rails + swagger-blocks で OpenAPI 形式の API ドキュメントを作成する](https://qiita.com/kymmt90/items/439868c21abe077642fa)）


![swagger_dir.png](swagger_dir.png 'swagger_dir.png')

Controller に依存する定義は `app/controllers/concerns` に配置，`swagger_path` で API リクエストパスに対応する定義を記述する．

```ruby
# app/controllers/concerns/books_api.rb
module Swagger::BooksApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    include Swagger::ErrorSchema

    swagger_path '/api/books' do
      # Index
      operation :get do
        key :operationId, 'getBooks'
        key :tags, ['sampleApp']

        parameter name: :id,
                  in: :path,
                  required: true,
                  type: :integer,
                  format: :int64
        response 200 do
          key :description, 'Books response'
          fja_response_schema :array, :Book
        end
        extend Swagger::ErrorResponses::NotFoundError
      end
	end
  end
  
  •••
end
```

Model に依存する定義は `app/models/concerns` に配置し，主に `swagger_schema` で resource や request / response の形式を定義する．

```ruby
# app/models/concerns/books_schema.rb

module Swagger::BookSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Book,
                   required: [:title, :description, :image_url],
                   additionalProperties: false do
      property :id, type: :integer
      property :title, type: :string
      property :description, type: :string
      property :image_url, type: :string
      property :created_at, type: :string
      property :updated_at, type: :string
    end

    # response
    fja_swagger_schema :Book

    # request
    swagger_schema :CreateBookRequest, additionalProperties: false do
      property :title, type: :string
      property :description, type: :string
      property :image, type: :object
    end
    swagger_schema :UpdateBookRequest, additionalProperties: false do
      property :title, type: :string
      property :description, type: :string
      property :image, type: :object
    end
  end
end
```


## fastjson_api 向けの swagger-blocks ラッパーを実装

fast_jsonapi は [jsonapi](https://jsonapi.org/format/#document-resource-object-related-resource-links) に準拠している．
この形式を各定義に書くのは冗長なので，JSON API 形式準拠したレスポンス形式を記述するラッパー `fja_swagger_schema` を実装した．
`swagger_schema` の定義名とレスポンス形式が `object` or `array` を選択できるようにしている．


前者は Controller 側の記述で使い，後者は Model 側の記述で使う．

```ruby
# config/initializers/swagger_blocks.rb
module Swagger::Blocks
  module ClassMethods
    private

    def fja_swagger_schema(schema_name)
      swagger_schema "#{schema_name}Response".to_sym,
                     required: [:id, :type, :attributes],
                     additionalProperties: false do
        property :id, type: :string
        property :type, type: :string
        property :attributes, '$ref': schema_name.to_sym
        yield(self) if block_given?
      end
    end
  end
end

module Swagger::Blocks::Nodes
  class ResponseNode
    def fja_response_schema(type, schema_name)
      schema do
        key :type, :object
        key :required, [:data]
        property :data do
          key :type, type.to_sym
          if type.to_sym === :array
            items do
              key :'$ref', "#{schema_name}Response".to_sym
            end
          elsif type.to_sym === :object
            key :type, type.to_sym
            key :'$ref', "#{schema_name}Response".to_sym
          else
            raise Error.new "Unexpected schema type:#{type} name:#{schema_name}"
          end
        end
      end
    end
  end
end
```

Model 側で記述した `swagger_schema :Book` を用いて `fja_swagger_schema :Book` で fastjson_api のレスポンス形式の定義が記述できる．
そして Controller 側の `fja_response_schema :array, :Book` で API レスポンス定義として使える．


## swagger-blocks の記述から JSON を生成する

ここまでで記述してきた Model と Controller を集約し，`Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)` によって Swagger JSON を生成する．

```ruby
# app/controllers/concerns/swagger/api_docs.rb
module Swagger::ApiDocs
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'swagger-blocks with fastjson_api'
        key :description, 'swagger-blocks with fastjson_api'
      end
      key :produces, ['application/json']
      key :consumes, ['application/json']
    end

    SWAGGERED_CLASSES = [
        # models
        Book,

        # controllers
        Api::BooksController,

        self
    ].freeze
  end

  def swagger_data
    Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
```

デバッグ用に，ローカル開発中に Swagger 定義を確認できるエンドポイントを用意する．


```ruby
# app/controllers/api/swagger_controller.rb
class Api::SwaggerController < ActionController::Base
  include Swagger::ApiDocs

  def index
    render json: swagger_data, status: :ok
  end
end

# config/routes.rb
 namespace :api, defaults: {format: :json} do
    resources :swagger, only: [:index] unless Rails.env.production?
	
	•••
end
```

`http://localhost:3000/api/swagger` にアクセスすると次のような JSON が得られる．
定義が間違っているときはこの生成自体エラーになることが大半だが，生成できても意図しない動作するときなどのデバッグに使う．
[swagger-ui](https://swagger.io/tools/swagger-ui/) とかに JSON を食わせて見やすくするなども可能．

```json
{"swagger":"2.0","info":{"version":"1.0.0","title":"swagger-blocks with fastjson_api","description":"swagger-blocks with fastjson_api"},"produces":["application/json"],"consumes":["application/json"],"paths":{"/api/books":{"get":{"operationId":"getBooks","tags":["sampleApp"],"parameters":[{"name":"id","in":"path","required":true,"type":"integer","format":"int64"}],"responses":{"200":{"description":"Books response","schema":{"type":"object","required":["data"],"properties":{"data":{"type":"array","items":{"$ref":"#/definitions/BookResponse"}}}}},"404":{"description":"Resource not found","schema":{"$ref":"#/definitions/ErrorOutput"}}}},"post":{"operationId":"createBook","tags":["sampleApp"],"consumes":["multipart/form-data"],"parameters":[{"name":"body","in":"body","required":true,"schema":{"$ref":"#/definitions/CreateBookRequest"}}],"responses":{"201":{"description":"Book response","schema":{"type":"object","required":["data"],"properties":{"data":{"type":"object","$ref":"#/definitions/BookResponse"}}}},"400":{"description":"Invalid parameters","schema":{"$ref":"#/definitions/ErrorOutput"}},"422":{"description":"Unprocessable Entity","schema":{"$ref":"#/definitions/ErrorOutput"}}}}},"/api/books/{id}":{"get":{"operationId":"getBook","tags":["sampleApp"],"parameters":[{"name":"id","in":"path","required":true,"type":"integer","format":"int64"}],"responses":{"200":{"description":"Book response","schema":{"type":"object","required":["data"],"properties":{"data":{"type":"object","$ref":"#/definitions/BookResponse"}}}},"404":{"description":"Resource not found","schema":{"$ref":"#/definitions/ErrorOutput"}}}},"put":{"operationId":"updateBook","tags":["sampleApp"],"consumes":["multipart/form-data"],"parameters":[{"name":"id","in":"path","required":true,"type":"integer","format":"int64"},{"name":"body","in":"body","required":true,"schema":{"$ref":"#/definitions/UpdateBookRequest"}}],"responses":{"200":{"description":"Book response","schema":{"type":"object","required":["data"],"properties":{"data":{"type":"object","$ref":"#/definitions/BookResponse"}}}},"400":{"description":"Invalid parameters","schema":{"$ref":"#/definitions/ErrorOutput"}},"422":{"description":"Unprocessable Entity","schema":{"$ref":"#/definitions/ErrorOutput"}},"404":{"description":"Resource not found","schema":{"$ref":"#/definitions/ErrorOutput"}}}},"delete":{"operationId":"deleteBook","tags":["sampleApp"],"parameters":[{"name":"id","in":"path","required":true,"type":"integer","format":"int64"}],"responses":{"204":{"description":"No content response","schema":{}},"400":{"description":"Invalid parameters","schema":{"$ref":"#/definitions/ErrorOutput"}},"422":{"description":"Unprocessable Entity","schema":{"$ref":"#/definitions/ErrorOutput"}}}}}},"definitions":{"Book":{"required":["title","description","image_url"],"additionalProperties":false,"properties":{"id":{"type":"integer"},"title":{"type":"string"},"description":{"type":"string"},"image_url":{"type":"string"},"created_at":{"type":"string"},"updated_at":{"type":"string"}}},"BookResponse":{"required":["id","type","attributes"],"additionalProperties":false,"properties":{"id":{"type":"string"},"type":{"type":"string"},"attributes":{"$ref":"#/definitions/Book"}}},"CreateBookRequest":{"additionalProperties":false,"properties":{"title":{"type":"string"},"description":{"type":"string"},"image":{"type":"object"}}},"UpdateBookRequest":{"additionalProperties":false,"properties":{"title":{"type":"string"},"description":{"type":"string"},"image":{"type":"object"}}},"ErrorOutput":{"required":["errors"],"additionalProperties":false,"properties":{"errors":{"type":"array","items":{"type":"string"}}}}}}
```

## TBA

- Part2: コード生成編
- Part3: 自動テスト編

