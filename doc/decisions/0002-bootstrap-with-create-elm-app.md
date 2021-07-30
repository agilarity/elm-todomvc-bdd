# 2. Bootstrap with create-elm-app

## Status

Accepted

Superceded by [16. Prefer elm make and elm-live](0016-prefer-elm-make-and-elm-live.md)

## Context

We need [scripts](https://guide.elm-lang.org/optimization/asset_size.html) to support development and production builds for Elm.

## Decision

We will use the `elm-app` CLI tool provided by [Create Elm App](https://github.com/halfzebra/create-elm-app) to run scripts.

## Consequences

[Create Elm App](https://github.com/halfzebra/create-elm-app) provides a set of scripts that supports development with hot reloading and continuous testing.
