---
title: Vue.js Tokyo v-meetup 8 に登壇しました
slug: vuejs-tokyo-v-meetup-8
date: 2018-08-30 22:24:38
tags:
- vue.js
- presentation
---


2018年8月27日に開催された [v-meetup #8](https://vuejs-meetup.connpass.com/event/95678/) に登壇しました．

約150の募集枠は，募集開始数分で埋まるほどの人気イベント．v-meetup の参加は初めてだったのですが，スタッフを始め参加者の方々の熱気に圧倒されました．

## Replace View of Backbone.js with Vue.js

2年半くらい運用していた Backbone.js SPA の一部を Vue.js でリニューアルしたときの話をしました．コアフレームワークが Backbone.Model に依存していて，Backbone.js から逃れられないプロジェクト，View 周りがツラいので組み合わせてみたら幸せになったという話です．どうしてもフルリプレイスが難しいプロジェクトとかで，小さく薄くはじめられるのが Vue.js のいいところ．2018年現在に使うのは色々ツラいところあるけど，Backbone.js 自体は嫌いではない(~~使いたいとは言っていない~~)


<script async class="speakerdeck-embed" data-id="0ba17ee105ce4746878923d89dca0cc7" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

![presentating.JPG](presentating.JPG 'presentating.JPG')

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="ja" dir="ltr">そもそもbackboneがつらい…<a href="https://twitter.com/hashtag/vuejs_meetup8?src=hash&amp;ref_src=twsrc%5Etfw">#vuejs_meetup8</a></p>&mdash; ほんだし (@hondash918) <a href="https://twitter.com/hondash918/status/1034409445655080961?ref_src=twsrc%5Etfw">August 28, 2018</a></blockquote>
<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="ja" dir="ltr">backbone.js、繋ぎ先がhtmlである必要がないのでcocos2d-jsと組み合わせて使ったりしてた。今も結構好き。 <a href="https://twitter.com/hashtag/vuejs_meetup8?src=hash&amp;ref_src=twsrc%5Etfw">#vuejs_meetup8</a></p>&mdash; hadakadenkyu (@hadakadenkyu) <a href="https://twitter.com/hadakadenkyu/status/1034409979556446208?ref_src=twsrc%5Etfw">August 28, 2018</a></blockquote>
<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="ja" dir="ltr">Vue コンポーネントの中で jQuery ライブラリ使うのあるある。 <a href="https://twitter.com/hashtag/vuejs_meetup8?src=hash&amp;ref_src=twsrc%5Etfw">#vuejs_meetup8</a></p>&mdash; katashin (@ktsn) <a href="https://twitter.com/ktsn/status/1034410590754627584?ref_src=twsrc%5Etfw">August 28, 2018</a></blockquote>
<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="ja" dir="ltr">mountedでjqueryやるの親近感。<a href="https://twitter.com/hashtag/vuejs_meetup8?src=hash&amp;ref_src=twsrc%5Etfw">#vuejs_meetup8</a></p>&mdash; Keima Kai (@keimakai1993) <a href="https://twitter.com/keimakai1993/status/1034410759004905472?ref_src=twsrc%5Etfw">August 28, 2018</a></blockquote>
<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="ja" dir="ltr">backboneとvueで共存キメラはすごい... <a href="https://twitter.com/hashtag/vuejs_meetup8?src=hash&amp;ref_src=twsrc%5Etfw">#vuejs_meetup8</a></p>&mdash; イカID: Toshiwo (@toshiwo) <a href="https://twitter.com/toshiwo/status/1034411043278258176?ref_src=twsrc%5Etfw">August 28, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## サンプルプロジェクト


[サンプルプロジェクト](https://github.com/tanakaworld/replace-view-of-backbone-with-vue)を地味にちゃんとつくった．Realm つかってみたくて，サーバのデータストアに [Realm Node.js](https://realm.io/docs/javascript/latest) を使ってみました．`yarn dev` でローカル実行できます．

<iframe width="560" height="315" src="https://www.youtube.com/embed/C-L_pAyYqEI" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>



## 関連記事

- [Togetter: Vue.js Tokyo v-meetup #8 のTweet まとめ](https://togetter.com/li/1261430)
- [Vue.js Tokyo v-meetup \#8 メモ](https://www.codeofduty.me/2018/08/28/vuejs-meetup-vol8/)
- [GASのためにVue.jsを学習し始めなのに参加してみた「Vue.js Tokyo v-meetup #8」](https://tonari-it.com/vue-js-meetup8/)
- [Vue.js Tokyo v-meetup #8 に行ってきた](https://jaxx2104.info/v-meetup8/)
