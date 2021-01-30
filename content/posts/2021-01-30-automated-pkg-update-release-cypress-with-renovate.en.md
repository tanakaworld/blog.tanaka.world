---
title: "Automate package update and release with Cypress + Renovate"
date: 2021-01-30T10:00:00+09:00
slug: automated-pkg-update-release-cypress-with-renovate
showtoc: true
tocopen: true
tags:
- cypress
- renovate
- testing
---

I've automated the package update and release of https://tanaka.world/. When a npm package is updated, it will be merged and production deployed automatically after all CI jobs finish.

Example: [The workflow for release](https://github.com/tanakaworld/tanaka.world/actions/runs/521300728)

![a-workflow-for-release.png](/images/2021-01-30-automated-pkg-update-release-cypress-with-renovate/a-workflow-for-release.png)

## Renovate (Package Update)

[Renovate](https://github.com/renovatebot/renovate)

Set up Renovate via [GitHub App - Renovate](https://github.com/apps/renovate). You can select a repo.

## Cypress (E2E)

[Cypress](https://www.cypress.io/)

Previously, I tested manually when I updated. I've replaced the way to test with Cypress.
It tests all pages roughly. ([Test Code](https://github.com/tanakaworld/tanaka.world/tree/e9315cff502901728e2b5dbd388adf2919f4e40d/cypress/integration))

It is available to use TypeScript in Cypress. I added `tsconfig.cypress.json` file apart from a `tsconfig.json` for your application since they were conflicted.

## GitHub Actions (CI/CD)

There are [two workflows](https://github.com/tanakaworld/tanaka.world/tree/e9315cff502901728e2b5dbd388adf2919f4e40d/.github/workflows). One is a workflow that I want to run before merging, and the other is for release.

`before-merge.yml` executes Lint, Unit Test, Build and E2E Test. `release.yml` executes them, and also Deploy. The difference between them are the branch kicks the actions and including Deploy or not. I wanted to do something like YAML-import, but GitHub Actions don't provide. So it is redundant, I've written the same setting.

Workflow overview:

1. Execute E2E test to an application which generated in a `lint-test-build` job.
1. Target browsers `chrome`, `firefox` and `edge` at least. They are executed in parallel.
1. Upload screenshots and videos when a test fails.
1. (Only `release.yml`) Deploy an application bundle which has been already tested.

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

Enable `Allow auto-merge` in the repository's setting screen. It would merge P-Rs when all merge requirements pass.

![github-repo-allow-auto-merge.png](/images/2021-01-30-automated-pkg-update-release-cypress-with-renovate/github-repo-allow-auto-merge.png)

If it is a commercial application, you might be better to have a manual judgement to deploy. Since [tanaka.world](https://tanaka.world/) is not a such application and fully tested by E2E testing, I've decided to release casually.
