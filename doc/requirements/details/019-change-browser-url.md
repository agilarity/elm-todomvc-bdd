# GOAL-19: Change Browser URL

```gherkin
As an Editor, change the browser URL
```

## RULE-19.1: Should select the filter

```gherkin
Given the new URL is <url>
When the URL is changed
Then the selected filter will be <filter>

Examples:

| url | filter |
| http://localhost:300 | All |
| http://localhost:3000/ | All |
| http://localhost:3000/#/active | Active |
| http://localhost:3000/#/completed" | Completed |
| http://localhost:3000/#!/active | Active |
| http://localhost:3000/#!/completed" | Completed |
```
