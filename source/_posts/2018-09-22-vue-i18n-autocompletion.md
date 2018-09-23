---
title: vue-i18n の簡易入力補完を実装してみた雑感
date: 2018-09-22 17:36:16
tags:
	- vue.js
	- i18n
---

[vue-i18n](https://github.com/kazupon/vue-i18n) の入力補完を実装してみた．久々に業務で i18n 対応をするようになって，若干ツラさを感じているところもあるので，併せて記す．

はじめに断っておくが，ツラさを感じているのは vue-i18n に対してではなく，i18n 全般に対してのこと．


## 文字列指定を入力補完したい

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">エディタでvue-i18nの入力補完したい</p>&mdash; tanakaworld 🧢 (@_tanakaworld) <a href="https://twitter.com/_tanakaworld/status/1035123237095583744?ref_src=twsrc%5Etfw">August 30, 2018</a></blockquote>

vue-i18n に限らず i18n 系を扱うときは `$tc('home.title')` のような感じで**文字列**をキーとして指定することになる．

- **文字列キーのタイポしなくしたい**
- **文字列キーのパス入力をカンタンにしたい**

これらを入力補完でなんとかしたい．


## 普通に vue-i18n を使った場合


普通に実装するとこういう感じになる．

```ts
import Vue from "vue";
import VueI18n from "vue-i18n";
Vue.use(VueI18n);
const messages = {
 en: {
   message: {
     hello: "Hello World!"
   },
   home: {
     title: "Home"
   },
   about: {
     title: "About"
   }
 },
 ja: {
   message: {
     hello: "こんにちは，世界!"
   },
   home: {
     title: "ホーム"
   },
   about: {
     title: "アバウト"
   }
 }
};
const locale = "ja";
 const i18n = new VueI18n({
  locale,
  messages
});
export { i18n };
```

```html
<template>
    <div class="home">
        <h1>{{ $tc('home.title') }}</h1>
    </div>
</template>
```

翻訳のキーには文字列 `home.title` が使われる．このキーを typo したり，locale ファイルの構造が変わり，正常に翻訳できないことを気づくのは，大抵実行時になる．また`messages` の数が多くなったり，複数ファイルにまたがったりすると記述するときに迷うのもツラい．

![translation-missing.png](translation-missing.png 'translation-missing.png')




## message オブジェクトから，入力補完用のオブジェクト i18nHints を生成

`'home.title'` という記述を `i18nHints.home.title` のようなオブジェクトで代替する．オブジェクトを自動生成する `generatePathMap` がやっていることは単純で `messages` オブジェクトのキーを文字列として別のオブジェクトにマッピングしているだけ．


```ts
const locale = "ja";

export function generatePathMap(obj: Object, basePath: string = "") {
  return Object.keys(obj).reduce((result, key) => {
    const path = basePath === "" ? key : `${basePath}.${key}`;
    if (typeof obj[key] === "object") {
      result[key] = generatePathMap(obj[key], path);
    } else {
      result[key] = path;
    }
    return result;
  }, {});
}

const i18nHints: any = generatePathMap(messages[locale]);

const i18n = new VueI18n({
  locale,
  messages
});p
Vue.mixin({
  computed: {
    $i18nHints: () => i18nHints
  }
});

export { i18n, i18nHints };
```

TypeScript 使っている場合は，別途型定義が必要．


```ts
import "vue";

declare module "vue/types/vue" {
  interface Vue {
    i18nHints: any;
  }
}

```

`<template></template>` 内では `$i18nHints` が，`<script></script>` 内では `i18nHints` を使って，指定する文字列が参照できるようになる．

```html
<template>
    <div class="home">
        <img alt="Vue logo" src="../assets/logo.png">
        <h1>{{$tc($i18nHints.home.title)}}</h1>

        <p>{{message}}</p>
    </div>
</template>

<script lang="ts">
import Vue from "vue";
import { i18n, i18nHints } from "@/i18n";
export default Vue.extend({
  name: "home",
  data() {
    return {
      message: i18n.tc(i18nHints.message.hello)
    };
  }
});
</script>
```

こんな感じで入力補完されるようになる．

![autocomplete.png](autocomplete.png 'autocomplete.png')

## その他 i18n でツラいところ

- **ソースコード読みづらい**
- **locale ファイル構造どうするか**


#### ソースコード読みづらい

日本人ならソースコード(特に View 周り)に日本語が入っていると，パッと目で見たときにどういう UI か認識しやすいだろう．しかしその日本語が全て英数字の代替テキストに変わっていると，想像以上に見づらい．というのを最近感じている．

Rails 開発でよく使っている [RubyMine](https://www.jetbrains.com/ruby/) だと，i18n 文字列をデフォルトロケールの文字列で表示することができる(Code > Folding > Expand/Collapse)．普段フロントエンド開発は [WebStorm](https://www.jetbrains.com/webstorm/) 使っているがそっちでも同じ機能が欲しい．RubyMine に慣れているだけなのかもしれないが，これ結構ツライ．．．

![i18n-folding-expand.png](i18n-folding-expand.png 'i18n-folding-expand.png')


#### locale ファイル構造どうするか

i18n 対象が多くなってくると，どういう階層構造で管理するかが課題になってくる．共通なものは `common`，エンティティ系は `models`，UI パーツは `modules` とか，使っているデザインパターンにもよるだろう．どこにでも所属しうるテキストが出てきたときに配置に迷うことがよくある．実装するときに迷うのだから，誰かが定義した i18n 文字列を探すときも同様に迷う．この辺りはベスト・プラクティスなるものが発見できておらず，多少冗長になってもページごとに完全に分離してしまうとか，迷わない構造が求められる．


## なぜ i18n 対応するのか

- **多言語化・翻訳対応**
- **文字列の共通化**

つくっているアプリケーションが単独言語しかサポートしないのであれば，後者が主たる目的になるだろう．その目的だけで i18n 対応するのは，前述したツラさを踏まえると，**対応しない**という選択肢もあってよいと思う．要件や仕様が固まっていない場合は，一旦対応せずに開発を進めて，落ち着いたらまとめて i18n 対応するのもいいかも．locale ファイルのリファクタリングするのは結構重い．


## まとめ

サンプルコードは[こちら](https://github.com/tanakaworld/vue-i18n-autocompletion)

この入力補完は，JavaScript のオブジェクトを使うことによってエディタがよしなに補完してくれるようになっただけ．無理やり感あるので，よりよいやり方を模索したいと思う．Vue.js の template 内で TS の型チェックが効くようになったら，型でも縛りたい．

それと以前 [@kazu_pon](https://twitter.com/kazu_pon) さんにアドバイスもらった [vetur](https://github.com/vuejs/vetur) 使うやつ今度試してみる．

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">参考になります！vscode だったら、veturのlanguage server protocol に便乗したやつ作れば、行けそうな気が。</p>&mdash; 🐤kazupon@Vue.js入門発売中ゥゥッ！🐤 (@kazu_pon) <a href="https://twitter.com/kazu_pon/status/1035124213563056128?ref_src=twsrc%5Etfw">August 30, 2018</a></blockquote>


## 追記 2018/08/01

ここで紹介されてる [vue-i18n-service](https://github.com/f/vue-i18n-service) を用いた locale の管理方法がとてもよさそう．SFC 毎に locale ファイルを管理するアプローチ．

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">localeファイル構造の管理のツラさは、どのi18nライブラリもある共通のツラさかなと思っている。Vue CLI のツールかこんな感じの単独のツールを提供したいと思っている。<a href="https://t.co/txpUw0W0Cg">https://t.co/txpUw0W0Cg</a> <a href="https://t.co/VFRYXFReYU">https://t.co/VFRYXFReYU</a></p>&mdash; 🐤kazupon@Vue.js入門発売中ゥゥッ！🐤 (@kazu_pon) <a href="https://twitter.com/kazu_pon/status/1043649313845329920?ref_src=twsrc%5Etfw">September 22, 2018</a></blockquote>

<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


