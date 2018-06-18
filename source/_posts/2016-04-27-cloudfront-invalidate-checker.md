---
layout: post
title: AWS CloudFront の Invalidation 完了を通知するブックマークレットをつくった
date: 2016/04/27
tags:
    - AWS
    - CloudFront
---

CloudFrontのInvalidation(Purge)には最大15分かかる．

開始してから完了を待つまでの間，終わったかどうかページをリロードしたり，パージを忘れてて気づいたら終わってたり．

なんとなく**気持ちが落ち着かない**ので，進捗をウォッチして**完了を通知してくれるブックマークレット**をつくった．

🚀
**<a href="https://github.com/tanakaworld/cloudfront-invalidate-checker" target="_blank">cloudfront-invalidate-checker</a>**

CloudFrontのAPI使えばもっと賢くできるかもしれないが，とりあえずJSでさくっとつくった．

**ブックマークレット登録**

Chromeの場合，<a href="https://github.com/tanakaworld/cloudfront-invalidate-checker/blob/master/cloudfront-invalidate-checker.min.js" target="_blank">cloudfront-invalidate-checker.min.js</a>の内容の前に `javascript: `を付けてブックマーク登録すればおｋ．

<img alt="new-invalidation" src="/blog/cloudfront-invalidate-checker/0-bookmarklet.png" width="500px">

**新規Invalidationを開始**

<img alt="new-invalidation" src="/blog/cloudfront-invalidate-checker/1-new-invalidation.png" width="500px">

**ブックマークレットを実行してInvalidationIDを指定**

<img alt="input-invalidation-id" src="/blog/cloudfront-invalidate-checker/2-input-invalidation-id.png" width="500px">

**Invalidation完了・通知**

Invalidationが完了すると，Chromeから通知が来る．
Chromeから離れて作業しててもポップアップで知らせてくれる．

（※ AWSコンソール上で動くJSで実行しているのでタブを消すと通知されない）

<img alt="complete" src="/blog/cloudfront-invalidate-checker/3-complete.png" width="500px">

社内では完了後，社内の音声流せるサーバにHTTPリクエスト送って，FFのファンファーレが流れるようにしている♪♪♪

(某T社に感化されてファンアーレにした)

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">CloudFrontのInvalidation完了したらFFファンファーレ流れるようにしたら、結構いい感じだった♫♫♫</p>&mdash; TanakaWorld™ (@_tanakaworld) <a href="https://twitter.com/_tanakaworld/status/723422341334593536">April 22, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


