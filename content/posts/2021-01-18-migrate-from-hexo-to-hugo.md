---
title: "Hexo から Hugo に移行した"
date: 2021-01-18T21:35:10+09:00
slug: migrate-from-hexo-to-hugo
tags:
- blog
---

ブログツールを [Hugo](https://gohugo.io/) に引っ越しをした。(前回: [Middleman から Hexo に引っ越した](/move-to-hexo-from-middleman/)) 

## モチベーション

1. Hexo のジェネレート処理が重くなってきた
1. ダークモード対応
1. 多言語対応 (英語でも書くために)
1. 飽きた 

2.,3. は hexo でできたかもしれないが、4.もあり別のツールを調べていた。Hugo でいい感じのテンプレートがあったのでそれにした。正直あまり考えずに即決した。

## 移行時に変更が必要だった箇所

本文の Markdown ファイルはほぼそのまま使用できたが、一部変更を加えた。

### ディレクトリ構成

- Markdown ファイルの移動 (`source` -> `content/posts`)
- 画像パスの変更

### Front Matter

- `tags` 要素のインデントを削除
- `slug` を追加
    - Hexo では Markdown ファイル名の先頭に yyyy-MM-dd-<path名>.md というファイル名にすると path 名が実際の path になっていた
    - Hugo ではデフォルトで「ファイル名」または Front Matter の `slug` が path 名になる
    - ファイル名から slug を自動挿入するようにした(雑な [gist](https://gist.github.com/tanakaworld/519a3794d056cbc45d281ff1aa25c121))

