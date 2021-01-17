---
title: Eclipseの文字コード設定を一括変換する方法
slug: eclipse-batch-converte-character-code
date: 2014/04/23 08:10
tags:
- eclipse
---
【Eclipseの文字コード設定を一括変換する方法】
以下のライブラリを使用する

文字コードを一括変換する Eclipse プラグイン CharsetConv​
<h2 class="page-heading">プラグインを使う</h2>
(ex)以下の設定の場合の対応
-----------------------------------------------------
Workspace Text File Encoding : MS932(Windowas31J)
Project Encoding : MS932(Windowas31J)
-----------------------------------------------------

① Workspace Text File Encoding 変更
Eclipse Status Bar &gt; Window &gt; Preference &gt; General
&gt; Workspace &gt; Text file encoding &gt; 「MS932 → UTF-8」
② 文字化けする
③ ソースの Encoding 変更
変更対象パッケージを右クリック　＞　文字コード変換　＞　「Windowas31J → UTF-8」
④ 完了
<h2 class="page-heading">そもそもエディタの文字コード設定をあらかじめしておく</h2>
エディタの文字コード設定を始めにしておくこと推奨．

Eclipse : XXX &gt; XXX &gt; XXX

VisualStudio : XXX &gt; XXX &gt; XXX
