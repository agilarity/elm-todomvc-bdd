# 18. Generate bash help documentation

Date: 2021-08-04

## Status

Accepted

## Context

We needed to make it easier to create and maintain help documentation.

## Decision

We will use the [Quick Self-Doc](https://github.com/icy/bash-coding-style) technique to generate help from function comments.

## Consequences

Documenting a function like this...

```bash
function build_prod { #help: build and copy minified `elm.js` to site
```

Will produce a help message like this..

```console
help: build.sh <command>
Display information about build.sh commands

    Commands:
      build_prod  build and copy minified `elm.js` to site
      help        show available commands
```
