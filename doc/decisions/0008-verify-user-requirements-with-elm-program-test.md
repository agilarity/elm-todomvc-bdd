# 8. Verify user requirements with elm-program-test

## Status

Accepted

## Context

We need assurance that all user interactions specified in the requirements are covered.

[Elm Program Test](https://github.com/avh4/elm-program-test/tree/3.5.0) makes it possible to write tests at the interface level for both human and system actors. Elm Program Test supports UI and Port testing.

## Decision

We will verify every goal and rule with an [Elm Program Test](https://github.com/avh4/elm-program-test/tree/3.5.0).

### Naming Conventions

* Name the test `file` after the goal name.
* Use the goal label to `describe` the test.
* Use the rule label as the `test` name.

  *Examples:*

  * `file` = AddNewTodoOnBlurPT.elm
  * `describe`= GOAL-3: Add New Todo (on blur)
  * `test` = RULE-3.1: Should not add an empty new todo

## Consequences

Benefits:

* Marks a clear finish line.
* Clear links to requirements.
* Guards against behavioral regression.

Accepting:

* [Elm Program Test](https://github.com/avh4/elm-program-test/tree/3.5.0) imposes the use of the Effect pattern.
  * See [Testing programs with Cmds](https://elm-program-test.netlify.app/cmds.html)
