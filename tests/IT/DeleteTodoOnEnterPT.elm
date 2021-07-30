module IT.DeleteTodoOnEnterPT exposing (all)

import IT.App.Action exposing (addNewTodo, enableTodoEditing, enterTodo, fillInTodo, startApp)
import IT.App.Result exposing (ensureTodoNotPresent)
import ProgramTest exposing (done)
import Test exposing (Test, describe, test)


all : Test
all =
    describe "GOAL-12: Delete Todo (on enter)"
        [ test "RULE-12.1: Should delete the todo" <|
            \() ->
                -- Given the todo is filled with only space characters
                startApp
                    |> addNewTodo "Todo 1"
                    |> enableTodoEditing 1
                    |> fillInTodo 1 "   "
                    -- When the enter key is pressed
                    |> enterTodo 1
                    -- Then the todo will not be visible
                    |> ensureTodoNotPresent 1
                    |> done
        ]
