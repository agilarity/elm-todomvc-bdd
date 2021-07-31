# Elm • TodoMVC ~ BDD

[Elm](https://elm-lang.org/) - *"A delightful language for reliable web applications."*

This project demonstrates a behavior driven implementation of the [TodoMVC](http://todomvc.com/) specification using the Elm language.

## Elm Resources

* [Elm Docs](https://guide.elm-lang.org/)
* [Elm Slack](https://elmlang.slack.com)
* [Elm Discourse](https://discourse.elm-lang.org/)
* [Elm Radio](https://elm-radio.com/)

## Implementation

* [Behavioral requirements](doc/requirements/solution-overview.md) were written to define a functional finish line.
* All requirements were implemented in a [test driven](https://en.wikipedia.org/wiki/Test-driven_development) manner.
* The Requirements Coverage Report provides an objective assessment of progress. Execute `./run.sh coverage` to see the report.
* Project decisions are documented in [doc/decisions](doc/decisions).

### Deviation from TodoMVC
* The TodoMVC style was modified to make the `strong` element more visible.

## Build Instructions

The project includes a run script. `./run.sh help` will show the available commands.

1. Execute  `./run prod` to build the production version.
2. Open the `site/index.html` in your Browser.

## Credits

* This project was bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).
* Evan's [Elm TodoMVC](https://github.com/evancz/elm-todomvc) example was very helpful.
* Created by [Joseph Cruz](http://agilarity.com)
