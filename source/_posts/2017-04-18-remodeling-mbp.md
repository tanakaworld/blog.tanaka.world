---
title: MacBookProのバッテリー/メモリ/HDDをセルフ交換し，Ubuntuをデュアルブートする
date: 2017-04-18
tags:
    - mac
    - hardware
    - ubuntu
---

古いMacのバッテリーが膨張してしまっていたため，バッテリーを交換した．
ついでにパワーアップ(メモリを増設＋HDD→SSD)，さらに機械学習用 Mac とするべく Ubuntu を入れてみた．

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">MacBookPro 2012 mid 15 inch <a href="https://twitter.com/hashtag/%E9%96%8B%E5%B0%81%E3%81%AE%E5%84%80?src=hash&amp;ref_src=twsrc%5Etfw">#開封の儀</a> 昔使ってたMacが机にまっすぐ置けないと思ったら、バッテリーが膨張してたorz 開封ついでにメモリ増設とHDD→SSDもやるやつ。 <a href="https://t.co/fprl1XQYYi">pic.twitter.com/fprl1XQYYi</a></p>&mdash; tanaka.world ™ (@_tanakaworld) <a href="https://twitter.com/_tanakaworld/status/852765675084840960?ref_src=twsrc%5Etfw">April 14, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## 工具

必要な工具やパーツは Amazon で購入した．

[アネックス(ANEX) ESD精密ドライバー +00×50 No.3450-ESD](https://www.amazon.co.jp/gp/product/B0162MMGPQ/ref=oh_aui_search_detailpage?ie=UTF8&psc=1)
← HDD を止めてるネジを外すのに必要
[アネックス(ANEX) T型ヘクスローブドライバー T6×50 No.6300](https://www.amazon.co.jp/gp/product/B002SQLDSM/ref=oh_aui_search_detailpage?ie=UTF8&psc=1)
← Macの蓋をあけるのに必要


## バッテリー/SSD/メモリ

**バッテリー**
~~[WorldPlus バッテリー Apple MacBook Pro 15 インチ 対応 A1382 A1286 ( 2011 2012 ) 6200mAh](https://www.amazon.co.jp/gp/product/B01MPZWGUH/ref=oh_aui_search_detailpage?ie=UTF8&psc=1)~~
[SLODA交換用バッテリーApple用Macbook Pro 15" A1321 A1286 (Mid 2009 Early 2010 Late 2010) に适用MacBook Pro 15 A1321 ノートPCバッテリー [リチウムポリマー，10.95V, 7200mAh]](https://www.amazon.co.jp/gp/product/B01A6F406I/ref=oh_aui_search_detailpage?ie=UTF8&psc=1)

誤って型違い用を購入してしまったので返品し代わりを書い直した．
完全に `MacBookPro 2012 mid 15 inch` だと思ってたらもっと前のだった．
型番によってバッテリーの接続口の形が異なるので，[Appleの公式のサイト](https://support.apple.com/en-us/ht204308)から型番を確認しようorz


**SSD**
[Crucial [Micron製] 内蔵SSD 2.5インチ MX300 525GB ( 3D TLC NAND /SATA 6Gbps /3年保証 )国内正規品 CT525MX300SSD1/JP](https://www.amazon.co.jp/gp/product/B06XTHWT6Q/ref=oh_aui_search_detailpage?ie=UTF8&psc=1)


**メモリ**

[シリコンパワー ノートPC用メモリ DDR3 1600 PC3-12800 8GB×2枚 204Pin Mac 対応 永久保証 SP016GBSTU160N22](https://www.amazon.co.jp/gp/product/B0094P98FK/ref=oh_aui_search_detailpage?ie=UTF8&psc=1)

デフォルトだと 2GB x 2 = 4GB しか積まれていなかったので，8GB x 2 = 16GB にアップグレードする．

![Memory 2GB x 2](memory-2gx2.JPG "Memory 2GB x 2")

## バッテリー+メモリ交換

それぞれ交換して起動するも，Apple マークでフリーズする．
カーネルパニックが発生してるっぽい．

[セーフモード](https://support.apple.com/ja-jp/HT201262)で起動し直してみると，起動時に画面が虹色にグラデーションした．
その後デスクトップが表示されるが、その後自動で再起動されてしまう．


メモリとバッテリーを同時に交換してしまったので、問題切り分けのためにメモリを一旦元に戻す．

## バッテリー交換

バッテリー交換は完了．
バッテリーだけ交換した場合，正常起動したので，メモリが問題とわかった．

## メモリ交換

![exchange memory](exchange-memory.JPG "exchange memory")

何をやってもカーネルパニックが解決できず．
メモリに関しては後回しにすることにした．

![kernel panic](kernel-panic.png "kernel panic")

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">Macのメモリ交換したんだが、一向に起動しない… <a href="https://t.co/Z5wkQCmNV6">pic.twitter.com/Z5wkQCmNV6</a></p>&mdash; tanaka.world ™ (@_tanakaworld) <a href="https://twitter.com/_tanakaworld/status/854156952691068928?ref_src=twsrc%5Etfw">April 18, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

**参考**
- [NVRAMをリセットすると解決する説](https://support.apple.com/ja-jp/HT204063)
- [老兵は死なず！MacBook Pro Mid 2010 復活計画発動！【調査編】](http://clockworkapple.me/?p=17595)
- [MacBook，MacBook Pro 13, Mac mini Mid 2010 が16GB（8GBｘ2）に対応！](http://vintagecomp.livedoor.biz/archives/51738907.html)
- [MacBookPro Mid2010でメモリ16GBに増設できました。](http://blog.notsobad.jp/entry/54791577771)
- [MacMacBook Pro (15-inch, Mid 2010)で16GB(8GB×2)メモリは使えるか](http://d.hatena.ne.jp/houmei/20130312/1363065663)

## HDD を SSD に交換

SSDに交換して起動したところ，Disk Unitility で `Uninitialized` になっていた．
SSDもフォーマットする必要がありそう．
次の手順でフォーマットした．
※ HDDのデータは完全に消えてもOKだったので，データ移行はしていない．

- Disk Unitility > SSD を選択
- Format: Mac OS Extended (Journaled)
- Type: GUID Partition Map
- Clean up
- Internet Recovery で最新のOSをDL&インストール
- 完了

![exchange to ssd](exchange-to-ssd.JPG   "exchange to ssd")


**参考**
- [Disk Utility for macOS Sierra: Erase a volume using Disk Utility](https://support.apple.com/kb/ph22241?locale=en_US)
- [Mac で新しい SSD を使用する際に「このコンピュータで読み取れないディスクでした」と表示された場合のフォーマットの方法](http://tokyo.secret.jp/macs/format-ssd.html)

## UbuntuとOS Xをデュアルブートする

ブートローダー rEFInd を使って，OS X と Ubuntu を切り替えられるようにする．

### Ubuntu用のパーティションを設定

- macOS Utilities
- Disk Utility
- 既存のHDDを初期化（選択してErase）
- Reinstall Mac OS
- Partition Dividing (Ubuntu専用マシンにするので，OS X: 20GB / Ubuntu: 480GB の構成にした）
- Application > Utilities > DiskUtility

### rEFInd インストール

OS X は起動し

- [rEFInd](http://www.rodsbooks.com/refind/getting.html) から `A binary zip file` をDL
-  [SIP対策](http://www.rodsbooks.com/refind/sip.html)のため，リカバリーモードで起動 (⌘+Rしながら，電源ボタンを押す)
- OSX Utility > Utility > Terminal を起動
- DLしたディレクトリ内に移動し `refind-install.sh` を実行
```bash
cd /Volumes/path/to/binary-dir
./refind-install.sh
```
- Macを再起動

### 起動確認
- Escを押しながらMacを起動
- rEFIndの画面が表示されたらOK

**参考**
- [MacにブートローダrEFIndを導入してみる](http://blog-sk.com/mac/el-capitan_refind/)
- [Mac OS SierraのPCで、Ubuntu16.04をデュアルブートした時のまとめ](http://qiita.com/gano/items/424c1661420e1cfe6d9c)
- [OS X YosemiteとUbuntu 14.04.2 LTSのデュアルブート環境を構築する](http://ottan.xyz/os-x-ubuntu-dual-boot-2-1236/)

### Ubuntu 起動

![ubuntu-1](ubuntu-1.JPG   "ubuntu-1")
![ubuntu-2](ubuntu-2.JPG   "ubuntu-2")


## まとめ

- 先人の知恵のおかげでなんとか Ubuntu 起動までこぎつけた（感謝）
- Ubuntuとして起動時は，メモリ 8GB x 2 でも動いた
- Macとして起動する場合は 2GB x 2 に戻さないとカーネルパニックが発生（Ubuntu入れた時点で Mac として起動する機会はほぼないので，まぁ問題はない）
- 最近の Mac は基盤とバッテリーやメモリが癒着していてツラい．できれば自分でカスタマイズしたいところ．
- 元々入っていた250GBのHDDは外付けHDDとして再利用もしてみたい（参考：[既存のHDDを外付けとして使う](http://www.msng.info/archives/2012/02/hdd-2.php))
