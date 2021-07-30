# GOAL-16: Show All Todos

## RULE-16.1: Should see all the todos

```gherkin
Given the list has 5 todos
And 2 todos are completed
When the show all action is clicked
Then all the todos will be visible
```

## RULE-16.2: Should select the all filter

```gherkin
When the show all todos action is clicked
Then the show all todos action will be selected
```

## RULE-16.3: Should see the completed todo

```gherkin
Given the list has 5 todos
And 2 todos are completed
And the show all action is clicked
When an active todo is completed
Then all the todos will be visible
```

## RULE-16.4: Should see the activated todo

```gherkin
Given the list has 5 todos
And 2 todos are completed
And the show all action is clicked
When a completed todo is activated
Then all the todos will be visible
```
