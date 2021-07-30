# 9. Verify solution design with elm-test

## Status

Accepted

## Context

We need to assure the solution design was implemented correctly.

## Decision

We will verify correct design with unit tests using the following conventions.

### Messages And View

Write an Elm Test file for each message. Name the `file` after the message. Group tests by responsibility into `action`, `update`, and `view` `Test` suites. `describe` suites simply as `Verify Action`, `Verify Update`, and `Verify View` respectively.

#### Strategy

* `action` - Assure each user action sends the correct message.

* `update` - Assure each message updates the model and sends the correct effect message.

* `view` - Assure the expected model state results in the correct markup.

### Types

Write an Elm Test file for each type. Name the `file` after the type.

#### Strategy

* Test the decoders and encoders.

* Add additional tests as needed. Note that core logic should already be covered by the `update` tests. Consider if more requirements are needed to expose corner cases at the user level.

## Consequences

* One place to see how a message should affect behavior.
* Makes it easier to troubleshoot by providing useful [test points](https://en.wikipedia.org/wiki/Test_point).
