---
layout: post
title: WebStormとレンタルサーバの連携方法
date: 2014/02/07 18:35
cover: fxd-memo.svg
tags:
    - webstorm
    - sakurainternet
---
<div>WebStormとレンタルサーバの連携でハマったので，まとめておきます．</div>
<div></div>
<div>さくらインターネットのレンタルサーバにWebStorm上からFTPでデプロイします．</div>
<div></div>
<div><!--more--></div>
<div></div>
<div>
<h2 class="page-heading">レンタルサーバの設定確認</h2>
</div>
<div>** <span style="text-decoration: underline;">①ログイン</span>**</div>
<div></div>
<div><a title="さくらインターネットコントロールパネル" href="https://secure.sakura.ad.jp/rscontrol/" target="_blank">さくらインターネットコントロールパネル</a>にログインします．</div>
<div></div>
<div></div>
<div><img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/sakura-server-controlpanel.png" /></div>
<div></div>
<div></div>
<div><span style="text-decoration: underline;">**②情報の確認**</span></div>
<div></div>
<div>サーバ情報とパスワード ＞ サーバ情報の表示 にアクセスし，下記を確認します．</div>
<div>

- FTPホスト名
- FTPサーバ
- FTPアカウント

</div>
<div></div>
<div><span style="font-size: 14px; line-height: 1.5em;"> </span></div>
<div></div>
<div>
<h2 class="page-heading">WebStormでの設定</h2>
</div>
<div></div>
<div></div>
<div><span style="text-decoration: underline;">**③Connection**</span>Connectionタブにサーバ情報を追加します．</div>
<div>下記の通り指定します．

- Type : FTP
- FTP Host : ＜FTPホストアドレス＞
- Port : 21
- Root path : /home/&lt;FTPアカウント名&gt;/www
- User name : &lt;FTPアカウント名&gt;
- Password : サーバコントロールパネルのログインパスワード

</div>
<div></div>
<div><img class="img-frame alignnone" alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/Deployment_Connection.png" width="731" height="654" /></div>
<div></div>
<div></div>
<div></div>
<div><span style="text-decoration: underline;">**④接続確認**</span></div>
<div></div>
<div>FTP Test Connection をクリックし接続を確認します．</div>
<div>正しく接続できると下記が表示されます．</div>
<div></div>
<div><img alt="" src="file:///C:/Users/TANAKA~1/AppData/Local/Temp/enhtmlclip/Deployment_Test-Connection.png" /></div>
<div> <img class="img-frame " alt="" src="http://yutarotanaka.com/blog/wp-content/uploads/2014/01/Deployment_Test-Connection.png" /></div>
<div></div>
<div></div>
<div><span style="text-decoration: underline;">**⑤Mapping**</span></div>
<div>Mappingsタブを選択し，下記を設定します．</div>
<div></div>
<div>

- Deployment path : ＜www以下の任意のディレクトリ＞

</div>
<div></div>
<div>www直下にデプロイしたい場合は，Deployment Path に「/」を指定します．</div>
<div></div>
<div>
<h2 class="page-heading">デプロイ</h2>
</div>
<div><span style="text-decoration: underline;">**⑥デプロイ実行**</span></div>
<div></div>
<div>Project Viewerでデプロイしたい対象を右クリック＞Deployment ＞Upload to XXX で，選択した対象をデプロイできます．</div>
<div></div>
<div></div>
<div><span style="text-decoration: underline;">**⑦デプロイ確認**</span></div>
<div></div>
<div>デプロイ結果は，<a title="ファイルマネージャー" href="https://secure.sakura.ad.jp/rscontrol/rs/fileman2/" target="_blank">ファイルマネージャー</a>から確認できます．</div>
