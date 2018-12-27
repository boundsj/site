---
title: Janky Jekyll in Swift
date: 2018-12-27 10:11:00
summary: How I rebooted this site with Swift, Vapor, and an inspiration from Jekyll.
---

# Janky Jekyll in Swift

It’s been at least 16 years since blogging went “[legit, sort of](https://www.wired.com/2002/06/blogging-goes-legit-sort-of/)” so I’m a little late to the party. Since 2002 one of my hobbies has been setting up my own blogging systems and then ignoring them (see also [gym membership](https://www.usatoday.com/story/money/personalfinance/2016/04/27/your-gym-membership-good-investment/82758866/)). [Jekyll](https://jekyllrb.com) and GitHub pages made a lot of sense to me but the minimal setup and markdown file posting was _too easy_ and my addiction to setting up my own blogging infrastructure made that obvious approach a non-starter for me!

## Swift and Vapor

More recently, I’ve been experimenting with server-side Swift using the [Vapor](https://vapor.codes) framework and [Heroku](https://www.heroku.com) for hosting. I wanted to rebuild this site with those technologies but wrap them in something that works a lot like the Jekyll framework that (I think) I enjoy using. This has taken the form of [https://github.com/boundsj/site](https://github.com/boundsj/site) that currently hosts the implementation of [Rebounds.net](https://www.rebounds.net).

## Extending Vapor

So far, this implementation is an experimental and basic Vapor generated website. On top of that, I’ve bolted on a few things that make it work sort of like a poor performing and feature incomplete Jekyll framework, such as:

* A few simple [routes](https://www.hackingwithswift.com/articles/149/the-complete-guide-to-routing-with-vapor) for navigating to the index of the site and individual posts.
* A boot loading [script](https://github.com/boundsj/site/blob/4d22fb4c5c0405f833a850a02d75d7cbfe2b2257/Sources/App/boot.swift) that loads into memory the content of all of the post files that are committed to the site repo.
* Along with the boot script, [logic](https://github.com/boundsj/site/blob/4d22fb4c5c0405f833a850a02d75d7cbfe2b2257/Sources/App/FrontMatterUtils.swift) to parse out and organize any [front matter](https://jekyllrb.com/docs/front-matter/) included at the top of the markdown post files.

I also use a [Vapor Community Swift port](https://github.com/vapor-community/markdown) of [GitHub’s fork of cmark](https://github.com/github/cmark-gfm) to enable parsing and rendering in HTML of the content of the posts I write in GitHub flavored markdown.

## Auspicious Beginnings

I’ve enjoyed building this simple, bespoke, Jekyll-like system in Swift and can see now how I can spend even more time on it. For example, I think it might be interesting to implement my own CommonMark parser in Swift (see [Swift Talk’ CommonMark videos](https://talk.objc.io/episodes/S01E2-rendering-commonmark)) and extract the entire Jekyll style markdown parsing bits into a Swift package for sharing. However, what I most want to do is actually post more frequently!

![Image](https://farm5.staticflickr.com/4883/31463116437_b41536b661_n.jpg)
