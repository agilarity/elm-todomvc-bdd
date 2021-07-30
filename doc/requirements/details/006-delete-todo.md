# GOAL-6: Delete Todo

```gherkin
As an Editor, delete the todo
```

## RULE-6.1: Should delete the todo

```gherkin
Given the todo
When the delete todo action is clicked
Then the todo will not be visible
```

## RULE-6.2: Should not see the delete todo action label

```gherkin
Given the todo
When the todo is viewed
Then the delete todo action text will not be visible
```

## RULE-6.3: Should see the delete todo action on hover

```gherkin
Given the todo
When the cursor hovers the todo
Then the delete todo action will be visible
```
