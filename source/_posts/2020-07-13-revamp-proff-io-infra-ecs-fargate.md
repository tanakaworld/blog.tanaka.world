---
title: Proff の本番環境を刷新した（ECS/Fargate）
date: 2020-07-13 12:00:00
tags:
    - proff.io
    - AWS
    - ECS
    - Fargate
    - Docker
---

[Proff（プロフ）](https://proff.io/)の本番環境を刷新した。2018 年から約 2 年ほど運用してきて初の大規模インフラ改修となった。

## TL;DR;

- EC2 → ECS(Fargate) に変更
- 静的アセットを S3 から配信するように変更
- CircleCI Orbs を使用し Docker ビルド
- Terraform で構成管理

## サービス構成

#### 概要

既存の本番環境とは別に VPC を作成し、関連する AWS サービスもほぼ全部新規に作成した(S3 以外)。というのも、まず新構成の開発環境を構築して色々と検証をした上で、まったく同じ構成で本番環境を構築したかったから。Terraform の workspace 切り替えで検証済みの構成と同等の設定で本番環境も作成した。CPU や Memory などスペックは本番向けに増強している。

主な変更点は下記の通り。

Before | After
--- | ---
ELB | ALB (Application Load Balancer) に変更 
EC2 (Nginx, RoR, Node.js) | ECS + Fargate (RoR, Node.js) に変更 <br>静的コンテンツを S3 から配信 ([asset_sync](https://github.com/AssetSync/asset_sync))
-  | ECR (Docker Registry)
-  | System Manager (ECS で使う秘匿情報を Parameter Store で保存)
Capistrano | CircleCI で docker build し ECR に push <br>(Orb を使用: [circleci/aws-ecr](https://circleci.com/orbs/registry/orb/circleci/aws-ecr), [circleci/aws-ecs](https://circleci.com/orbs/registry/orb/circleci/aws-ecs)) 

#### サービス選定

一番の目的は本番環境をコンテナ化することだった。IoC (Infrastructure as Code) したい、環境差分をなくしたい (ローカル, 本番, CI)、スケールを容易にしたい、というのが主な狙い。コンテナ化しない理由は逆になく ECS を選択した。

Fargate にした理由は、単純な興味と、なるべく運用のことを気にかけずにアプリケーション開発に集中したかったから。EKS (Elastic Kubernetes Service) は、ほぼ 1 人開発な現状に対してオーバースペックなので選択しなかった。料金は割高になる可能性があるので注視していく。

Heroku や GCP も検討したが、AWS 中心にスタックを固めておきたく断念した。別サービスで Heroku 運用をしてみたところ手軽さがかなりよかったが、Plugin に課金してそれなりのスペックを用意すると、月額コストは AWS とあまり変わらなそうだった。Heroku を使うなら Heroku で固めたい。同様に、会社業務で使っている GCP にも興味はありつつも、既に AWS で運用中のものを別クラウドに移行する旨味はなかった。 

## Dockerize

#### 共通イメージ

コンテナは一つで Ruby, Node.js を動かしている。ベースとなるイメージを https://hub.docker.com/r/tanakaworld/ruby-2.6.2-node-12.16.3 に共通化し、ECS 上で動かすコンテナの Dockerfile *(1)* と CircleCI 上 *(2)* で参照している。CircleCI が用意してくれている [Ruby の Docker イメージ](https://circleci.com/docs/2.0/circleci-images/#ruby)だと Node.js のバージョンが制御できなかったので自前で共通イメージを用意した。

```dockerfile
# Base
FROM node:12.16.3 as node
FROM ruby:2.6.2

# 共通のカスタマイズ
# - Puppeteer 向けのパケージインストール
# - `node`, `yarn` を node イメージからコピー
# - Bundler を v2.x 系に更新
```

```dockerfile
# (1) docker/rails/Dockerfile
FROM tanakaworld/ruby-2.6.2-node-12.16.3 
```

```yaml
# (2).circleci/config.yml
executors:
  default:
    docker:
      - image: tanakaworld/ruby-2.6.2-node-12.16.3
```

#### Puppeteer

Proff には履歴書の PDF 生成書き出し機能があり、裏側では [Puppeteer](https://github.com/puppeteer/puppeteer) が使われている。Puppeteer をイメージ内に同梱しているのでサイズが大きくなってしまっている。PDF 生成機能の利用シーンは他機能より少ないので別コンテナに切り出したい（Rails をスケールするときに無駄に Puppeteer もスケールしてしまう現状）。


#### 静的コンテンツの扱い

`assets:precompile` を Docker ビルド時に実行し、[AssetSync/asset_sync](https://github.com/AssetSync/asset_sync) で S3 に転送している、`ENTRYPOINT` でアプリケーション起動前のタスク (DB マイグレーション、sitemap の動的更新など) を実行している。[progrium/entrykit](https://github.com/progrium/entrykit) を使用している。`assets:precompile` + `assets:sync` を `ENTRYPOINT` で実行している例をよく見かけるが、コンテナが N 台動くときに N 回実行され無駄なのと起動が遅くなるので、イメージ:アセット=1:1 になるようにした。


## Build + Deploy

#### Capistrano から CircleCI Orbs に移行 

[Capistrano](https://github.com/capistrano/capistrano) を廃止した。変わりに CircleCI 上で Docker ビルドし ECR に push する処理を実行している。CircleCI Orbs を使用した。`ecs-cli` のインストールや Docker コマンドの扱いなどを隠蔽してくれていて楽だった。

- [circleci/aws-ecr](https://circleci.com/orbs/registry/orb/circleci/aws-ecr)
- [circleci/aws-ecs](https://circleci.com/orbs/registry/orb/circleci/aws-ecs)

ECR に push する他、Docker ビルド時に `assets:sync` するために AWS ID / Secret が必要になる。CircleCI の [Contexts](https://circleci.com/docs/2.0/contexts/) で環境ごとの変数を管理するようにした。[CodeBuild](https://aws.amazon.com/codebuild/) や [CodeDeploy](https://aws.amazon.com/codedeploy/) を使うと、AWS 上で全てが完結するので秘匿情報の扱いがより安全にできそうではある。AWS 料金が嵩むのを懸念して今回は断念した。

#### 課題

いくつか問題があって対策していきたい。

- イメージサイズを小さくする
- ビルド時間が長い問題を解決していきたい
- 対策としては Docker レイヤーキャッシュ周りを見直す
- Puppeteer を別コンテナとして動かすようにする
- `assets:precompile` 遅いのをどうにかする。webpacker 使っているけど、Frontend のビルドは Rails の仕組みから外してもよいかも。

## Terraform で構成管理

AWS サービスの作成手順をまとめたオレオレドキュメントが秘伝のタレ化していた (悪い意味)。会社業務では雛形としてつくられた .tf ファイルを使って運用することはあるが、個人開発で IaC をまともにやったことがなく、フルスクラッチでつくったのはとても勉強になった。

既存リソースを import するのではなくほぼすべて新規作成した。新構成の検証をするための開発環境が新規作成だったため、本番もそれと同じにしたかったため。

インフラ設定が宣言的に記述できてよいというのは言わずもがなだが、秘伝のタレをもとにした手作業がなくなったこと、設定をミスしたときの依存関係の削除がコマンドで完結すること、命名規則を変数で共通定義できた。

また、秘匿情報の扱いが安全にできたのがよかった。例えば、IAM に作成したユーザーの ID / Secret を System Manager の Parameter Store に追加して、アプリケーション側にはそのキー名だけ設定するといったことができる。


```hcl-terraform
// User 作成
resource "aws_iam_user" "app" {
  name = "app-${var.name}-${terraform.workspace}"
}
resource "aws_iam_access_key" "app-user-key" {
  user = aws_iam_user.app.name
}

// Parameter Store に登録
resource "aws_ssm_parameter" "app_iam_secret" {
  name  = "/${var.name}_${terraform.workspace}/app/iam/secret"
  type  = "SecureString"
  value = aws_iam_access_key.app-user-key.secret
}

// ECS で秘匿情報を参照
resource "aws_ecs_task_definition" "app" {
  container_definitions    = <<DEFINITION
[
  {
    "environment": [
      { "name": "APP_ENV", "value": "${terraform.workspace}" }
    ],
    "secrets": [
      { "name": "AWS_SECRET_ACCESS_KEY", "valueFrom": "${aws_ssm_parameter.app_iam_secret.name}" }
    ]
  }
]
DEFINITION
}
```


最終的なファイル構成はこんな感じ。

```bash
$ tree .
.
├── README.md
├── main.tf
├── modules
│   ├── alb.tf
│   ├── bastion.tf
│   ├── cloudwatch.tf
│   ├── ecr_repository.tf
│   ├── ecs.tf
│   ├── iam_policy.tf
│   ├── iam_role.tf
│   ├── iam_user.tf
│   ├── igw.tf
│   ├── nat.tf
│   ├── output.tf
│   ├── parameter_store.tf
│   ├── rds.tf
│   ├── route_table.tf
│   ├── security_group.tf
│   ├── subnet.tf
│   ├── variables.tf
│   └── vpc.tf
└── versions.tf
```

## まとめ

- Dockernize によって開発・運用しやすい構成にできた。
- 途中から Terraform を使う方針に切り替えたのだが、調査にかけたコストを大きく上回るリターンがあった。No Terraform No Life.
- ECS や Fargate の挙動周り、Terraform のベストプラクティスは、詳しい人に聞ける機会があるとよかったかもしれない。コンテナが正常に動作するまでに色々と四苦八苦した。そもそも概念に対する知識不足から、IAM の権限が足りない、セキュリティグループの設定、ALB のヘルスチェックが Basic Auth にブロックされいたなど単純な問題にハマっていた。自分はインフラ周りが得意ではないので、スポットでインフラレビューしてくれるエンジニアいたらありがたい。
- 今回のリニューアルはアプリケーション開発に集中するのが最終目的なので、開発に邁進していきたい

## 参考にしたリンク集

- Getting started with Amazon ECS using Fargate
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/getting-started-fargate.html
- What is AWS Fargate?
    https://docs.aws.amazon.com/AmazonECS/latest/userguide/what-is-fargate.html
- Terraform Documentation
    https://www.terraform.io/docs/index.html
- AWS FargateとTerraformで最強＆簡単なインフラ環境を目指す
    https://qiita.com/tarumzu/items/2d7ed918f230fea957e8
- AWS FargateでNginxを動かしてみる
    https://qiita.com/riywo/items/b223bdad2b3ae3bebf55
- AWS FargateでRuby on Railsを動かしてみる
    https://qiita.com/riywo/items/3874fe1a9f11658b8396
- Deploy Rails in Amazon ECS: Part 3 - Create the RDS database, Task Definition, and Load Balancer
    https://dev.to/jamby1100/deploy-rails-in-amazon-ecs-part-3-create-the-rds-database-task-definition-and-load-balancer-1ffe
- 既存のAWS環境を後からTerraformでコード化する
    https://dev.classmethod.jp/articles/aws-with-terraform
- production環境でRailsアプリをdockerコンテナとしてECSで運用するために考えたこと
    https://qiita.com/joker1007/items/b8a932c1ae29705cef8d
- RailsアプリをECSで本番運用するためのStep by Step
    https://joker1007.github.io/slides/rails_on_ecs/slides/#/
