module IT.ShowActiveTodosPT exposing (all)

import Filter exposing (Filter(..))
import IT.App.Action exposing (addNewTodo, completeTodo, showActiveTodos, startApp)
import IT.App.Result exposing (ensureFilterSelected, ensureTodoNotPresent, ensureTodoPresent)
import ProgramTest exposing (done)
import Test exposing (Test, describe, test)


all : Test
all =
    describe "GOAL-17: Show Active Todos"
        [ test "RULE-17.1: Should see the active todos" <|
            \() ->
                -- Given the list has 5 todos
                startApp
                    |> addNewTodo "Todo 1"
                    |> addNewTodo "Todo 2"
                    |> addNewTodo "Todo 3"
                    |> addNewTodo "Todo 4"
                    |> addNewTodo "Todo 5"
                    -- And two todos are completed
                    |> completeTodo 2
                    |> completeTodo 4
                    -- When the show active action is clicked
                    |> showActiveTodos
                    -- Then the list will have 3 active todos
                    |> ensureTodoPresent 1
                    |> ensureTodoNotPresent 2
                    |> ensureTodoPresent 3
                    |> ensureTodoNotPresent 4
                    |> ensureTodoPresent 5
                    |> done
        , test "RULE-17.2: Should select the active filter" <|
            \() ->
                -- GIVEN
                startApp
                    -- When the show active todos action is clicked
                    |> showActiveTodos
                    -- Then the show active todos action will be selected
                    |> ensureFilterSelected Active
                    |> done
        , test "RULE-17.3: Should hide the completed todo" <|
            \() ->
                -- Given the list has 5 todos
                -- And two todos are completed
                startApp
                    |> addNewTodo "Todo 1"
                    |> addNewTodo "Todo 2"
                    |> addNewTodo "Todo 3"
                    |> addNewTodo "Todo 4"
                    |> addNewTodo "Todo 5"
                    |> completeTodo 2
                    |> completeTodo 4
                    -- And the show active action is clicked
                    |> showActiveTodos
                    -- When an active todo is completed
                    |> completeTodo 3
                    -- Then the list will have 2 active todos
                    |> ensureTodoPresent 1
                    |> ensureTodoNotPresent 2
                    |> ensureTodoNotPresent 3
                    |> ensureTodoNotPresent 4
                    |> ensureTodoPresent 5
                    |> done
        ]
