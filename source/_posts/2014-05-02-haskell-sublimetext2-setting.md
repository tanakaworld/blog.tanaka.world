---
layout: post
title: 【Haskell】SublimeText2 + REPL 初期設定まとめ
date: 2014/05/02 21:37
tags:
    - haskell
    - sublime-text-2
---
すこしハマった，関数型言語Haskellの開発環境構築のまとめ．

<!--more-->
<h2 class="page-heading">Haskell Platform</h2>
下記URLからdmgファイルをダウンロードし，インストールする．

[Haskell Platform for Mac OS X](https://www.haskell.org/platform/mac.html "Haskell Platform for Mac OS X")
<h2 class="page-heading">Sublime Text 2</h2>
エディタはこれを使用する．

http://www.sublimetext.com/dev
<h2 class="page-heading">Package Control</h2>

- SublimeText2 を起動する
- [View]-&gt;[Show Console] からコンソールを開く
<img class="img-frame " style="font-family: Consolas, Monaco, monospace; font-size: 12px; line-height: 18px;" alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/e76f44e42ed04da3fc3760454ee67685.png" width="300" />
- コンソールに下記のコマンドを入力し，実行
[code]
import urllib2,os;pf='Package Control.sublime-package';ipp=sublime.installed_packages_path();os.makedirs(ipp) if not os.path.exists(ipp) else None;open(os.path.join(ipp,pf),'wb').write(urllib2.urlopen('http://sublime.wbond.net/'+pf.replace(' ','%20')).read())
[/code]
- SublimeText2を再起動
- [Preference]-&gt;[Package Control]-&gt;[Package Control]  (= Command + Shift + p でも)
<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/b7425bcd1c2c4e928a9586be35a43881.png" width="400" />

<h2 class="page-heading">SublimeREPL</h2>

- 「Install Packege」と入力しEnter，さらに「SublimeREPL」を入力しインストール
<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/a1c89dbb3efd12ace9665b5a54462b4d.png" width="400" />
- SublimeText2を再起動
- [Preference]-&gt;[Package Settings]-&gt;[SublimeREPL]-&gt;[Setting - User]に，GHCのパスを記述
[code]
&quot;default_extend_env&quot;: {
 &quot;PATH&quot;: &quot;{PATH}:/usr/bin&quot;
}
[/code]

<h2 class="page-heading">コード実行</h2>

- <span style="font-family: Consolas, Monaco, monospace; font-size: 12px; line-height: 18px;"> 画面分割（command + shift + option + 2）
</span>
- [Tools]-&gt;[SublimeREPL]-&gt;[Haskell]から，haskellコンソールを開く
<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/fcaffe5637ca59bff39a9c4aeece8f58.png" width="400" />
- 「**.hs**」形式のファイルを作成し，コードを記述する
- 「control + , (カンマ) → l (エル)」選択行の実行できる
<img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/929defaf42bcc78d05d2da25b8175a66.png" width="400" />

<h2 class="page-heading">すごい Haskell 楽しく学ぼう</h2>
すごいH本こと，これの読書会をやってます．
英語版は無料 → [Learn You a Haskell for Great Good!](http://learnyouahaskell.com/ "Learn You a Haskell for Great Good!")

<iframe style="width: 120px; height: 240px;" src="http://rcm-fe.amazon-adsystem.com/e/cm?t=tanakayutaroa-22&amp;o=9&amp;p=8&amp;l=as1&amp;asins=4274068854&amp;ref=qf_sp_asin_til&amp;fc1=000000&amp;IS2=1&amp;lt1=_blank&amp;m=amazon&amp;lc1=0000FF&amp;bc1=FFFFFF&amp;bg1=FFFFFF&amp;f=ifr" height="240" width="320" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
