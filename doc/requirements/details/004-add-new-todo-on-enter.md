# GOAL-4: Add New Todo (on enter)

```gherkin
As an Editor, enter the new todo
```

## RULE-4.1: Should not add an empty new todo

```gherkin
Given the new todo is filled with only space characters
When the enter key is pressed
Then the new todo will not be visible in the list
```

## RULE-4.2: Should add the new todo

```gherkin
Given the new todo is filled
When the enter key is pressed
Then the new todo will be visible in the list
```

## RULE-4.3: Should clear the new todo input

```gherkin
Given the new todo is filled
When the enter key is pressed
Then the new todo input will be empty
```

## RULE-4.4: Should trim the new todo

```gherkin
Given the new todo is filled with leading and trailing spaces
When the enter key is pressed
Then the new todo will not have leading or trailing spaces
```
