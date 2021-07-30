# 3. Run elm-format on file changes

## Status

Accepted

## Context

We need to conform with Elm style and leverage automation.

## Decision

We will configure `elm-format` to run after every file change.

## Consequences

`elm-format` will...

* Enforce single and multi-line format standards
* Refactor some expressions
* Organize imports

Running it on file changes provides immediate feedback.

The space sensitivity of the Elm language can be surprising. It is not always obvious where the space is needed to resolve the syntax error. This not a problem with the `elm-format` but it is something you will encounter. Be patient and press on. You would have needed to resolve that problem anyway.
