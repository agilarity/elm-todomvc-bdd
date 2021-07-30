# GOAL-10: Cancel Todo Change

```gherkin
As an Editor, cancel the change to a todo
```

## RULE-10.1: Should exit the editing mode

```gherkin
Given the todo is editable
When the escape key is pressed
Then the todo will not be editable
```

## RULE-10.2: Should restore the original todo

```gherkin
Given the todo is filled
When the escape key is pressed
Then the original todo will be visible
```
