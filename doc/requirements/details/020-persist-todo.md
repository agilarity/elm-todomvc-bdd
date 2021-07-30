# GOAL-20: Persist Todo

```gherkin
As a System, persist the todo data to local storage
```

## RULE-20.1: Should load the default model

```gherkin
Given there are no todos in local storage
When the todo app is started
Then the default model will be saved
```

## RULE-20.2: Should load the todo data

```gherkin
Given the todos in local storage
When the todo app is started
Then the todos will be loaded from local storage
```

## RULE-20.3: Should add the new todo

```gherkin
Given the todos
When the todo is added
Then the todo will be added to local storage
```

## RULE-20.4: Should delete the todo

```gherkin
Given the todo
When the todo is deleted
Then the todo will be removed from local storage
```

## RULE-20.5: Should update the title of a todo

```gherkin
Given the todo
When the title is changed
Then the todo will be updated in local storage
```

## RULE-20.6: Should update the complete status of a todo

```gherkin
Given the todo
When the complete status is changed
Then the todo will be updated in local storage
```

## RULE-20.7: Should update the completed status of all todos

```gherkin
Given the todos
When the complete status of all todos is changed
Then the todos will be updated in local storage
```

## RULE-20.8: Should delete the cleared todos

```gherkin
Given the completed todos
When the clear completed todos action is clicked
Then the todos will be updated in local storage
```
