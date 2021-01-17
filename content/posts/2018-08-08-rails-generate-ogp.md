---
title: Rails でユーザー毎に OGP 画像を自動生成するハンズオン
slug: rails-generate-ogp
date: 2018-08-08 21:40:20
tags:
- rails
- ogp
- rmagic
---

ユーザーの詳細ページがある Web アプリケーションで，ユーザー毎に OGP 画像を自動生成し表示させてみる．

完成版のソースコードはこちら 👉 [rails_ogp_generator_sample](https://github.com/tanakaworld/rails_ogp_generator_sample)．

## 前提条件
- Ruby `2.4.2`
- Rails `5.1.6`
- RMagic `2.16.0`

## Gem

画像生成で [rmagic](https://github.com/rmagick/rmagick)，アップロードに [carrierwave](https://github.com/carrierwaveuploader/carrierwave) を使う．

```ruby
# Gemfile

gem 'rmagick'
gem 'carrierwave'
```

```bash
$ bundle install
```

## User の Scaffold を作成

`name` と `avatar` を持つユーザーの Scaffold を作成する．

```bash
$ bundle exec rails g scaffold User name:string avatar:text
```

```ruby
# db/migrate/20180720144053_create_users.rb

class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.text :avatar

      t.timestamps
    end
  end
end
```

```bash
$ bundle exec rails db:migrate
```


## UserOgpImage モデルを作成

User の OGP 画像を保持するモデルを作成する．

```bash
$ bundle exec rails g model UserOgpImage user:references image:text
```

```ruby
# db/migrate/20180725031431_create_user_ogp_images.rb

class CreateUserOgpImages < ActiveRecord::Migration[5.1]
  def change
    create_table :user_ogp_images do |t|
      t.references :user, foreign_key: true, null: false
      t.text :image

      t.timestamps
    end
  end
end
```

```bash
$ bundle exec rails db:migrate
```

## Uploader を作成

`user.avatar` と 生成した OGP 画像用のアップローダーを生成する．

```bash
$ bundle exec rails g uploader UserAvatar
$ bundle exec rails g uploader UserOgpImage
```

## モデルの関連を追記

User が OGP 画像を1個もつようにする．

```ruby
# app/models/user.rb

class User < ApplicationRecord
  has_one :user_ogp_image, dependent: :destroy

  mount_uploader :avatar, UserAvatarUploader
end
```

```ruby
# app/models/user_ogp_image.rb

class UserOgpImage < ApplicationRecord
  belongs_to :user

  mount_uploader :image, UserOgpImageUploader

  validates :user, presence: true

  def url
    image.url
  end
end
```

## OGP 画像生成処理を実装

`ApplicationRecord` を継承しない，プレーンな Ruby クラスで実装する．

OGP 画像にアバターと名前を表示する．1200x630 の Image を作成し，そこに `user.avatar` と `user.name` を合成するイメージ．
`Magic::Draw` のインスタンスに `font` を設定しないと日本語が文字化けするので注意が必要．

```ruby
# app/models/user_ogp_image_generator.rb

class UserOgpImageGenerator
  include Magick

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def generate
    user_id = @user.id
    user_name = @user.name
	
    # host を指定すること
    avatar_path = @user.avatar.present? ?
                      user.avatar.url
                      : ActionController::Base.helpers.image_path('default-avatar.png', host: 'http://localhost:3000')

    # 1200x630 の大きさのベースを作成
    image = Magick::ImageList.new
    image.new_image(1200, 630) do
      self.background_color = '#e5e5e5'
    end

    # 文字の設定
    draw = Magick::Draw.new
    draw.gravity = Magick::CenterGravity
    draw.font = Rails.root.join('app', 'assets', 'fonts', 'NotoSansCJKjp-Medium.otf').to_s
    draw.fill = 'white'

    # avatar
    avatar_image = Magick::Image.from_blob(open(avatar_path).read).first
    avatar_image = avatar_image.resize(320, 320)
    image.composite!(avatar_image, Magick::CenterGravity, 0, -80, Magick::OverCompositeOp)

    # name
    if user_name.present?
      draw.pointsize = 58
      draw.annotate(image, 0, 0, 0, 155, user_name) {
        self.fill = '#333'
      }
    end

    dist_dir = "#{Rails.root.join('tmp', 'ogp_image')}"
    Dir.mkdir(dist_dir) unless File.exists?(dist_dir)
    dist_path = "#{dist_dir}/#{user_id}-#{user_name}.png"
    image.write(dist_path)
    dist_path
  end
end
```

`UserOgpImageGenerator` クラスに `User` のインスタンスを渡すと，OPG画像が生成される．
画像は `tmp/` 以下に生成され，その絶対パスが返る．

```ruby
ogp_image_generator = UserOgpImageGenerator.new(User.first)
file_path = ogp_image_generator.generate
```

## OGP 生成を組み込む

User 情報 `name` `avatar` が更新されたら，OGP 画像を更新するようにする．

```ruby
class User < ApplicationRecord
  •••

  after_save :generate_ogp_image, if: :ogp_image_info_changed?

  def ogp_image_info_changed?
    name_changed? || avatar_changed?
  end

  def generate_ogp_image
    ogp_image_generator = UserOgpImageGenerator.new(self)
    file_path = ogp_image_generator.generate

    tmp_user_ogp_image = user_ogp_image.present? ? user_ogp_image : UserOgpImage.new(user: self)
    tmp_user_ogp_image.image = File.open(file_path)
    tmp_user_ogp_image.save!
  end
end
```

次のように，アバターを指定されたときはそのアバター情報が入る．

![image](https://user-images.githubusercontent.com/3489430/43838431-4d451c84-9b56-11e8-9058-b575d5876a83.png)


## アバターを円でくり抜く

UserOgpImageGenerator を拡張して，OGP 画像でよくやられているアバターを円でくり抜くのをやってみる．
Circle 画像を生成し，その画像でアバター画像をマスクする．

```ruby
def make_circle_mask(image, size)
    circle_image = Magick::Image.new(size, size)
    draw = Magick::Draw.new

    # ref: https://rmagick.github.io/draw.html#circle
    draw.circle(size / 2, size / 2, size / 2, 0)
    draw.draw(circle_image)
    mask = circle_image.blur_image(0, 1).negate
    mask.matte = false

    image.matte = true
    image.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)

    image
end
```

`avatar_image` を `image.composite!` する前にくり抜き処理を挟めばOK．

```ruby
avatar_image = make_circle_mask(avatar_image, 320)
```

![image](https://user-images.githubusercontent.com/3489430/43838535-9d1e44e2-9b56-11e8-8826-e259eb13443d.png)


## まとめ

- [rails_ogp_generator_sample](https://github.com/tanakaworld/rails_ogp_generator_sample)

今回はモデルのコールバックで OGP を生成するようにしたが，処理が重くなるようなら非同期で処理するようにした方がよさそう．

