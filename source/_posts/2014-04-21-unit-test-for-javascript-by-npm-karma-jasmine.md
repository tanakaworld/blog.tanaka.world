---
layout: post
title: 【npm + Karma + Jasmine】JavaScriptの単体テスト環境を構築する
date: 2014/04/21 19:20
tags:
    - javascript
    - jasmine
    - karma
    - testing
---
JavaScriptの単体テスト環境構築のまとめ．

テストランナーとして「[Karma](https://github.com/karma-runner/karma "Karma")」，テストフレームワーク・アサーションライブラリとして「[Jasmine](http://jasmine.github.io/ "Jasmine")」を使う．

PCのグローバル領域にこれらをインストールしても環境構築はできるが，今回はプロジェクト固有のツールとしてインストールする．

これによって，PCの環境に依存しないテスト環境が構築できる．

<!--more-->
<h2 class="page-heading">前提条件</h2>
下記が使用できること．

- node
- [npm ](https://github.com/npm/npm "npm ")(= node package manager)

検証環境

- MacOS X 10.9.2

<h2 class="page-heading">$ npm init</h2>

- 対話形式でprojectの初期設定をする．
- 不要な項目は，空欄のままEnter
- 最終的に，package.jsonファイルが生成される（直接編集も可）

<img alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/console12.png" width="600" />
<h2 class="page-heading">$ npm install --save-dev karma</h2>

- node_modules/が生成され，その中に karma 関連ファイルが格納される
- option「--save-dev」によって，install 対象の library 情報が自動で package.json に記述される

[code language="javascript" title="package.json" highlite="12"]
{
  &quot;name&quot;: &quot;JSTestSample&quot;,
  &quot;version&quot;: &quot;0.0.0&quot;,
  &quot;description&quot;: &quot;Sample for JS Test.&quot;,
  &quot;main&quot;: &quot;index.js&quot;,
  &quot;scripts&quot;: {
    &quot;test&quot;: &quot;node_modules/karma/bin/karma start&quot;
  },
  &quot;author&quot;: &quot;&quot;,
  &quot;license&quot;: &quot;not commedical&quot;,
  &quot;devDependencies&quot;: {
    &quot;karma&quot;: &quot;~0.12.9&quot;
  }
}
[/code]
<h2 class="page-heading">$ node_modules/karma/bin/karma init</h2>

- 対話形式で情報を入力
- karma.conf.jsが作成される
- package.json に jasmine 関連ファイルと，chrome-lancher が記述される

<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/f7b5a0c19662aca94a8b1185006aff11.png" width="500" />

[code language="javascript" title="package.json" heighlite="3,4"]
&quot;devDependencies&quot;: {
 &quot;karma&quot;: &quot;~0.12.9&quot;,
 &quot;karma-jasmine&quot;: &quot;~0.1.5&quot;,
 &quot;karma-chrome-launcher&quot;: &quot;~0.1.3&quot;
 }
[/code]
<h2 class="page-heading">プロダクトコードとテストコードを作成</h2>

- jasmineの文法で（http://jasmine.github.io/）

[code language="javascript" title="Logic.js"]
function Logic() {

}

Logic.prototype.squaredNumber = function(num){
    return num * num;
};
[/code]

[code language="javascript" title="LogicTest.js"]
describe(&quot;TestSample&gt;&quot;, function(){
    describe(&quot;Logic&gt;&quot;, function() {
        it(&quot;multiNumber&quot;, function() {
            var target = new Logic();
            var num = 3;
            var expected = 10;

            var result = target.squaredNumber(num);

            expect(expected).toEqual(result);

        })
    });
});
[/code]
<h2 class="page-heading">テストコマンドを package.json に記述</h2>
[code language="javascript" title="package.json"]
{
  &quot;name&quot;: &quot;JSTestSample&quot;,
  &quot;version&quot;: &quot;0.0.0&quot;,
  &quot;description&quot;: &quot;Sample for JS Test.&quot;,
  &quot;main&quot;: &quot;index.js&quot;,
  &quot;scripts&quot;: {
    &quot;test&quot;: &quot;node_modules/karma/bin/karma start&quot;
  },
  &quot;author&quot;: &quot;&quot;,
  &quot;license&quot;: &quot;not commedical&quot;,
  &quot;devDependencies&quot;: {
    &quot;karma&quot;: &quot;~0.12.9&quot;,
    &quot;karma-jasmine&quot;: &quot;~0.1.5&quot;,
    &quot;karma-chrome-launcher&quot;: &quot;~0.1.3&quot;
  }
}
[/code]
<h2 class="page-heading">テストに関連するファイルを karma.conf.js に記述</h2>
[code language="javascript" title="karma.conf.js"]
    // list of files / patterns to load in the browser
    files: [
        // main files
        './main/Logic.js',

        // test files
        './test/LogicTest.js'
    ],
[/code]
<h2 class="page-heading">テスト実行</h2>
「$ npm test」で package.json の情報を元にテストが実行される

<span style="font-size: 14px; line-height: 1.5em;">chromeが自動で起動する</span>

<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/9543f2264fdc21a1e9324dedb508ef50.png" width="500" />

テスト成功

<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/92b6b0307cd4d648c7eb2c0d593333dc.png" width="500" />

失敗した時はこんな感じ

<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/92b6b0307cd4d648c7eb2c0d593333dc1.png" width="500" />

<span style="text-decoration: underline;"><span style="color: #555555; font-size: 16px; font-weight: bold; line-height: 1.5em;">まとめ</span></span>

- $ npm init
- $ npm install --save-dev karma
- $ node_modules/karma/bin/karma init
- プロダクトコードとテストコードを作成
- テストコマンドを package.json に記述
- テストに関連するファイルを karma.conf.js に記述
- テスト実行
