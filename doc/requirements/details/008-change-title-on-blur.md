# GOAL-8: Change Title (on blur)

```gherkin
As an Editor, move the focus away from the todo
```

## RULE-8.1: Should change the todo

```gherkin
Given the todo is editable
And the title is filled
When the todo loses focus
Then the change will be visible
```

## RULE-8.2: Should exit the editing mode

```gherkin
Given the todo is editable
And the title is filled
When the todo loses focus
Then the todo will not be editable
```
