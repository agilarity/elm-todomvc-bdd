# GOAL-11: Delete Todo (on blur)

```gherkin
As an Editor, move the focus away from the todo
```

## RULE-11.1: Should delete the todo

```gherkin
Given the todo is filled with only space characters
When the todo loses focus
Then the todo will not be visible
```
