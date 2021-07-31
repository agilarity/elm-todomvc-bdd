# Elm Todo MVC

## Solution Context

Elm Todo MVC is a stand-alone application that enable an unauthenticated user to manage todo items in their Browser.

![Solution Context](images/solution-context.svg)

## Requirements

The requirements were derived from the [specification](https://github.com/tastejs/todomvc/blob/master/app-spec.md) and [template](https://github.com/tastejs/todomvc-app-template) of the [TodoMVC](https://todomvc.com) project. The diagram below shows how the goals relate to one another. Dependencies flow from left to right. Goals on the left are supported by the goals they link to on the right. Numbered goals have rules that must be implemented. The goal numbers map to the specification files.

![Requirements Tree](images/requirements-tree.svg)

## Requirement Details

* [001-view-home-page.md](details/001-view-home-page.md)
* [002-view-info-footer.md](details/002-view-info-footer.md)
* [003-add-new-todo-on-blur.md](details/003-add-new-todo-on-blur.md)
* [004-add-new-todo-on-enter.md](details/004-add-new-todo-on-enter.md)
* [005-toggle-todo-complete.md](details/005-toggle-todo-complete.md)
* [006-delete-todo.md](006-delete-todo.md)
* [007-enable-todo-editing.md](details/007-enable-todo-editing.md)
* [008-change-title-on-blur.md](details/008-change-title-on-blur.md)
* [009-change-title-on-enter.md](details/009-change-title-on-enter.md)
* [010-cancel-todo-change.md](details/010-cancel-todo-change.md)
* [011-delete-todo-on-blur.md](details/011-delete-todo-on-blur.md)
* [012-delete-todo-on-enter.md](details/012-delete-todo-on-enter.md)
* [013-toggle-all-todos-complete.md](details/013-toggle-all-todos-complete.md)
* [014-clear-completed-todos.md](details/014-clear-completed-todos.md)
* [015-view-items-left.md](details/015-view-items-left.md)
* [016-show-all-todos.md](details/016-show-all-todos.md)
* [017-show-active-todos.md](details/017-show-active-todos.md)
* [018-show-completed-todos.md](details/018-show-completed-todos.md)
* [019-change-browser-url.md](details/019-change-browser-url.md)
* [020-persist-todo.md](details/020-persist-todo.md)

## Not Covered

Requirements that are not covered by automated [Elm Program Tests](https://github.com/avh4/elm-program-test/tree/3.5.0) are listed in the [Not Covered](not-covered.txt) file.
