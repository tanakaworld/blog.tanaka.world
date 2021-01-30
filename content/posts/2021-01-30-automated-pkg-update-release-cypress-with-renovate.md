---
title: "Renovate と Cypress でパッケージ更新とリリースを完全自動化する"
date: 2021-01-30T10:00:00+09:00
slug: automated-pkg-update-release-cypress-with-renovate
showtoc: true
tocopen: true
tags:
- cypress
- renovate
- testing
---

https://tanaka.world/ のパッケージ更新とリリースを自動化した。パッケージ更新時に CI のジョブが全て成功したら master に自動マージし、本番リリースされるようにしている。

例: [リリース時のワークフロー](https://github.com/tanakaworld/tanaka.world/actions/runs/521300728)

![a-workflow-for-release.png](/images/2021-01-30-automated-pkg-update-release-cypress-with-renovate/a-workflow-for-release.png)

## Renovate (Package Update)

[Renovate](https://github.com/renovatebot/renovate)

[GitHub App - Renovate](https://github.com/apps/renovate) からリポジトリを選択して設定する。


## Cypress (E2E)

[Cypress](https://www.cypress.io/)

手動でやっていた動作確認を Cypress で自動化した。各ページごとにざっくりテストしている。([テストコード](https://github.com/tanakaworld/tanaka.world/tree/e9315cff502901728e2b5dbd388adf2919f4e40d/cypress/integration))

Cypress のテストコードも TypeScript で記述する。Cypress の型定義ファイルを読み込むと、アプリケーション側の Jest の型定義と競合するため `tsconfig.cypress.json` を別途追加している。

## GitHub Actions (CI/CD)

Merge 前に実行する用と、リリース用の[２つのワークフロー](https://github.com/tanakaworld/tanaka.world/tree/e9315cff502901728e2b5dbd388adf2919f4e40d/.github/workflows)がある。

`before-merge.yml` は、Lint, Unit Test, Build, E2E Test を実行し、`release.yml` はそれに加えて Deploy を実行する。両者の違いは実行の起点となる branch と Deploy の有無だけなので、YAML インポート的なことがやりたいが、公式にはそのような仕組みは存在しないようだ。冗長だが一旦同じ内容を記述している。

大枠の処理は次の通り。

1. `lint-test-build` ジョブで生成されたアプリケーションビルド対して、E2E テストを実行
1. 対象ブラウザは最低限 `chrome`, `firefox`, `edge`、それぞれ並列で実行される
1. テストに失敗したら、スクリーンショットと動画をアップロード
1. (`release.yml` の場合) テスト済みのビルドをデプロイ

```yaml
  test-e2e:
    needs: lint-test-build

    strategy:
      matrix:
        node-version: [ 14.15.3 ]
        browser: [ chrome, firefox, edge ]

    steps:
      - uses: actions/checkout@v2
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v2
        with:
          node-version: ${{ matrix.node-version }}
      - name: Download Artifact
        uses: actions/download-artifact@master
        with:
          name: dist
          path: dist
      - name: E2E by Cypress
        uses: cypress-io/github-action@v2
        with:
          browser: ${{ matrix.browser }}
          command: npm run e2e:ci
      - uses: actions/upload-artifact@v2
        if: failure()
        with:
          name: cypress-${{ matrix.browser }}
          path: |
            cypress/videos
            cypress/screenshots
```

![a-workflow-for-release.png](/images/2021-01-30-automated-pkg-update-release-cypress-with-renovate/a-workflow-for-release.png)

## Auto Merge Setting

GitHub リポジトリの設定で `Allow auto-merge` を有効にする。 P-R の merge requirements が全て完了したら自動でマージしてくれるようになる。

![github-repo-allow-auto-merge.png](/images/2021-01-30-automated-pkg-update-release-cypress-with-renovate/github-repo-allow-auto-merge.png)

商用のアプリケーションであれば人間がリリース判定した方がいいかもしれない。[tanaka.world](https://tanaka.world/)はそうではなく、E2E で動作は担保されているのでカジュアルにリリースすることにした。


