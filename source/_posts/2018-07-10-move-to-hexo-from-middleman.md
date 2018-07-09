---
title: Middleman から Hexo に引っ越した
date: 2018-07-10
tags:
    - blog
    - hexo
---

## ブログフレームワークを hexo に

[Middleman](https://middlemanapp.com/) から [hexo](https://hexo.io/) に移行した．
これまで，はてなダイアリー ▶ WordPress (さくらレンタルサーバ) ▶ Middleman (GitHub Pages) と渡ってきて第４世代となる．

個人で作っているものは，技術的な検証をしたり遊んだりする場所にしたいと思っている．
[HUGO](https://gohugo.io/) とかも選択肢にあったが，最近は Node 環境で開発していることが多く，色々カスタマイズしたい性分の自分にとっては Node の方がよかった．

## ドメインを blog.tanaka.world に

[http://yutarotanaka.com/blog](http://yutarotanaka.com/blog) で運用していたブログを廃止した．
現在は全コンテンツを移行し，全部４０４ページにしているが，このドメインはなにかに使うかもしれないので，一応残しておく．

![yutarotanaka.com_404.png](yutarotanaka.com_404.png "yutarotanaka.com_404")


ちなみに，[杉並区議員に同姓同名の議員さんがいるらしく](http://blog.tanakayutaro.net/)時々間違われていた（笑）．昔は [http://tanakayutaro.com/](http://tanakayutaro.com/)だった気がするので，あちらも引っ越しされたのかな．

## GitHub Pages でサブドメインを設定

ホスティングは引き続き GitHub Pages にしている．昔はできなかったが，現在は SSL 対応も可能になっている．[tanaka.world](https://tanaka.world) の方は， Vue.js + Nuxt.js + Firebase (Hosting/CloudFunctions) でホスティングしていて，ブログはそこに混ぜたくなかった．別プロジェクトで運用するべくサブドメインにした．

GH Pages はサブドメインを設定することもできる．ルートに CNAME ファイルを設定し，DNS で `YOUR-GITHUB-USERNAME.github.io` という A レコードを設定するだけでOKらしい．

➡️ [Setting up a custom subdomain](https://help.github.com/articles/setting-up-a-custom-subdomain/#configuring-a-cname-record-with-your-dns-provider)
![お名前ドットコムのDNS設定画面](gh-pages-sub-domain.png "お名前ドットコムのDNS設定画面")

## 2018 年下期に向けて

2016 年下期 〜 2018 年上期にかけて，ブログ更新が滞っていた．
技術的なメモは時々 [Qiita](https://qiita.com/tanakaworld) にアップしていたが，ブログは下書きのまま放置されている状態になりがちだった．
2018 年下期は，アウトプットを更新を増やしていきたい．
