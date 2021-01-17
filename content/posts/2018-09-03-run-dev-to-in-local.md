---
title: dev.to をローカルで動かす
slug: run-dev-to-in-local
date: 2018-09-03 23:37:51
tags:
- dev.to
- ruby
- rails
---

2018/08/08 に [dev.to](https://dev.to) が OSS 化された．

[dev.to is now open source](https://dev.to/ben/devto-is-now-open-source-5n1)

とりあえずローカルで動かすまでにやったことのメモ．

## Getting Started

[Getting Started](https://github.com/thepracticaldev/dev.to#getting-started) が充実している．ほぼその通りに進めれば問題ない．Ruby は最新版が必要，DB は PostgreSQL．長年 Rails 触っているが地味に PostgreSQL 使ったことがなかった．

```
$ ruby -v
=> Ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin17]

$ brew install postgresql
$ postgres -V
=> postgres (PostgreSQL) 10.5
$ pg_ctl -D /usr/local/var/postgres start

# Stop
$ pg_ctl -D /usr/local/var/postgres stop
```


```bash
$ gem install bundler
$ gem install foreman
```

[`foreman`](https://github.com/theforeman/foreman) は複数プロセスをまとめて管理できるツール．
ローカル実行時は

- Rails サーバ (puma)
- Webpacker (webpackのラッパー，webpack の実行と hot-reload が走る)
- Job ([DelayedJob](https://github.com/collectiveidea/delayed_job_active_record))

が実行される．

```yaml
# Procfile.dev
web: bin/rails s -p 3000
webpacker: ./bin/webpack-dev-server
job: bin/rake jobs:work
```

## Environment Variables

[figaro](https://github.com/laserlemon/figaro) を使って YAML ファイルで環境変数を管理している．

```bash
$ cp config/sample_application.yml config/application.yml
```

**Algolia**

サイト内コンテンツの検索で使われている．ローカル実行前に必ず設定が必要になる．
[DEV Docs > Getting API Keys for Dev Environment > Algolia](https://docs.dev.to/get-api-keys-dev-env/#algolia) に沿って，会員登録＋ Credentials を発行する．


**GitHub** or **Twitter**

ログインを試すのに必要．ログインせずに試すのであればなくてもOK．こちらも丁寧にドキュメントに手順が記載されている．

- [Twitter App](https://docs.dev.to/get-api-keys-dev-env/#twitter-app)
- [GitHub](https://docs.dev.to/get-api-keys-dev-env/#github)



発行したキーを application.yml に設定する．


## Set up

```bash
$ bundle install
$ bin/yarn
$ bin/setup
```

`setup` 内で `User` や `Article` などのダミーデータが生成され，ほぼ本番環境と同じ表示が再現できる．


## Start
```
$ bin/startup
```

![first-page-in-local.png](first-page-in-local.png "first-page-in-local")


## おまけ

オフラインになると，お絵かきができるらしいw
ローカルでサーバ立ち上げて，一度ブラウザで表示した後，サーバ閉じると表示された．

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">You can draw a picture when <a href="https://t.co/eViI03eKVa">https://t.co/eViI03eKVa</a> is being offline 😇🎨🖌 <a href="https://t.co/F2xEM4Yruv">pic.twitter.com/F2xEM4Yruv</a></p>&mdash; tanakaworld 🧢 (@_tanakaworld) <a href="https://twitter.com/_tanakaworld/status/1036630495843381248?ref_src=twsrc%5Etfw">September 3, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

