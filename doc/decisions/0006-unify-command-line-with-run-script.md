# 6. Unify command line with run script

## Status

Accepted

## Context

We want to make it easier to discover and execute common tasks.

## Decision

We will use a [Taskfile](https://github.com/adriancooney/Taskfile) named `run.sh` to normalize common tasks.

## Consequences

* One API for project tasks.
* Can be integrated with `npm` scripts.
* Underlying tools and scripts are still available. The scrip is just a convenience.
