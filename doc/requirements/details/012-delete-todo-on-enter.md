# GOAL-12: Delete Todo (on enter)

```gherkin
As an Editor, enter the todo
```

## RULE-12.1: Should delete the todo

```gherkin
Given the todo is filled with only space characters
When the enter key is pressed
Then the todo will not be visible in the list
```
