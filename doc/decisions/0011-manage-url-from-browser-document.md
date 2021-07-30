# 11. Manage URL from `Browser.document`

## Status

Accepted

## Context

We need to respond to URL change in this project. We can use navigation support provided by `Browser.application` or keep `Browser.document` and implement the URL support we need.

## Decision

We will implement the logic to respond to URL changes from  `Browser.document`.

## Consequences

* Only implements what we need.
* Keeps the code simple.
* See Bernardo Gomes'a article on [managing URL's from `Browser.element` ](https://github.com/elm/browser/blob/1.0.2/notes/navigation-in-elements.md) to explore why this could be a good idea.
