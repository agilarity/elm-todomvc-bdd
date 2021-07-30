# GOAL-7: Enable Todo Editing

```gherkin
As an Editor, enable the editing of a todo
```

## RULE-7.1: Should make the todo editable

```gherkin
Given the todo
When the todo is double-clicked
Then the todo input will be visible
```

## RULE-7.2: Should see the focus on the todo input

```gherkin
Given the todo
When the todo is double-clicked
Then the focus will be on the todo input
```

## RULE-7.3: Should not see the complete todo action

```gherkin
Given the todo
When the todo is double-clicked
Then the complete todo action will not be visible
```

## RULE-7.4: Should not see the delete todo action

```gherkin
Given the todo
And the todo is double-clicked
When the cursor hovers the todo
Then the delete todo action will not be visible
```

## RULE-7.5: Should not make the todo editable

```gherkin
Given the todo is complete
When the todo is double-clicked
Then the complete todo action will not be visible
```
