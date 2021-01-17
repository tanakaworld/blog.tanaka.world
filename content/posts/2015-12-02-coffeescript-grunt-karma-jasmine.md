---
title: 【Grunt + Karma + Jasmine】CoffeeScriptの開発環境を構築する
slug: coffeescript-grunt-karma-jasmine
date: 2015/12/02
tags:
- coffeescript
- javascript
- grunt
- npm
- karma
- jasmine
---

Grunt + CoffeeScript + Karma + Jasmine での開発をスタートして数ヶ月たった．
ある程度ノウハウも溜まってきたので，メモしておく．

### CoffeeScript関連ライブラリをセットアップ

```
$ npm init
$ npm install
$ npm install coffee-script --save-dev    
$ npm install grunt --save-dev
$ npm install grunt-contrib-coffee --save-dev
$ npm install grunt-contrib-concat --save-dev
$ npm install grunt-contrib-uglify --save-dev
$ npm install grunt-contrib-watch --save-dev
```

### プロダクトコード

``` coffeescript
# src/hello.coffee

hello = ->
  console.log("Hello world!!")
```

``` coffeescript
# src/main.coffee

hello()

user = new User("Tanaka", 24)
console.log(user.profile())
```

``` coffeescript
# src/user.coffee

class User
  # static private param
  _uid = 987654321

  # constructor
  constructor: (@NAME, @age) ->

  # public method
  profile: ->
    return @NAME + " : " + @age

  # private method
  _toAge = ->
    @age++
```

### Gruntfile.coffee 

Gruntの設定ファイルを作成する．

``` coffeescript
# Gruntfile.coffee
 
module.exports = (grunt)->
  grunt.initConfig
    watch:
      coffee:
        files: ['src/**/*.coffee']
        tasks: 'coffee:app'
    coffee:
      app:
        files: [
          expand: true
          cwd: 'src/'
          src: ['**/*.coffee']
          dest: 'src/js'
          ext: '.js'
        ]
      dist:
        files: [
          expand: true
          cwd: 'src/'
          src: ['**/_all.coffee']
          dest: 'dist/'
          ext: '.js'
        ]
    concat:
      dist:
        src: ['src/hello.coffee', 'src/user.coffee', 'src/main.coffee']
        dest: 'src/_all.coffee'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'publish', ['concat', 'coffee:dist']
```

```
$ grunt default
```

src/以下のコードの変更を監視して，変更時にタスクを実行する．

```
$ grunt publish
```

公開用JavaScriptファイルを生成する．


### Unit Testing 関連ライブラリを追加

```
$ npm install karma --save-dev
$ npm install grunt-karma --save-dev
$ npm install karma-chrome-launcher --save-dev
$ npm install karma-coffee-preprocessor —save-dev
$ npm install karma-jasmine —save-dev
```

### テストコード

``` coffeescript
# spec/userSpec.coffee

describe "User", ->

  describe "#profile", ->
    it "profile is valid", ->
      user = new User("Tanaka", 25)
      expect(user.profile()).toEqual("Tanaka : 25")
```

### Karmaの設定

```
$ node_modules/karma/bin/karma init
```

このコマンドでkarma.conf.coffeeを作成する．

``` coffeescript
# karma.conf.coffee

module.exports = (config) ->
  config.set

    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: ''


    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine']


    # list of files / patterns to load in the browser
    files: [
      # src
      'src/**/*.coffee'

      # test
      'spec/**/*Spec.coffee'
    ]


    # list of files to exclude
    exclude: [
    ]


    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      '**/*.coffee': ['coffee']
    }


    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress']


    # web server port
    port: 9876


    # enable / disable colors in the output (reporters and logs)
    colors: true


    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO


    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true


    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Chrome']


    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false
```

### Gruntにテスト関連の設定を追加


``` coffeescript
# Gruntfile.coffee

grunt.initConfig
    •••
    # Add
    karma:
        unit:
            configFile: 'karma.conf.coffee'
        
•••
# Add
grunt.loadNpmTasks 'grunt-karma'

•••
# Add
grunt.registerTask 'spec', ['concat', 'karma']
```

```
$ grunt spec
```

.coffeeファイルをconcatしてChromeでテストが実行される．

### テスト時にPhantomJSを使用する

上記設定だとテスト実行時にChromeが起動する．
毎回起動されるとうっとおしいのと，CIやるときにはPhantomJSを使いたい．

npmでphantomjsのライブラリとランチャーをインストールする．

``` 
$ npm install phantomjs --save-dev
$ npm install karma-phantomjs-launcher --save-dev
```

karma.conf.coffeeに設定する．

``` coffeescript
# karma.conf.coffee

# browsers: ['Chrome']
browsers: ['PhantomJS']
```

#### [View Source on Github](https://github.com/tanakaworld/sandbox-javascript/tree/master/CoffeeTemplate)
