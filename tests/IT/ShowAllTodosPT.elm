module IT.ShowAllTodosPT exposing (all)

import Filter exposing (Filter(..))
import IT.App.Action exposing (addNewTodo, completeTodo, showAllTodos, startApp)
import IT.App.Result exposing (ensureFilterSelected, ensureTodoPresent)
import ProgramTest exposing (done)
import Test exposing (Test, describe, test)


all : Test
all =
    describe "GOAL-16: Show All Todos"
        [ test "RULE-16.1: Should see all the todos" <|
            \() ->
                -- Given the list has 5 todos
                startApp
                    |> addNewTodo "Todo 1"
                    |> addNewTodo "Todo 2"
                    |> addNewTodo "Todo 3"
                    |> addNewTodo "Todo 4"
                    |> addNewTodo "Todo 5"
                    -- And two of the todos are completed
                    |> completeTodo 2
                    |> completeTodo 4
                    -- When the show all action is clicked
                    |> showAllTodos
                    -- Then all the todos will be visible
                    |> ensureTodoPresent 1
                    |> ensureTodoPresent 2
                    |> ensureTodoPresent 3
                    |> ensureTodoPresent 4
                    |> ensureTodoPresent 5
                    |> done
        , test "RULE-16.2: Should select the all filter" <|
            \() ->
                -- GIVEN
                startApp
                    -- When the show all todos action is clicked
                    |> showAllTodos
                    -- Then the show all todos action will be selected
                    |> ensureFilterSelected All
                    |> done
        , test "RULE-16.3: Should see the completed todo" <|
            \() ->
                -- Given the list has 5 todos
                startApp
                    |> addNewTodo "Todo 1"
                    |> addNewTodo "Todo 2"
                    |> addNewTodo "Todo 3"
                    |> addNewTodo "Todo 4"
                    |> addNewTodo "Todo 5"
                    -- And two of the todos are completed
                    |> completeTodo 2
                    |> completeTodo 4
                    -- And the show all action is clicked
                    |> showAllTodos
                    -- When an active todo is completed
                    |> completeTodo 5
                    -- Then all the todos will be visible
                    |> ensureTodoPresent 1
                    |> ensureTodoPresent 2
                    |> ensureTodoPresent 3
                    |> ensureTodoPresent 4
                    |> ensureTodoPresent 5
                    |> done
        , test "RULE-16.4: Should see the activated todo" <|
            \() ->
                -- Given the list has 5 todos
                startApp
                    |> addNewTodo "Todo 1"
                    |> addNewTodo "Todo 2"
                    |> addNewTodo "Todo 3"
                    |> addNewTodo "Todo 4"
                    |> addNewTodo "Todo 5"
                    -- And two of the todos are completed
                    |> completeTodo 2
                    |> completeTodo 4
                    -- And the show all action is clicked
                    |> showAllTodos
                    -- When a completed todo is activated
                    |> completeTodo 4
                    -- Then all the todos will be visible
                    |> ensureTodoPresent 1
                    |> ensureTodoPresent 2
                    |> ensureTodoPresent 3
                    |> ensureTodoPresent 4
                    |> ensureTodoPresent 5
                    |> done
        ]
