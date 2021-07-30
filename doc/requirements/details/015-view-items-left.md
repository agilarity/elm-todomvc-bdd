# GOAL-15: View Items Left

```gherkin
As an Editor, view the number of items left to be completed
```

## RULE-15.1: Should see the number of items left

```gherkin
Given the number of active todos
When the home page is viewed
Then the number of item left will match the number of active todos
```

## RULE-15.2: Should see the plural form of the items left label

```gherkin
Given the number of items left is not 1
When the home page is viewed
Then the label will be "items left"
```

## RULE-15.3: Should see the singular form of the items left label

```gherkin
Given there is 1 item left
When the home page is viewed
Then the label will be "item left"
```

## RULE-15.4: Should wrap the items left count with strong element

```gherkin
Given the items left count is visible
Then the count will be in a strong element
```

## RULE-15.5: Should see all the todos are complete

```gherkin
Given the number of items left is 0
When the home page is viewed
Then the complete all todos action will be checked
```

## RULE-15.6: Should see some of the todos are not complete

```gherkin
Given the number of items left is not 0
When the home page is viewed
Then the complete all todos action will not be checked
```
