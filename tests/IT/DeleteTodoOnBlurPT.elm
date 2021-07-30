module IT.DeleteTodoOnBlurPT exposing (all)

import IT.App.Action exposing (addNewTodo, blurTodo, enableTodoEditing, fillInTodo, startApp)
import IT.App.Result exposing (ensureTodoNotPresent)
import ProgramTest exposing (done)
import Test exposing (Test, describe, test)


all : Test
all =
    describe "GOAL-11: Delete Todo (on blur)"
        [ test "RULE-11.1: Should delete the todo" <|
            \() ->
                -- Given the todo is filled with only space characters
                startApp
                    |> addNewTodo "Todo 1"
                    |> enableTodoEditing 1
                    |> fillInTodo 1 "   "
                    -- When the todo loses focus
                    |> blurTodo 1
                    -- Then the todo will not be visible
                    |> ensureTodoNotPresent 1
                    |> done
        ]
