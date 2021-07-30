# 10. Use simple builder pattern

## Status

Accepted

## Context

We need to minimize the impact of record changes.

## Decision

We will use a simple builder instead of a record or alias constructor to minimize field dependencies.

For example, given a type alias.

```ts
type alias Todo =
    { title : String
    , id : Int
    , complete : Bool
    , editing : Bool
    }
```

Create a simple builder that with default values.

```ts
buildTodo : Todo
buildTodo =
    { title = ""
    , id = 0
    , complete = False
    , editing = False
    }
```

we can then use `buildTodo`, `{buildTodo | title = "Todo 1", id = 1}` instead of the full record.

## Consequences

* Makes it easier to refactor records.
* Explicit field assignments avoids positional constructor errors and improves comprehension.
* Does not prevent more sophisticated builders can be introduced if needed.
