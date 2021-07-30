# GOAL-17: Show Active Todos

## RULE-17.1: Should see the active todos

```gherkin
Given the list has 5 todos
And 2 todos are completed
When the show active action is clicked
Then the list will have 3 active todos
```

## RULE-17.2: Should select the active filter

```gherkin
When the show active todos action is clicked
Then the show active todos action will be selected
```

## RULE-17.3: Should hide the completed todo

```gherkin
Given the list has 5 todos
And 2 todos are completed
And the show active action is clicked
When an active todo is completed
Then the list will have 2 completed todos
```
