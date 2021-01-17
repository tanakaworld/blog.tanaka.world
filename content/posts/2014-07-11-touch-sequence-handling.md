---
title: 【スマホ対応】jQuery 連続スワイプイベントをハンドリングする方法
slug: touch-sequence-handling
date: 2014/07/11 08:57
tags:
- Javascript
- jQuery
---
スマートフォンなどで，**連続スワイプ**のハンドリング方法をまとめておきます．

指が触れ始めたときのDOMや，離れた瞬間のDOMは簡単に取得できましたが，**「今」指が触れている**DOMを取得するのに苦戦しました．

先日行ったデザインリニューアル（[YutaroTanaka.com](http://yutarotanaka.com/ "YutaroTanaka.com")）でも，この方法を使ってスマホのスワイプ対応をしています．

<!--more-->
<h2 class="page-heading">やりたいこと</h2>
「このような要素をタッチしたときに，触れたところの色を変えたい」
「ひとつひとつタップするのではなく，指でなぞった部分の色を変えたい」

<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/TouchSequence.png" width="400" />

タッチ対象は，下記のような spanタグを用意して，CSSで成形します．

[code language="html" title="HTML"]
    &lt;span class=&quot;panel&quot;&gt;1&lt;/span&gt;
    &lt;span class=&quot;panel&quot;&gt;2&lt;/span&gt;
     ・・・
    &lt;span class=&quot;panel&quot;&gt;20&lt;/span&gt;
[/code]
<h2 class="page-heading">【PC】mouseenter イベントをハンドリングする</h2>
$('.panel') でタッチ対象の要素を取得し，.on() で mouseenter イベントにイベントハンドラをセットします．

ハンドラ内では，タッチ対象が class = "panel" を持っているとき，背景色を変えます．

（今回は class = "green" に対して CSS で背景色をつけています）

[code language="javascript" title="JavaScript"]
$().ready(function () {
    $('.panel').on({
        'mouseenter': function () {
            var target = $(this);
            if (target.hasClass('panel')) {
                target.addClass('green');
            }
        }
    });
});
[/code]

マウスが触れた瞬間に，その要素の色が変化します．
<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/TouchSequence-2.png" width="400" />
<h2 class="page-heading">【スマホ①】touchstart, touchend, touchmove を試すも．．．</h2>
touchstart, touchend, touchmove などのイベントが発生した時の要素の要素取得を試みました．

ハンドラ内の記述「var target = $(this); 」で取得できるのは，タッチした瞬間の要素です．

そのため，スマホに指をつけたときの要素は色が変るけど，指を放さずに画面上を動かしても，target は変化しません．

[code language="javascript" title="JavaScript"]
$().ready(function () {
 $('.panel').on({
        'touchmove': function (event) {
            var target = $(this);
            if (target.hasClass('panel')) {
                target.addClass('green');
            }
        }
    });
});
[/code]

<span style="font-size: 14px; line-height: 1.5em;">また，event オブジェクトの持つ </span>event.originalEvent の，changedTouches, currentTarget, target, targetTouches, touches, ... などでは，指が触れているDOMは取得できず，結果は同じでした．

[code language="javascript" title="JavaScript"]
$().ready(function () {
 $('.panel').on({
        'touchmove': function (event) {
            var target = event.XXXXXXX;
            if (target.hasClass('panel')) {
                target.addClass('green');
            }
        }
    });
});
[/code]
<h2 class="page-heading">【スマホ②】touchmove + position + elementFromPoint</h2>
試行錯誤した結果，

「touchmove イベント時のハンドラ内で，event が起こったポジションを取得し，そのポジションにある要素を取得する．」

これで解決しました．

touchmove イベントは，タッチデバイスの画面を指でなぞっている間連続して発生します．

その際に，event オブジェクトで取得できる指の座標を，指定された座標上にある要素を取得できる[document.elementFromPoint(X, Y) ](https://developer.mozilla.org/ja/docs/DOM/document.elementFromPoint "document.elementFromPoint(X, Y) ")に渡します．

[code language="javascript" title="JavaScript"]
$().ready(function () {
    $('.panel').on({
        'touchmove': function (event) {
            var touch = event.originalEvent.touches[0];
            var target = $(document.elementFromPoint(touch.clientX, touch.clientY));

            if (target.hasClass('panel')) {
                target.addClass('green');
            }
        }
  });
[/code]
<h2 class="page-heading">まとめ</h2>
最終的には下記の通り，mouseenter, touchmove イベントにそれぞれハンドラをセットすることで，PCでもスマートフォンでも連続タッチイベントが取得できました．

[code language="javascript" title="JavaScript"]
    $('.panel').on({
        'mouseenter': function () {
            var target = $(this);
            if (target.hasClass('panel')) {
                target.addClass('green');
            }
        },
        'touchmove': function (event) {
            var touch = event.originalEvent.touches[0];
            var target = $(document.elementFromPoint(touch.clientX, touch.clientY));

            if (target.hasClass('panel')) {
                target.addClass('green');
            }
        }
    });
[/code]

イベントをハンドルするときに，**座標からアプローチする**という発想がなかなか出てこなかったので，メモです．
<ul class="bullet_check imglist">
- 上記を利用してリニューアルしたページ
<a class="button" style="background-color: #2181e0;" href="http://yutarotanaka.com/">YutaroTanaka.COm </a>

<ul class="bullet_check imglist">
- デモ
<a class="button" style="background-color: #2181e0;" href="http://jsfiddle.net/tanaka_yutaro/dF4Ly/2/">DEMO（JSFIDDLE）</a>
