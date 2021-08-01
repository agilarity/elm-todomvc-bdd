# Elm • TodoMVC ~ BDD

![example workflow](https://github.com/agilarity/elm-todomvc-bdd/actions/workflows/ci.yml/badge.svg)

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

To install Elm tools:

* Execute `./run tools`

To see production ver to start a development version in the Browser.sion in the Browser:

* Execute  `./run prod`
* Open the `site/index.html`

To start a live development server.

* Execute `./run live`


## Credits

* This project was bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).
* Evan's [Elm TodoMVC](https://github.com/evancz/elm-todomvc) example was very helpful.
* Created by [Joseph Cruz](http://agilarity.com)
