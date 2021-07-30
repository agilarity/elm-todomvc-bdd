# GOAL-1: View Home Page

```gherkin
As an Editor, view the home page
```

## RULE-1.1: Should not see the main section

```gherkin
Given the todo list is empty
When the home page is viewed
Then the main section will not be visible
```

## RULE-1.2: Should not see the footer section

```gherkin
Given the todo list is empty
When the home page is viewed
Then the footer section will not be visible
```

## RULE-1.3: Should see the focus on the new todo input

```gherkin
When the home page is first viewed
Then the focus will be on the new todo input
```

## RULE-1.4: Should see the new todo placeholder

```gherkin
When the home page is first viewed
Then the new todo placeholder will be "What needs to be done?"
```

## RULE-1.5: Should select the default filter

```gherkin
When the home page is first viewed
Then the show all todos action will be selected
```
