---
title: パラメタライズドテストケースをGoogleSpeadsheetで管理する
slug: host-test-data-by-google-spreadsheet.html
date: 2016/03/16
tags:
- google-spread-sheet
- javascript
- grunt
- karma
- jasmine
- google-spreadsheets-parser
---

**[google-spreadsheets-parser](https://github.com/tanakaworld/google-spreadsheets-parser)**を使って，
スプレッドシートで管理しているデータをテストで使用する．

## 背景:データの二重管理をなくしたい

あるJSモジュールのパラメタライズドテストコードを書いていた．
パラメータとそのテスト結果はGoogleSpreadsheetで表管理していて，ビジネス・エンジニア共に使用していた．

はじめはSpreadSheet上にそれらの値をJSで扱える形式にconcatenateとかしてコピペしていたが，
バリエーションが膨大になり，データ二重管理の問題が発生しメンテナンスに難があった．

## 普通にパラメタライズドテストを書くとこんな感じ

grunt x karma x jasmine の環境構築手順は[こちら](http://yutarotanaka.com/blog/coffeescript-grunt-karma-jasmine/)．

```coffeescript
# src/user.coffee
class User
  constructor: (@NAME, @age) ->

  canDrink: ->
    parseInt(@age) >= 20
```

```coffeescript
# src/userSpec.coffee
describe "User", ->
  describe "#canDrink", ->
    assertCanDrink = (name, age, canDrink) ->
      it "Age:#{age}, CanDrink:#{canDrink}", ->
        user = new User(name, age)
        expect(user.canDrink()).toBe(canDrink)
        
    # ここのバリエーションが増えてくると管理がツラい
    target = [
      {no: 1, name: 'User1', age: 18, canDrink: false}
      {no: 2, name: 'User2', age: 19, canDrink: false}
      {no: 3, name: 'User3', age: 20, canDrink: true}
      {no: 4, name: 'User4', age: 21, canDrink: true}
      {no: 5, name: 'User5', age: 22, canDrink: true}
    ]

    for t in target
      assertCanDrink(t.name, t.age, t.canDrink)
```

`target` 部分のバリエーションが増えてくるとスプレッドシートの変更を反映するときにミスったりして，テストが不安定になる．

## google-spreadsheets-parserを使う

インストール

```
npm install google-spreadsheets-parser --save-dev
```

パーサーを読み込む

```coffeescript
# karma.conf.coffee
files: [
      'node_modules/google-spreadsheets-parser/dist/googleSpreadsheetsParser.js'
      'src/**/*.coffee'
      'spec/**/*Spec.coffee'
    ]
```

テストコードを下記のように記述できる．
JSONの値は文字列になっているので，それぞれ調整する．

```coffeescript
# userSpec.coffee
gss = new GoogleSpreadsheetsParser(
      'https://docs.google.com/spreadsheets/d/1LjDMRm8j_0XHJiOF7DZuYWUXQHYpZ6MxRnMkh25plZ8/pubhtml'
      {sheetTitle: 'v001', hasTitle: true}
    )

target = JSON.parse(gss.toJson())

for t in target
  # JSONの値は文字列になっているので，それぞれ調整
  assertCanDrink(t.name, parseInt(t.age), t.canDrink == 'true')
```

テストデータのバージョン管理も可能．
シート毎にバージョンをわけて，バージョン毎に `sheetTitle` を分ければおｋ． 


## サンプル

[karma-jasmine-parameterized-test](https://github.com/tanakaworld/google-spreadsheets-parser/tree/master/demo/karma-jasmine-parameterized-test)

