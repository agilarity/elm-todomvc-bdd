# 12. Report requirements coverage

## Status

Accepted

## Context

We need an easier way to assess when we are done. Assessment is enabled by clear [behavioral requirements](0007-document-behavioral-requirements.md) that mark the finish line and a [behavioral testing strategy](0008-verify-user-requirements-with-elm-program-test.md) that links tests to requirements. Manual inspections can verify requirements coverage by checking that every requirement is covered by an Elm Program Test. Manual inspection is slow and error prone. We can improve it with automation.

## Decision

We will create a report to assess requirements coverage and discover which requirements have not been covered.

## Consequences

* Provides an objective assessment of progress in much less than a second.
* Makes it easier to keep requirements and test links synchronized.
* Executes from [run script](0006-unify-command-line-with-run-script.md)
