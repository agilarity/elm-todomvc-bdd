# GOAL-5: Toggle Todo Complete

```gherkin
As an Editor, toggle the complete status of a todo
```

## RULE-5.1: Should mark the todo complete

```gherkin
Given the todo is not complete
When the complete todo action is clicked
Then the todo will be complete
```

## RULE-5.2: Should mark the todo active

```gherkin
Given the todo is complete
When the complete todo action is clicked
Then the todo will be not be complete
```
