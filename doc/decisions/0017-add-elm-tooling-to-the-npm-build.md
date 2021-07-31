# 17. Add elm tooling to the npm build

Date: 2021-07-31

## Status

Accepted

## Context

We need to support development and CI setup by installing the right versions of Elm tools.

## Decision

We will use [elm-tooling-cli](https://github.com/elm-tooling/elm-tooling-cli) and `npm` to install Elm tools.

## Consequences

* Supported tools like `elm` and `elm-review` are installed by [elm-tooling-cli](https://github.com/elm-tooling/elm-tooling-cli).
* Other tools like `elm-review` and `elm-live` are installed by `npm`.
* Execute `./run tools` to install all the Elm tools. You can also run `npm install`.
