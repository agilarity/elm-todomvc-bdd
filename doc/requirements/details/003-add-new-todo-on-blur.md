# GOAL-3: Add New Todo (on blur)

```gherkin
As an Editor, move the focus away from the new todo
```

## RULE-3.1: Should not add an empty new todo

```gherkin
Given the new todo is filled with only space characters
When the todo loses focus
Then the new todo will not be visible in the list
```

## RULE-3.2: Should add the new todo

```gherkin
Given the new todo is filled
When the todo loses focus
Then the new todo will be visible in the list
```

## RULE-3.3: Should clear the new todo input

```gherkin
Given the new todo is filled
When the todo loses focus
Then the new todo input will be empty
```

## RULE-3.4: Should trim the new todo

```gherkin
Given the new todo is filled with leading and trailing spaces
When the todo loses focus
Then the new todo will not have leading or trailing spaces
```
