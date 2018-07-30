---
title: JetBrains Toolbox による IDE 管理
date: 2018-07-30 14:57:00
tags:
	- jetbrains
	- intellij
---

Adobe Creative Cloud みたいに，IntelliJ 製品を管理できる JetBrains Toolbox を使ってみた．
今まで気づかなかったが，[JetBrains Toolboxがリリースされました！](https://blog.jetbrains.com/jp/2016/10/20/670)によると 2016 年にバージョン 1.0 がリリースされていたようだ．

Update や Install/Uninstall が管理できる．
ほぼ Adobe CC と同じ．Mac の Navigation Bar にもアイコンが表示され，そこから表示ができる．

![jetbrains-toolbox](jetbrains-toolbox.png 'jetbrains-toolbox')
![jetbrains-toolbox-1](jetbrains-toolbox-1.png 'jetbrains-toolbox-1')

Update すると，旧バージョンを Uninstall できる．

![jetbrains-toolbox-2](jetbrains-toolbox-2.png 'jetbrains-toolbox-2')

Update 後，起動すると旧設定を引き継ぐことができる．
これは今までの仕様と同じ．旧バージョンを Uninstall していても，設定ファイルは残っている．

![jetbrains-toolbox-3](jetbrains-toolbox-3.png 'jetbrains-toolbox-3')

しかし，CustomVMOption は引き継がれないようだ．
自分はメモリ割り当てなどを変更しているので，バージョンアップ後に `Help > Edit Custom VM Options` から設定を変更した．

