# 4. Run tests on file changes

## Status

Accepted

## Context

We need to know when a change causes a regression as soon as possible.

## Decision

We will run `elm-test --watch` to get immediate feedback on code changes.

## Consequences

The `--watch` option automatically guards against regressions by running the tests when an Elm file changes.
