---
title: スクリーンショット駆動開発
slug: screenshot-driven-development
date: 2018-07-03
tags:
- dev
---

アプリケーション開発をしていて，日々，スクリーンショットに助けられている．
主に情報共有やバグトリアージ，メモ目的でよく使っているツールなどをまとめる．

## Gyazo

[Gyazo](https://gyazo.com)

撮影したスクリーンショットをURLで共有できるサービス．アプリケーション起動すると， Gyazo のスクリーンショットモードになり撮影するとブラウザで URL が表示される（そのときに URL がクリップボードにコピーされる）．同様に GIF 動画も撮影でき，実装時の UI 表現の共有で使ったりする．

**Slack でのスクショ共有**

特に重宝しているのが，Slackでスクショ共有するとき．
Slack の Thread では画像の添付ができず，メイン側に画像をアップロードしてその URL を Thread 側にコピペする，という手間をかけていた．Gyazo なら Thread に URL を投稿するだけでハイライトもされるし，楽チン．

**Gyazo Pro**

[有料課金](https://gyazo.com/pro)するか迷っている．
６秒まで録画可能で，有料課金すると６０秒まで録画できるみたい．サービス画面のキャプチャ撮りたいときは，１０秒だと足りないことがあるので，課金してもいいかなと思っている．それとキャプチャした画像に文字を入れるなど加工もできる点も魅力的．

キャプチャに文字を入れたいシーンはわりとある．
[skitch](https://evernote.com/products/skitch) にスクショを貼り付けて加工した結果を，Gyazo で再度キャプチャするというフローを踏んでいてとても手間を感じている．てか，skitch って Evernote のサービスだったのか．(2011年に買収されたらしい)

## Mac Screenshots

**範囲選択スクショ**

をよくつかう．

- スクリーンショットフォルダに保存：command + shift + 4
- クリップボードに保存：command + shift + control + 4

スクリーンショットはデフォルトではデスクトップに保存されるが，Dropbox の機能で Dropbox フォルダに保存されるようにしている．


**スクリーンショットモード中の "スペースキー" が便利．**

スクショ範囲をフォーカスしているアプリケーションが，自動的にスクショ範囲になる機能．
アプリケーションウィンドウだけでなく，ナビゲーションバーやアイコンにも自動フォーカスしてくれる．

[![https://gyazo.com/8aeaa9df2b1c7649928ef9352ff5e2c1](https://i.gyazo.com/8aeaa9df2b1c7649928ef9352ff5e2c1.gif)](https://gyazo.com/8aeaa9df2b1c7649928ef9352ff5e2c1)

## Chrome Dev Tools

DOMなどのスクリーンショットを取ることができる．

- Chrome Dev Tools で command + shift + p
- "capture" で検索
- 例えば，capture node screenshot を選択すると，Dev Tools で選択している node のスクショが撮影できる

![chrome-dev-tools-1](/images/2018-07-03-screenshot-driven-development/chrome-dev-tools-1.png "chrome-dev-tools-1")


## モバイルのスクリーンショット

iPhone でもよくスクリーンショットを使うので，Photo 容量を圧迫してしまう．ワンタップでスクリーンショットが削除できる[スクショケシ](https://itunes.apple.com/app/id1355436253)というアプリを使っている．タベリーを開発している10xさんが開発しているらしい．UI のトーンがかわいい．

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">スクショケシで2マイのスクショをケシました <a href="https://twitter.com/hashtag/%E3%82%B9%E3%82%AF%E3%82%B7%E3%83%A7%E3%82%B1%E3%82%B7?src=hash&amp;ref_src=twsrc%5Etfw">#スクショケシ</a> <a href="https://t.co/dCKaJqBruu">https://t.co/dCKaJqBruu</a> <a href="https://t.co/FNZByFNvw8">pic.twitter.com/FNZByFNvw8</a></p>&mdash; tanaka.world ™ (@_tanakaworld) <a href="https://twitter.com/_tanakaworld/status/981051538608046080?ref_src=twsrc%5Etfw">April 3, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


## まとめ

No Screenshot No Life
