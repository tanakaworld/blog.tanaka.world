---
title: GoogleSpreadsheetをパースするライブラリを作った
date: 2016/03/15
tags:
    - google-spread-sheet
    - javascript
---

GoogleSpreadsheetをJSONにパースするライブラリを作った．

**[google-spreadsheets-parser](https://github.com/tanakaworld/google-spreadsheets-parser)**

JSで使用する前提で作っていて，ブラウザやNodeで使用できる．
シートのURLとシート名を指定するとObject形式・JSON形式にパースできる．

```javascript
var gss = new GoogleSpreadsheetsParser(publishedUrl, {sheetTitle: 'Sample', hasTitle: true});
```

ライブラリのセットアップなど詳しくは[README](https://github.com/tanakaworld/google-spreadsheets-parser/blob/master/README.md)にて．

半年くらい実プロジェクトでも使用してみて，割りと汎用的に使えたのでいろいろ拡張していく予定．

動作デモなどは[こちら](https://github.com/tanakaworld/google-spreadsheets-parser#demo)
