# 5. Code with live server

## Status

Accepted

Amended by [16. Prefer elm make and elm-live](0016-prefer-elm-make-and-elm-live.md)

## Context

We need to reduce the time it takes to get feedback on UI changes.

## Decision

We will run a "live" instance of the application during development (`elm-app start`).

## Consequences

This technique shortens the feedback loop and makes it easier to detect visual problems.

## Reference

* See [2. Bootstrap with create-elm-app](0002-bootstrap-with-create-elm-app.md)
