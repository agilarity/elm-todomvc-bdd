# GOAL-13: Toggle All Todos Complete

```gherkin
As an Editor, toggle the complete status of all the todos
```

## RULE-13.1: Should mark the todos complete

```gherkin
Given the todo list has an active todo
When the complete all todo action is clicked
Then all the todos will be marked complete
```

## RULE-13.2: Should mark the todos active

```gherkin
Given all the todos are marked complete
When the complete all todo action is clicked
Then all the todos will be marked active
```
