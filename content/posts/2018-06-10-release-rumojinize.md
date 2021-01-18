---
title: rumojinize をリリースした
slug: release-rumojinize
date: 2018-06-10
tags:
- ruby
- rails
- gem
---

Rails で絵文字を扱いやすくする gem [rumojinize](https://github.com/tanakaworld/rumojinize) をリリースした．

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Published a gem &quot;rumojinize&quot; for <a href="https://twitter.com/hashtag/rails?src=hash&amp;ref_src=twsrc%5Etfw">#rails</a> <a href="https://twitter.com/hashtag/emoji?src=hash&amp;ref_src=twsrc%5Etfw">#emoji</a> 🎉 <a href="https://t.co/W7eVCvH2gz">https://t.co/W7eVCvH2gz</a><br>Featuring &quot;rumoji&quot; made by <a href="https://twitter.com/markwunsch?ref_src=twsrc%5Etfw">@markwunsch</a> .</p>&mdash; tanaka.world ™ (@_tanakaworld) <a href="https://twitter.com/_tanakaworld/status/1005516008084291584?ref_src=twsrc%5Etfw">June 9, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## 絵文字のエンコード/デコードの自動化

ActiveRecord でモデルのフィールドを指定するコードを１行記述すると，DB保存前に '🐶' → ':dog:' のように絵文字を変換してくれる．
そして，モデルのインスタンスにロードしたときに，逆の変換が自動でなされるので，変換のことを意識せずに開発が可能になる．

変換自体は [rumoji](https://github.com/mwunsch/rumoji) に任せている．

## 命名

この gem の名前は `rumoji` からとって `rumojinize` としている．

Rails の ActiveRecord 系の gem では， ["acts_as_xxxxx" という命名をするのが流行っている(?要出展)](https://rubygems.org/search?utf8=%E2%9C%93&query=acts_as)ようなのだが， `acts_as_emoji` や `acts_as_rumoji` はしっくりこず， `rumojinize` に落ち着いた．

## MySQLの文字コード

MySQLは文字セットによって，絵文字が保存できるできないが変わってくる．絵文字は４バイト文字として扱われる．一般的なデフォルトの `utf-8` だと扱えず，絵文字を保存しようとするとエラーになる．MySQL5.5 以上では，文字セットを `utf8mb4` と変更することで，４バイト文字も扱えるようになるらしいのだが，正直どこに影響がでるか完全に理解できておらず断念した．絵文字を扱いたかったサービスが既に運用中のサービスで，迅速な対応が求められていたのもある．このあたりちゃんと理解してから導入してみたい．

## 参考

- [rails + mysqlでの穏便な絵文字保存方法](http://docs.komagata.org/5262) 実装参考にさせていただきました 🙏 
