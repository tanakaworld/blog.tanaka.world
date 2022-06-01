---
title: "Fullstack Web App with Turborepo"
slug: fullstack-web-app-with-turborepo
date: 2022-05-29T12:00:00+09:00
showtoc: true
tocopen: true
tags:
- monorepo
- turborepo
---

This is a note when I investigated [Turborepo](https://turborepo.org/), a monorepo tool that Vercel develops. I had created a flashcard web application for my own language study, using a static JSON file to store the cards' data. I re-implemented it using TypeScript, Next.js, and GraphQL ([Code](https://github.com/tanakaworld/flashcard)).

## What is "monorepo"?

**_Monorepo_** is a pattern of storing all code for an application or microservices in a single repository. When adopting a microservice architecture, repositories are usually divided into separate repositories. Which is generally called **_Polyrepo_**.

**_Monorepo_** is often misunderstood as **_Monolithic_**. _Monolithic_ is a different concept. The counterpart of _Monorepo_ is **_Polyrepo_**. _Monolithic_ refers to a state which is tightly coupled, the counterpart of it is **_Modular_**. So, in other words, a project can be _Monorepo_ and _Monolithic_, or _Monorepo_ and _Modular_

_Polyrepo_ makes it easier to develop, but there are some disadvantages. For example, it may be difficult to share code across repositories. _Monorepo_ aims to eliminate these disadvantages.

## Introduction to Turborepo

Turborepo is a monorepo tool developed by Vercel, a company that also develops Next.js as you know. The beauty of Turborepo is its **simplicity**. It’s like the features that enhance builds, that assist [npm workspaces](https://docs.npmjs.com/cli/v7/using-npm/workspaces). There are fewer cumbersome configurations and dependencies.

**_Workspaces_** is a term that provides managing multiple packages within a single package. npm workspaces is similar to yarn workspaces. It’s been available since npm v7. Turborepo supports not only npm but also yarn and pnpm.

Turborepo provides these features. Through this investigation, I focused on **Caching** and **Remote caching**.

![turborepo-features.png](/images/2022-05-29-fullstack-web-app-with-turborepo/turborepo-features.png)
https://turborepo.org/docs#why-turborepo

## Sample Project

https://github.com/tanakaworld/flashcard

**Note: It is not production ready because there are some features missing, such as authentication.**

- `Web`: Flashcard client app
- `Admin`: Dashboard to manage card data
- `API`: GraphQL server that provides API for `Web` and `Admin`

There are three applications in the sample project. I tried to store the data in DB, fetch data dynamically using GraphQL, add an admin screen to manage the data. Then, I tried to use Turborepo to manage all services.

### How to configure Turborepo

There are only two configuration that you need.

#### workspaces

`workspaces` in `package.json` on the root is a property of npm workspaces. Once you define it, package.json files under the defined directories would be evaluated, and it would create symlinks under node_modules directory on the root of the repo. This would allow us to refer to a package from a different package in a monorepo.

```json
{
  "workspaces": [
    "apps/*",
    "packages/*"
  ]
}
```

#### turbo.json

Turborepo has only one config file, which is `turbo.json`. It defines build dependencies between packages. There are keys are the command name such as `dev` and `build`. Once you run `turbo run <command>`, all the commands in each package.json are executed.

For example, `web#test:integration` has `dependsOn` property, which has dependency to `web#build`. So once you execute `turbo run test:integration --filter=web` , `web#build` would surely be executed before `test:integration`.

```json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "web#build": {
      "dependsOn": [
        "^build",
        "$NEXT_PUBLIC_GQL_SERVER_URI"
      ],
      "outputs": [".next/**"]
    },
    "admin#build": {
      "dependsOn": [
        "^build",
        "$NEXT_PUBLIC_GQL_SERVER_URI"
      ],
      "outputs": [".next/**"]
    },
    "api#build": {
      "dependsOn": [
        "^build",
        "$DATABASE_URL",
        "$ORIGIN_NAME_WEB",
        "$ORIGIN_NAME_ADMIN"
      ],
      "outputs": ["build/**"]
    },
    "lint": {
      "outputs": []
    },
    "lint:fix": {
      "outputs": []
    },
    "test": {
      "outputs": []
    },
    "test:integration": {
      "outputs": []
    },
    "web#test:integration": {
      "dependsOn": ["web#build"],
      "outputs": []
    },
    "dev": {
      "cache": false
    },
    "clean": {
      "cache": false
    },
    "setup": {
      "cache": false
    }
  }
}
```

## Investigation Topics

### Topic 1: Caching

Turborepo generates a hash based on certain rules and saves the output of tasks. It reuses the output to improve build efficiency.
A hash is used to determine whether a build will hit the cache, if matching a hash, it would skip executing that task, and moves or downloads the cached output.

Cloud caching Vercel provides called “Remote caching”, which is beta as of May 2022. Remote caching needs to sing in Vercel in each local environment. If one person has uploaded a cache, and then others hit that cache, it will be downloaded and replayed.

Once you run `npx turbo run build`, `build` script in each package is run. You would notice `cache hit, replaying output` which means Turborepo used cached artifacts without running the task. If hitting a cache, Turborepo replays stdout log saved in `.turbo/.turbo/turbo-build.log`.

Logs when running `npx turbo run build`:

```bash
√ flashcard % npx turbo run build
• Packages in scope: admin, api, config, jest-internal, tsconfig, ui, web
• Running build in 7 packages
• Remote computation caching enabled (experimental)
api:build: cache hit, replaying output 9effa2fc44a41e0f
•••
admin:build: cache hit, replaying output 183356efe25f7c63
•••
web:build: cache hit, replaying output b3b90d06be369eab
•••

 Tasks:    3 successful, 3 total
Cached:    3 cached, 3 total
  Time:    137ms >>> FULL TURBO
```

Contents in `.turbo/.turbo/turbo-build.log`:

```log
[32madmin:build: [0mcache hit, replaying output [2mec363ea39f93b492[0m
[32madmin:build: [0m
[32madmin:build: [0m> admin@0.0.0 build
[32madmin:build: [0m> next build
[32madmin:build: [0m
[32madmin:build: [0minfo  - Loaded env from /Users/tanakaworld/ws/github.com/tanakaworld/flashcard/apps/admin/.env
[32madmin:build: [0minfo  - Checking validity of types...
[32madmin:build: [0minfo  - Creating an optimized production build...
[32madmin:build: [0minfo  - Compiled successfully
[32madmin:build: [0minfo  - Collecting page data...
[32madmin:build: [0minfo  - Generating static pages (0/3)
[32madmin:build: [0minfo  - Generating static pages (3/3)
[32madmin:build: [0minfo  - Finalizing page optimization...
[32madmin:build: [0m
[32madmin:build: [0mPage                                       Size     First Load JS
[32madmin:build: [0m┌ ○ /                                      22 kB           134 kB
[32madmin:build: [0m├   /_app                                  0 B             112 kB
[32madmin:build: [0m└ ○ /404                                   193 B           112 kB
[32madmin:build: [0m+ First Load JS shared by all              112 kB
[32madmin:build: [0m  ├ chunks/framework-c4190dd27fdc6a34.js   42 kB
[32madmin:build: [0m  ├ chunks/main-24e9726f06e44d56.js        26.9 kB
[32madmin:build: [0m  ├ chunks/pages/_app-8b0b2d113007eece.js  41.7 kB
[32madmin:build: [0m  └ chunks/webpack-575f60f3d6dc216c.js     1.03 kB
[32madmin:build: [0m
[32madmin:build: [0m○  (Static)  automatically rendered as static HTML (uses no initial props)
[32madmin:build: [0m
```

On the other hand, if not hitting a cache, Turborepo would run a task again. This is a log after modifying `apps/admin`. You would notice `admin:build: cache miss, executing ec363ea39f93b492`.

```bash
• Packages in scope: admin, api, config, jest-internal, tsconfig, ui, web
• Running build in 7 packages
• Remote computation caching enabled (experimental)
api:build: cache hit, replaying output 9effa2fc44a41e0f
•••
web:build: cache hit, replaying output b3b90d06be369eab
•••
admin:build: cache miss, executing ec363ea39f93b492
•••

 Tasks:    3 successful, 3 total
Cached:    2 cached, 3 total
  Time:    10.251s
```


### Topic 2: GraphQL codegen and sharing types

Tried GraphQL codegen, and sharing generated types. `apps/api` is the GraphQL server for `apps/web` and `apps/admin`. Running `npm run codegen`, TS types would be generated under `apps/api/src/types/generated/graphql.ts`. `apps/api/package.json` has `types` that is a property of TypeScript[^publishing-types]. You can export types with it.

[^publishing-types]: Publishing types https://www.typescriptlang.org/docs/handbook/declaration-files/publishing.html

apps/api/package.json:
```json
{
  "types": "./src/types/__generated__/graphql.ts"
}
```

Then, your can import the exported types everywhere in the monorepo as usual. `api` is the package name of `apps/api`.

```ts
import { Card } from "api";
const cardList: Card[] = [];
```


### Topic 3: Deployment & Remote caching

#### Vercel

I deployed Next.js apps on Vercel. That’s the easiest way to deploy and what we need is not so difficult. There are multiple projects in a repository, simply tell the build command and where the project root is.

![vercel-build-setting-1.png](/images/2022-05-29-fullstack-web-app-with-turborepo/vercel-build-setting-1.png)
![vercel-build-setting-1.png](/images/2022-05-29-fullstack-web-app-with-turborepo/vercel-build-setting-2.png)

With `--filter` option, turborepo would execute tasks related to a package. `turbo.json` knows dependencies of `web` in this case, we don’t need to be aware of dependencies.

- Pull Request #1: [Job1](https://github.com/tanakaworld/flashcard/runs/6594612848?check_suite_focus=true), [Job2](https://github.com/tanakaworld/flashcard/runs/6594942090?check_suite_focus=true) 
- Pull Request #2: [Job1](https://github.com/tanakaworld/flashcard/runs/6595140140?check_suite_focus=true)

There are two pull requests and the pull request #1 has two jobs. #1-Job1 took 24 seconds on build because there were no cache. `npm run build` said `cache miss, executing 9effa2fc44a41e0f`. However, the build in #1-Job2 took only 1 second, saying `cache hit, replaying output b3b90d06be369eab`. It just replayed cached console output and move cached artifacts.

We can enable remote caching on CI as well[^turborepo-github-actions].

[^turborepo-github-actions]: https://turborepo.org/docs/ci/github-actions

```yaml
•••
jobs:
  build:
    •••
    env:
      TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
      TURBO_TEAM: ${{ secrets.TURBO_TEAM }}
```

#### Heroku

`apps/api` is deployed on Heroku because it requires MySQL to store the data.

Heroku has terminated GitHub integration since April due to an incident[^heroku-incident]. I could not use GitHub repo integration and tried deploying via CLI on GitHub Actions.

Create an app on Heroku and configure Maria DB (MySQL compatibility database for free on Heroku).

```bash
$ heroku login
$ heroku create <app-name>

# https://devcenter.heroku.com/articles/nodejs-support
$ heroku buildpacks:set heroku/nodejs -a=<app-name>

# https://devcenter.heroku.com/articles/jawsdb-maria
$ heroku addons:create jawsdb-maria
$ heroku config -a=<app-name>
$ heroku config:set DATABASE_URL=mysql://••• -a=<app-name>
```

I wanted to build and deploy API related stuff only so customized the build step for Heroku. `--filter` is an option of Turborepo[^turborepo-filter-option]. `heroku-postbuild`[^heroku-post-build] script is evaluated by Heroku on build step.

```json
{
  "scripts": {
    •••
    "heroku-postbuild": "turbo run build --filter=api"
  }
}
```

[^heroku-incident]: Plans to Re-enable the GitHub Integration https://blog.heroku.com/github-integration-update
[^turborepo-filter-option]: `--filter` option https://turborepo.org/docs/core-concepts/filtering
[^heroku-post-build]: `heroku-post-build` https://devcenter.heroku.com/articles/nodejs-support#customizing-the-build-process


### Topic 4: Sharing configuration

Tried sharing Jest related configuration and dependencies. Created `packages/jest-internal`. We need to avoid conflicting package name against the packages in the world. That's why naming **jest-internal**.

```json
{
  "name": "jest-internal",
  "files": [
    "jest.config.js",
    "setupFiles/jest-fetch-mock.ts",
    "setupFiles/jsdom.ts"
  ],
  "dependencies": {
    "@testing-library/jest-dom": "5.16.4",
    "@testing-library/react": "12.1.5",
    "@types/jest": "27.5.1",
    "jest": "28.1.0",
    "jest-environment-jsdom": "28.1.0",
    "ts-jest": "28.0.2"
  },
  "devDependencies": {
    "jest-fetch-mock": "3.0.3"
  }
}
```

`files` property exports files in the package. Once npm dependencies are installed, they will be installed under node_modules directory on the root of the repo. That’s why Jest can be used anywhere in the repository.

You can reuse shared files from another package like this:

```js
// apps/web/jest.config.js
const base = require("jest-internal/jest.config");

module.exports = {
  ...base,
  testEnvironment: "jsdom",
  setupFilesAfterEnv: [
    "jest-internal/setupFiles/jsdom.ts",
    "jest-internal/setupFiles/jest-fetch-mock.ts",
  ],
  moduleNameMapper: {
    "~/(.*)": "<rootDir>/src/$1",
  },
};
```

## References

- Turborepo
  - https://turborepo.org/
  - https://vercel.com/docs/concepts/git/monorepos
  - https://www.youtube.com/watch?v=YX5yoApjI3M
- Monorepo
  - https://circleci.com/blog/monorepo-dev-practices/
  - https://semaphoreci.com/blog/what-is-monorepo ○ https://monorepo.tools
- GraphQL
  - https://www.apollographql.com/docs/react/get-started
  - https://www.apollographql.com/docs/apollo-server/getting-started
- npm
  - https://docs.npmjs.com/cli/v7/using-npm/workspaces
- Prisma
  - https://www.prisma.io/
 
 
