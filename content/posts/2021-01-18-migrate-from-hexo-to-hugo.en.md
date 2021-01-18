---
title: "Migrated From Hexo to Hugo"
date: 2021-01-18T21:35:10+09:00
slug: migrate-from-hexo-to-hugo
tags:
- blog
---

I've migrated the blog tool from [Hexo](https://hexo.io/) to [Hugo](https://gohugo.io/)
(The last moving: [Moved from Middleman to Hexo](/move-to-hexo-from-middleman/)) 

## Motivation

1. Hexo generator was really slow
1. Dark mode support
1. Multiple Languages support (To write in English too)
1. Bored

I could have done 2 and 3 with Hexo, but I was looking for another tool for 4.
To be honest, I didn't think much about it and made a quick decision to use Hugo.

## What I had to update

I was able to use Markdown files as it was mostly, but I made some changes.

### Directory Structure

- Moved Markdown files (`source` -> `content/posts`)
- Changed path for images

### Front Matter

- `tags`: Delete indents of tag items
- `slug`: Added
    - Hexo converts a file name `yyyy-MM-dd-<path_name>.md` and the `path_name` will be the real path.
    - Hugo defaults to a file name or `slug` in Front Matter as the real path name.
    - I wrote a bash script to insert slug from file name. ([gist](https://gist.github.com/tanakaworld/519a3794d056cbc45d281ff1aa25c121))
