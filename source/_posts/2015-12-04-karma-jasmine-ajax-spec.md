---
title: 【Karma + Jasmine】非同期を含む場合のテストコードをかく
date: 2015/12/04
tags:
    - karma
    - jasmine
---

下記のようなケースを考える．

基本的なテスト環境設定は[こちら](http://yutarotanaka.com/blog/coffeescript-grunt-karma-jasmine/)

``` coffeescript
# sample.coffee

class Sample
    getData: ->
        url = "http://example.com/1/json"
        
        xhr = new XMLHttpRequest()
        xhr.open("GET", url, false)
        xhr.send()
        
        data = null
        
        if xhr.status is 200
            data = JSON.parse(xhr.responseText)
            
        return data
```

`.getData` のテストを書く際に，xhrの通信部分をスタブしたい．

[jasmine-ajax](https://github.com/jasmine/jasmine-ajax)，[jasmine-jquery](https://github.com/velesin/jasmine-jquery) を使用する．

```
npm install jasmine-ajax --save-dev
npm install jasmine-jquery --save-dev
```

``` coffeescript
# sampleSpec.coffee

describe Sample, ->
    beforeAll ->
        jasmine.Ajax.install()
    afterAll ->
        jasmine.Ajax.uninstall()
    
    describe '.getData', ->
        beforeEach ->
            mockedData = {sample: 1}
    
            requestUrl = "http://example.com/1/json"
            jasmine.Ajax.stubRequest(requestUrl).andReturn
                status: 200
                responseText: JSON.stringify(mockedData)
                
            @sample = new Sample()
            
        it 'should got data', ->
            expect(@sample.getData().toBe({sample: 1})
```

beforeAllで `jasmine.Ajax.install()` する．
`.getData()` 呼び出し時のxhrリクエストをスタブし，返り値のテストをしている．
