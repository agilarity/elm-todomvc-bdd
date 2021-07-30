module IT.ShowCompletedTodosPT exposing (all)

import Filter exposing (Filter(..))
import IT.App.Action exposing (addNewTodo, completeTodo, showCompletedTodos, startApp)
import IT.App.Result exposing (ensureFilterSelected, ensureTodoNotPresent, ensureTodoPresent)
import ProgramTest exposing (done)
import Test exposing (Test, describe, test)


all : Test
all =
    describe "GOAL-18: Show Completed Todos"
        [ test "RULE-18.1: Should see the completed todos" <|
            \() ->
                -- Given the list has 5 todos
                startApp
                    |> addNewTodo "Todo 1"
                    |> addNewTodo "Todo 2"
                    |> addNewTodo "Todo 3"
                    |> addNewTodo "Todo 4"
                    |> addNewTodo "Todo 5"
                    -- And 2 todos are completed
                    |> completeTodo 2
                    |> completeTodo 4
                    -- When the show completed action is clicked
                    |> showCompletedTodos
                    -- Then the list will have 2 completed todos
                    |> ensureTodoNotPresent 1
                    |> ensureTodoPresent 2
                    |> ensureTodoNotPresent 3
                    |> ensureTodoPresent 4
                    |> ensureTodoNotPresent 5
                    |> done
        , test "RULE-18.2: Should select the completed filter" <|
            \() ->
                -- GIVEN
                startApp
                    -- When the show completed todos action is clicked
                    |> showCompletedTodos
                    -- Then the show completed todos action will be selected
                    |> ensureFilterSelected Completed
                    |> done
        , test "RULE-18.3: Should hide the activated todo" <|
            \() ->
                -- Given the list has 5 todos
                startApp
                    |> addNewTodo "Todo 1"
                    |> addNewTodo "Todo 2"
                    |> addNewTodo "Todo 3"
                    |> addNewTodo "Todo 4"
                    |> addNewTodo "Todo 5"
                    -- And 2 todos are completed
                    |> completeTodo 2
                    |> completeTodo 4
                    -- And the show completed action is clicked
                    |> showCompletedTodos
                    -- When a completed todo is activated
                    |> completeTodo 4
                    -- Then the list will have 1 completed todos
                    |> ensureTodoNotPresent 1
                    |> ensureTodoPresent 2
                    |> ensureTodoNotPresent 3
                    |> ensureTodoNotPresent 4
                    |> ensureTodoNotPresent 5
                    |> done
        ]
