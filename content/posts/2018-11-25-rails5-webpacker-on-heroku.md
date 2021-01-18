---
title: Rails5 / webpacker を heroku で動かす
slug: rails5-webpacker-on-heroku
date: 2018-11-25 23:13:03
tags:
- rails
- webpacker
- heroku
---

Rails の開発環境をサクッ構築するために heroku を使ったときのメモ．

## 環境

- Rails 5.1.6
- Ruby 2.4.x
- MySQL
- Webpacker つかう

## Heroku CLI

```bash
$ brew install heroku

# if already installed
$ brew upgrade heroku

$ brew -v
```

## Heroku 設定

- herokuでアプリケーション作成
- クレカ登録（後述の MySQL 向けプラグインを追加するために必要．Free プランを選べば課金はされない）
- プラグイン追加
    - Configure Add-ons
	- 「Clear DB」で検索して選択 -> Provision

![heroku-clear-db.png](/images/2018-11-25-rails5-webpacker-on-heroku/heroku-clear-db.png 'heroku-clear-db.png')


## Login

heroku に登録している email, password でログインする．

```
$ heroku login
```

## DB のセットアップ

先述の ClearDB をプラグインとして追加しているとそれ用の環境変数が設定される．


```bash
$ heroku config -a <your-app-name>
=== your-app-name Config Vars
CLEARDB_DATABASE_URL: mysql://xxxxxxxxxxxxxx:xxxxxxxxxx@xxxxxxxxxxxxxxxx.cleardb.net/heroku_xxxxxxxxxxxx?reconnect=true
```

`mysql` の箇所を `mysql2` に変更して別名で登録する

```bash
$ heroku config:set DATABASE_URL=mysql://xxxxxxxxxxxxxx:xxxxxxxxxx@xxxxxxxxxxxxxxxx.cleardb.net/heroku_xxxxxxxxxxxx?reconnect=true -a <your-app-name>
Setting DATABASE_URL and restarting ⬢ your-app-name... done, v4
```

設定した `DATABASE_URL` を接続情報として設定する．ClearDB の場合 `url` に先程の値を設定するだけでよい．

```yaml
# config/database.sample.yml

production:
  # For Heroku
  url: <%= ENV['DATABASE_URL'] %>
```


## 環境変数

その他，必要な環境変数を設定する．

```bash
$ heroku config:set XXXXXX=xxxxxx
```



## デプロイ

一旦デプロイしてみる．

```bash
$ git remote -v
```

heroku が Remote Repository に登録されていない場合は追加する

```bash
$ heroku git:remote -a your-app-name
```

デプロイ実行．

```bash
$ git push heroku master

$ git push heroku master
Enumerating objects: 750, done.
Counting objects: 100% (750/750), done.
Delta compression using up to 8 threads.
Compressing objects: 100% (469/469), done.
Writing objects: 100% (750/750), 163.13 KiB | 8.58 MiB/s, done.
Total 750 (delta 347), reused 529 (delta 223)
remote: Compressing source files... done.
remote: Building source:

••• (中略)

remote: -----> Detecting rake tasks
remote: -----> Preparing app for Rails asset pipeline
remote:        Running: rake assets:precompile
remote:        yarn install v1.5.1
remote:        [1/5] Validating package.json...
remote:        error mixed-nuts@: The engine "node" is incompatible with this module. Expected version "8.11.3".
remote:        error An unexpected error occurred: "Found incompatible module".
remote:        info If you think this is a bug, please open a bug report with the information provided in "/tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/yarn-error.log".
remote:        info Visit https://yarnpkg.com/en/docs/cli/install for documentation about this command.
remote:        I, [2018-07-19T02:14:37.162948 #1621]  INFO -- : Writing /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/public/assets/application-2b0484413e031f2b6ab1e6b1ff622e8c65bf0c834557595a5bf6361807ca24d4.js
remote:        I, [2018-07-19T02:14:37.163879 #1621]  INFO -- : Writing /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/public/assets/application-2b0484413e031f2b6ab1e6b1ff622e8c65bf0c834557595a5bf6361807ca24d4.js.gz
remote:        I, [2018-07-19T02:14:37.171636 #1621]  INFO -- : Writing /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/public/assets/application-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css
remote:        I, [2018-07-19T02:14:37.172018 #1621]  INFO -- : Writing /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/public/assets/application-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.css.gz
remote:        Webpacker is installed 🎉 🍰
remote:        Using /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/config/webpacker.yml file for setting up webpack paths
remote:        Compiling…
remote:        Compilation failed:
remote:        
remote:        /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/vendor/bundle/ruby/2.4.0/gems/webpacker-3.4.1/lib/webpacker/webpack_runner.rb:11:in `exec': No such file or directory - /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/node_modules/.bin/webpack (Errno::ENOENT)
remote:         from /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/vendor/bundle/ruby/2.4.0/gems/webpacker-3.4.1/lib/webpacker/webpack_runner.rb:11:in `block in run'
remote:         from /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/vendor/bundle/ruby/2.4.0/gems/webpacker-3.4.1/lib/webpacker/webpack_runner.rb:10:in `chdir'
remote:         from /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/vendor/bundle/ruby/2.4.0/gems/webpacker-3.4.1/lib/webpacker/webpack_runner.rb:10:in `run'
remote:         from /tmp/build_b49b2f88d5ea1e404f425db2d2a8bf55/vendor/bundle/ruby/2.4.0/gems/webpacker-3.4.1/lib/webpacker/runner.rb:6:in `run'
remote:         from ./bin/webpack:15:in `<main>'
remote:        
remote:
remote:  !
remote:  !     Precompiling assets failed.
remote:  !
remote:  !     Push rejected, failed to compile Ruby app.
remote: 
remote:  !     Push failed
remote: Verifying deploy...
remote: 
remote: !       Push rejected to your-app-name.
remote:
```

### webpacker 周りのエラー

どうやら，[デフォルトの buildpacks が古いらしい](https://github.com/rails/webpacker/issues/739#issuecomment-327546884)

buildpacksを設定し直す．`buildpacks:set` `buildpacks:add` は異なるので注意．

```bash
$ heroku buildpacks:set heroku/nodejs
Buildpack set. Next release on your-app-name will use heroku/nodejs.
Run git push heroku master to create a new release using this buildpack.
$ heroku buildpacks
=== your-app-name Buildpack URL
heroku/nodejs
$ heroku buildpacks:add heroku/ruby
Buildpack added. Next release on your-app-name will use:
  1. heroku/nodejs
  2. heroku/ruby
Run git push heroku master to create a new release using these buildpacks.
$ heroku buildpacks
=== your-app-name Buildpack URLs
  1. heroku/nodejs
  2. heroku/ruby
```


### Sprockets 周りのエラー

```
remote:  !
remote:  !     A security vulnerability has been detected in your application.
remote:  !     To protect your application you must take action. Your application
remote:  !     is currently exposing its credentials via an easy to exploit directory
remote:  !     traversal.
remote:  !
remote:  !     To protect your application you must either upgrade to Sprockets version "3.7.2"
remote:  !     or disable dynamic compilation at runtime by setting:
remote:  !
remote:  !     ```
remote:  !     config.assets.compile = false # Disables security vulnerability
remote:  !     ```
remote:  !
remote:  !     To read more about this security vulnerability please refer to this blog post:
remote:  !     https://blog.heroku.com/rails-asset-pipeline-vulnerability
remote:  !
```

[Rails Asset Pipeline Directory Traversal Vulnerability (CVE-2018-3760)](https://blog.heroku.com/rails-asset-pipeline-vulnerability)

Directory Traversal 関連の脆弱性に関する指摘らしい．
エラーメッセージに記載の通り sprockets を `3.7.2` にアップデートしたら解決した．

```bash
$ gem update sprockets
```


### 再デプロイ


```bash
$ git push heroku master
Enumerating objects: 750, done.
Counting objects: 100% (750/750), done.
Delta compression using up to 8 threads.
Compressing objects: 100% (469/469), done.
Writing objects: 100% (750/750), 163.13 KiB | 8.58 MiB/s, done.
Total 750 (delta 347), reused 529 (delta 223)
remote: Compressing source files... done.
remote: Building source:

••• (中略)

remote: -----> Discovering process types
remote:        Procfile declares types     -> (none)
remote:        Default types for buildpack -> console, rake, web, worker
remote: 
remote: -----> Compressing...
remote:        Done: 103.3M
remote: -----> Launching...
remote:        Released v6
remote:        https://your-app-name.herokuapp.com/ deployed to Heroku
remote: 
remote: Verifying deploy... done.
To https://git.heroku.com/your-app-name.git
 * [new branch]      master -> master
```

## db:migrate

先程の設定でソースコードが配置されるので，`database.sample.yml` をコピーして，`database.yml` を設置する．


```bash
$ heroku run cp config/database.sample.yml config/database.yml
$ heroku run rails db:migrate RAILS_ENV=production
```

もっといいやり方でやりたい...🤔

## Basic 認証を設定

次のようなコードを追加して basic 認証を設定することができる．
`BASIC_AUTH_USER` `BASIC_AUTH_PASS` は `heroku config:set` コマンドで予め設定しておく．

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USER'], password: ENV['BASIC_AUTH_PASS'] if Rails.env == "production"
end
```


## master ブランチ以外をデプロイ

次のように suffix に `:master` つけるとそのブランチがデプロイできる．

```
# develop ブランチが heroku/master としてデプロイされる
$ git push heroku devlop:master
```

## まとめ

heroku 楽ちん😇👏✨

