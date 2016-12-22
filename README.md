# danger-clubhouse

A pull request plugin to [danger.systems](http://danger.systems) that
links to stories from [Clubhouse](https://app.clubhouse.io) to
[GitHub](https://github.com/).

## Why?

Clubhouse currently only supports [one-way linking](https://help.clubhouse.io/hc/en-us/articles/207540323-Using-The-Clubhouse-GitHub-Integration) from Clubhouse to
GitHub. As part of our GitHub workflow, we need to link to stories in
Clubhouse so that reviewer will have more context about the pull request.

This danger plugin does exactly that :)

## Example

![Screen Shot](/pictures/screenshot.png?raw=true)

## Installation

Add `danger-clubhouse` to your Gemfile.

```
gem 'danger-clubhouse'
```

## Usage

### clubhouse.organization

Set the orgazination name for Clubhouse.

### clubhouse.link_stories!

Find stories in the format of chXXX from commits and branch name and
link to them.

![](images/have_you_updated_changelog.png)

## Copyright

Copyright (c) Teng Siong Ong, 2016

MIT License, see [LICENSE](LICENSE.txt) for details.
