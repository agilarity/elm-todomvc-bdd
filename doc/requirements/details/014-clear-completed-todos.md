# GOAL-14: Clear Completed Todos

```gherkin
As an Editor, clear the completed todos
```

## RULE-14.1: Should not see the clear completed action

```gherkin
Given the todos are all active
When the home page is viewed
Then the clear completed action will be hidden
```

## RULE-14.2: Should not see the completed todos

```gherkin
Given the completed todos
When the clear completed action is clicked
Then the completed todos will not be visible
```
