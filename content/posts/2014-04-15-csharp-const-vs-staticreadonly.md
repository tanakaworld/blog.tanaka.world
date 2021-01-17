---
title: 【C#の定数】const と static readonly の使い分け
slug: csharp-const-vs-staticreadonly
date: 2014/04/15 19:04
tags:
- csharp
---
C#で時々迷う定数定義，const と static readonly の使い分けに関するまとめ．

<!--more-->
<h2 class="page-heading">const</h2>
constフィールドは，コンパイル時定数の扱い．（[MSDN](http://msdn.microsoft.com/ja-jp/library/e6w8fe1b.aspx "MSDN") ）

- 変数のように扱える**定数（**暗黙的 static**）**
- **宣言時にのみ**初期化可能（コンパイル時に値が埋め込まれる）
- readonly より実行速度が速い
- switch文やデフォルト引数に使える
- インスタンスを new した結果は割り当てられない（C#の組み込み型のみ）

<h2 class="page-heading">readonly</h2>
readonlyフィールドは，実行時定数の扱い．（[MSDN](http://msdn.microsoft.com/ja-jp/library/acdd6hb7.aspx "MSDN")）

- 実際は，読み取り専用の代入不可な**変数**
- 宣言時の他に，**コンストラクタ内でも**初期化可能
- 定数であるconstよりは，僅かに実行速度が遅い
- switch文やデフォルト引数には使えない
- インスタンスを new した結果を割り当てられる

<h2 class="page-heading">static readonly</h2>
constが使いたいけど，使えない場合に，static readonly を使用する．
<blockquote>定数値のシンボル名が必要で，その値の型を const 宣言で使用できない場合，またはその値をコンパイル時に計算できない場合は，static readonly フィールドが役に立ちます．([MSDN - 定数用の static readonly フィールド](http://msdn.microsoft.com/ja-jp/library/aa645753(v=vs.71).aspx "MSDN - 定数用の static readonly フィールド"))</blockquote>
<h2 class="page-heading">まとめ</h2>
基本的に，static readonly を使用する．
<div>constは，属性に指定するパラメータや列挙型の定義など，コンパイル時に値が必要な場合にのみ使用する．</div>
[Effective C# ](http://www.amazon.co.jp/Effective-C-4-0-%E3%83%93%E3%83%AB%E3%83%BB%E3%83%AF%E3%82%B0%E3%83%8A%E3%83%BC/dp/4798122513/ref=sr_1_1?s=books&amp;ie=UTF8&amp;qid=1397487209&amp;sr=1-1&amp;keywords=Effective+C%23 "Effective C# ")でも，const よりも readonly の使用が推奨されている．
<blockquote>高いパフォーマンスが求められていて，なおかつ将来にわたって変更されることがないことが明らかな場合にのみコンパイル時定数を使用するべきです．</blockquote>
