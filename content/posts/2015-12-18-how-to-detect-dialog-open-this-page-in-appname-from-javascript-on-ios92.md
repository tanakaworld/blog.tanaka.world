---
title: 【iOS9.2】Detect dialog "Open this page in APPNAME" from JavaScript 
slug: how-to-detect-dialog-open-this-page-in-appname-from-javascript-on-ios92
date: 2015/12/18
tags:
- ios
- safari
- javascript
- deeplink
---

iOS9.2でSafariからアプリを起動する際のアラート表示の仕様が変わった．

![Open thia page in Twitter](http://i.stack.imgur.com/Ts4Vb.png)

iOS9.1以前ではアラートが表示されている間はJavaScriptの実行が止まっていたが，9.2からは止まらなくなっている．
おまけにこのダイアログ、Webkitが実行しているのではなく、OSから起動されているダイアログなのでJavaScriptから検知ができないようだ．

> Given that all browser-based detection is now disabled

* [iOS 9.2 may break deeplinking](https://www.adjust.com/overview/features/2015/12/11/ios-9-2-deeplinking/)
* [How to detect dialog "Open this page in APPNAME'' from JavaScript on iOS9.2 Mobile Safari?](http://stackoverflow.com/questions/34202616/how-to-detect-dialog-open-this-page-in-appname-from-javascript-on-ios9-2-mobi)

