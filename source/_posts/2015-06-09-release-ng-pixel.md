---
layout: post
title: ドット絵が描けるAngularJSライブラリをリリースしました
date: 2015/06/09 08:38
tags:
    - AngularJS
---
ドット絵が描けるAngularJSライブラリをリリースしました．

[ng-pixel - Simple directive that generate pixel pattern](https://github.com/TanakaYutaro/ng-pixel "ng-pixel - Simple directive that generate pixel pattern")

<!--more-->
<h2 class="page-heading">ドット絵・ピクセルアートが簡単に描ける</h2>
<img style="max-width: 100%;" alt="ngPixel example 1" src="https://raw.githubusercontent.com/wiki/tanakayutaro/ng-pixel/images/ngPixel-Example-1.png" width="295" height="295" />

[code]&lt;ng-pixel data='' /&gt;[/code]

こんな感じで記述するだけで，ピクセルアートが描画できます．

**data=**には，[専用のエディタ](http://tanakayutaro.github.io/ng-pixel/editor/ "専用のエディタ")で作成できるJSONを指定します． 詳細の手順は[README](https://github.com/TanakaYutaro/ng-pixel/blob/master/README.md "README")に記述しているので，そちらで．
<h2 class="page-heading">「ng-pixel」</h2>
ライブラリ名は，ドット絵なので「ng-dots」にしていたのですが，英語でドット絵というと，○で描かれた絵のことを指すよう．
なので，ピクセルアートという意味合いで「ng-pixel」にしました．

元々，[このページ](http://yutarotanaka.com/ "このページ")で自分用に実装していた処理を，AngularJSのOSSとしてリリースしました．
いわゆるオレオレライブラリだったので，OSSとして公開するためにやった工程がめんどくさくて勉強になりました．

公開できる自動テストかいてなかったり，セルのイベントバインディングとかは，未実装なので，今後機能拡張リリースする予定です．
