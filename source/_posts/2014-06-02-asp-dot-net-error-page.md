---
layout: post
title: ASP.NETのエラーページが表示されてしまうときの対策
date: 2014/06/02 19:04
tags:
    - C#
    - .NET
    - ErrorPage
    - IIS
    - Routing
---
URLに「.」が混ざると，ASP.NET でエラーページがでてしまう問題の解決法．（調査中．．．）

<!--more-->
<h2 class="page-heading">エラーページ</h2>

- 独自のエラーページ
自分でリダイレクトするように設定する
- IISのエラーページ
- ASP.NETのエラーページ

<h2 class="page-heading">ASP.NETのエラーページが出てしまうパターンと対策</h2>
<span style="line-height: 1.5em;">**URLの最後に「.」が付いてしまう場合**に下記のようなページが出る．</span>

<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/error-page-1.png" width="500" />

- 対策1
**relaxedUrlToFileSystemMapping="true"に設定する**この場合，「URLが有効な Windows ファイル パスであるかの検証」が無効になるため，推奨できない（と思われる）．
URLに指定されるパラメータに様々な文字列が含まれる可能性があり，その文字列がWindowsファイルシステムと同じ規則でバリデートされると困る場合は，これを設定すると解決できるようだ．<span style="line-height: 1.5em;">参考：http://stackoverflow.com/questions/3541426/how-to-get-asp-net-mvc-to-match-dot-character-at-the-end-in-a-route</span>
- 対策2
Web.configを下記の通り変更する変更前：&lt;httpErrors errorMode="Custom" existingResponse="Auto"&gt;
変更後：&lt;httpErrors errorMode="Custom" existingResponse="Replace"&gt;
IISが用意したレスポンスが存在した場合に，2.IISのエラーページが返されてしまうが，この対策によって，必ずカスタムエラーページを返すように設定できる．
- 対策3
**relaxedUrlToFileSystemMapping="true"**　と，**existingResponse="Auto"** に設定する．
これがベストみたいだ．

ちなみに，MSDNのページも，URLの最後に「.」がついていると，ASP.NETのエラーページが出でしまっている．
また，URLの最後に「%」が付く場合，400(Bad Request)エラーとなり，下記のページが表示される．

<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/error-page-2.png" width="500" />

[Configuring HTTP Error Responses in IIS 7](http://technet.microsoft.com/en-us/library/cc731570(v=WS.10).aspx "Configuring HTTP Error Responses in IIS 7")　によると，カスタムエラーページを表示させることはできないようだ．

このケースは，ASP.NETに到達する前段階でのエラーのため対策ができない．
