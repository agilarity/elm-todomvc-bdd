# 16. Prefer elm make and elm-live

## Status

Accepted

Amends [5. Code with live server](0005-code-with-live-server.md)

Supercedes [2. Bootstrap with create-elm-app](0002-bootstrap-with-create-elm-app.md)

## Context

We need more control over the build.

## Decision

We will use `elm-live` and `elm make` instead of `elm-app`.

## Consequences

* Ejected [Create Elm App](https://github.com/halfzebra/create-elm-app)
* Added `./run.sh live` to start `elm-live`
* Added `./run.sh prod` to build and replace `elm.js` with the minified version
