# 14. Run elm-review on file changes

## Status

Accepted

## Context

We need to prevent coding errors as early as possible.

## Decision

We will configure [elm-review](https://package.elm-lang.org/packages/jfmengels/elm-review/latest) to run after every file change.

## Consequences

`elm-review` will ...

* Raise errors

* Provides Quick Fixes for some errors

* Help developers learn better practices
