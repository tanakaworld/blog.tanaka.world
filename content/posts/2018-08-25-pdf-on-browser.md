---
title: Base64 エンコードされた PDF ファイルをブラウザで扱う
slug: pdf-on-browser
date: 2018-08-25 16:43:12
tags:
- pdf
- base64
---

諸々の事情で，[Base64](https://ja.wikipedia.org/wiki/Base64) 化されたファイル文字列をブラウザで復元して扱いたいケースがあり，そのとき検証した作業ログ．画像と PDF データを扱う．

## 画像ファイルの場合

Base64 エンコードされた画像データは，`<img>` タグの `src` に指定することができる．

[Data URLs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URIs#Syntax) の形式で，次のように記述する．

```html
<!-- data:[<mediatype>][;base64],<data>  -->
<img src="data:image/png;base64,R0lGODlhAQABAIAA•••"/>
```

## PDF ファイルの場合

PDF データは，Blob に変換した後，ファイル URL を取得しアクセスすると表示できる．

```javascript
const base64Str = 'JVBERi0xLjMNCiXi48/TDQoNCjE•••';
const file = new Blob([atob(base64Str)], {
	type: 'application/pdf'
});
const fileURL = URL.createObjectURL(file);
window.open(fileURL);
```

と，思ったが正常に表示できるケースと，表示されないケースがあり，原因がわからず．．
具体的には，枠は表示されるが内容が真っ白になってしまうという状況．


## pdf.js を使う

Mozilla 製の [pdf.js](https://github.com/mozilla/pdf.js) を使うと正常に表示できた．
pdf.js には [viewer](https://mozilla.github.io/pdf.js/web/viewer.html) もついているが，.pdf ファイルの実態が必要になるので使わず，今回はファイル内容を直接扱っている．


ビルド済みのパッケージ [pdfjs-dist](https://github.com/mozilla/pdfjs-dist) を使う．

`.getDocument` で Bae64 化されたファイルを読み込み，`pdfDoc.getPage(1).render()` でファイル内容をレンダリングする．この例は，1ページだけレンダリングするが，`pdfDoc.numPages` で得られるページ数分描画すれば複数ファイル内容を一度に表示可能．


```javascript
import PDFJS from 'pdfjs-dist';

const base64Str = 'JVBERi0xLjMNCiXi48/TDQoNCjE•••';
const canvasContainer = document.createElement('div');

PDFJS.getDocument({data: atob(base64Str)}).then((pdfDoc) => {
    // 1ページ目
    const firstPage = pdfDoc.getPage(1);

    const viewport = firstPage.getViewport(options.scale);
    const canvas = document.createElement('canvas');
    canvas.height = viewport.height;
    canvas.width = viewport.width;
    canvas.style.display = 'block';
	
    const ctx = canvas.getContext('2d');
    const renderContext = {
        canvasContext: ctx,
        viewport: viewport
    };

	// 1ページ目がレンダリング完了したら，別タブにファイル内容を表示
    return firstPage.render(renderContext).then(() => {
        canvasContainer.appendChild(canvas);
		
        const win = window.open("");
        win.document.body.appendChild(canvasContainer);
    });
});
```

## まとめ

[pdf.jsのソースコード](https://github.com/mozilla/pdfjs-dist/blob/master/lib/display/api.js#L127-L138) を追った感じだと，

- Base64 文字列を Byte 配列( Uint8Array ) に変換
- ファイルを構築する処理を Woker に委譲 (`GetDocRequest` メッセージ + Bytes を Worker に送信)
- Worker 内で `WorkerMessageHandler.createDocumentHandler` が呼ばれる
- PDFManager 内部で PDFDocument.prototype.parse でパース ([PDF の構文](http://www.pdf-tools.trustss.co.jp/Syntax/parsePdfProc.html)に基づく)

という処理の流れ．
実際のパース処理がかなり複雑で全部読んでいないが，自分で実装するのはかなりツラそう．．
前述の Blob に変換する方式だと内部で PDF 構造の判別をしているわけではないので，正常に表示されないのも当たり前な気がする．

