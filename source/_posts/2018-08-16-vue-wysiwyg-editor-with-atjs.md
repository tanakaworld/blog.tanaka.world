---
title: Vue.js と At.js を組み合わせる
date: 2018-08-16
tags:
     - vue
     - atjs
     - jquery
---

jQuery 製の AutoComplete を提供する [At.js](https://github.com/ichord/At.js) を，Vue のコンポーネントと組み合わせて使ったときのメモ．

## 完成イメージ

完成版ソースコードは[こちら](https://github.com/tanakaworld/vue-with-atjs)．

At.js を使うと次のような挙動が実現できる．WYSIWYG 内で `@` を入力すると，入力候補が一覧が表示され，選択すると任意の要素が追加できる．

[![Image from Gyazo](https://i.gyazo.com/528e95314d7ac72932e3edf52f291c11.gif)](https://gyazo.com/528e95314d7ac72932e3edf52f291c11)


## vue-at は使わなかった

At.js の Vue 版 [vue-at](https://github.com/fritx/vue-at) もあるが，At.js の全機能に対応していなかった．(検証当時)
具体的には `insertTpl` で挿入する HTML を定義する機能が正式リリースされておらず，結局は jQuery 版をそのまま使うことにした．


## ベースとなる WYSIWYG コンポーネント

`contenteditable` で WYSIWYG を自作する．

```html
<template>
    <div>
        <div class="WYSIWYG"
             contenteditable="true"
             @focus="handleFocus"
             v-html="content"></div>
    </div>
</template>
```

```javascript
<script>
    export default {
        props: {
            value: {
                type: String,
                default: ''
            },
            disabled: {
                type: Boolean,
                default: false
            }
        },
        data() {
            return {
                content: this.value
            };
        },
        methods: {
            handleFocus(evt) {
                if (evt && this.disabled) evt.currentTarget.blur();
            }
        }
    };
</script>
```

CSS で普通の textarea っぽく見せる．

```css
<style scoped>
    .WYSIWYG {
        -moz-appearance: none;
        -webkit-appearance: none;
        border-radius: 2px;
        background-color: var(--color-white);
        border: solid 1px;
        padding: 9px 8px;
        font-size: 12px;
        color: var(--color-black);
        text-align: left;
        resize: none;
        height: auto;
    }

    .WYSIWYG:focus {
        outline: 0;
        border: solid 1px var(--color-green);
    }
</style>
```

次のように使われるコンポーネントを想定．

```html
<WYSIWYG v-model="wysiwygContent"/>
```


## At.js を組み合わせる

パッケージを追加し，`WYSIWYG.vue` 内で読み込む．

```bash
$ yarn add jquery at.js
```
```javascript
<script>
    import 'at.js';
    import 'at.js/dist/css/jquery.atwho.min.css';
    import $ from 'jquery';
```

At.js では `.atwho()` を呼び出すことでそのエレメント内で At.js の処理が有効になる．
DOM が構築された後， `ref` で WYSIWYG エレメントを取得し有効化するようにする．

`ref="WYSIWYG"` と `@input="emitChange"`(後述) を追加する．

```html
<div class="WYSIWYG" ref="WYSIWYG"
             contenteditable="true"
             @focus="handleFocus"
             @input="emitChange"
             v-html="content"></div>
```

入力内容を親コンポーネントにイベントに送出する処理を `emitChange` メソッドに切り出し，`@input="emitChange"` とイベントにセットする．
At.js で要素が追加されたときは，`input` イベントは発火しないため，要素が追加された後，何らかの文字を入力しないと親コンポーネントに変更が伝搬されない．
At.js 要素が追加されたタイミングで `emitChange` を呼ぶ処理を追加する必要がある．`.atwho` を呼び出すオプションで `callbacks.beforeInsert` を追加し，要素が追加されたであろうタイミングで `emitChange` が呼ばれるようにした．
（この辺りの実装は，もっとスマートなやり方があるかもしれない）


```javascript
data() {
    return {
        content: this.value,
        customTagOptions: [
            {
                at: "@",
                data: [
                    {label: 'Jacob', value: 'Jacob@email.com'},
                    {label: 'Isabella', value: 'Isabella@email.com'},
                    {label: 'Ethan', value: 'Ethan@email.com'},
                    {label: 'Emma', value: 'Emma@email.com'},
                    {label: 'Michael', value: 'Michael@email.com'},
                    {label: 'Olivia', value: 'Olivia@email.com'},
                    {label: 'Alexander', value: 'Alexander@email.com'},
                    {label: 'Sophia', value: 'Sophia@email.com'},
                    {label: 'William', value: 'William@email.com'},
                    {label: 'Ava', value: 'Ava@email.com'},
                    {label: 'Joshua', value: 'Joshua@email.com'},
                    {label: 'Emily', value: 'Emily@email.com'},
                    {label: 'Daniel', value: 'Daniel@email.com'},
                    {label: 'Madison', value: 'Madison@email.com'},
                    {label: 'Jayden', value: 'Jayden@email.com'},
                    {label: 'Abigail', value: 'Abigail@email.com'},
                    {label: 'Noah', value: 'Noah@email.com'},
                    {label: 'Chloe', value: 'Chloe@email.com'},
                    {label: '你好', value: '你好@email.com'},
                    {label: '你你你', value: '你你你@email.com'},
                    {label: 'Jérémy', value: 'Jérémy@email.com'}
                ],
                startWithSpace: false,
                searchKey: 'label',
                headerTpl: '<div class="atwho-header">Member List</div>',
                displayTpl: '<li>${label}</li>',
                insertTpl: '<span class="WYSIWYG__CustomTag" data-value="${value}">@${label}</span>',
                limit: 10000
            }
        ]
    };
},
mounted() {
    const $el = $(this.$refs['WYSIWYG']);

    this.customTagOptions.forEach(opt => {
        if (!opt['callbacks']) opt['callbacks'] = {};
        opt['callbacks']['beforeInsert'] = (value) => {
            setTimeout(() => {
                this.emitChange();
            }, 300);
            return value;
        };

        $el.atwho(opt);
    });
},
methods: {
    emitChange() {
        const $el = $(this.$refs['WYSIWYG']);

        this.$emit('input', $el.html());
    }
}
```

At.js 関連のスタイルを定義する．`<style scoped>` 内に記述すると正常にスタイルがあたらないので注意．`.atwho-inserted .WYSIWYG__CustomTag` は `insertTpl` オプションで追加したカスタム要素のスタイル．

```
<style>
    .atwho-view {
        z-index: 10000 !important
    }

    .atwho-view .cur {
        color: var(--color-white);
        background: var(--color-green);
    }

    .atwho-header {
        display: flex;
        justify-content: space-between;
    }

    .atwho-inserted .WYSIWYG__CustomTag {
        color: var(--color-white);
        background: var(--color-green);
        padding: 4px;
        border-radius: 4px;
    }
</style>
```

## まとめ

- 完成版ソースコードは[こちら](https://github.com/tanakaworld/vue-with-atjs)．
- At.js は WYSIWYG 自作するときに重宝する
- しかし，Vue コンポーネント内で jQuery を使うのはできればやりたくない
- [vue-at](https://github.com/fritx/vue-at) にコミットする機運
