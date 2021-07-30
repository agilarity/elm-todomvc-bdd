# GOAL-18: Show Completed Todos

## RULE-18.1: Should see the completed todos

```gherkin
Given the list has 5 todos
And 2 of the todos are completed
When the show completed action is clicked
Then the list will have 2 completed todos
```

## RULE-18.2: Should select the completed filter

```gherkin
When the show completed todos action is clicked
Then the show completed todos action will be selected
```

## RULE-18.3: Should hide the activated todo

```gherkin
Given the list has 5 todos
And 2 todos are completed
And the show completed action is clicked
When a completed todo is activated
Then the list will have 1 completed todos
```
