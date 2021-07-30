module IT.DeleteTodoPT exposing (all)

import ID
import IT.App.Action exposing (addNewTodo, deleteTodo, startApp)
import IT.App.Result exposing (ensureTodoNotPresent, ensureTodoPresent)
import ProgramTest exposing (done, ensureViewHasNot)
import Test exposing (Test, describe, test)
import Test.Html.Selector exposing (id, text)


all : Test
all =
    describe "GOAL-6: Delete Todo"
        [ test "RULE-6.1: Should delete the todo" <|
            \() ->
                -- Given the todo
                startApp
                    |> addNewTodo "Todo 1"
                    |> ensureTodoPresent 1
                    -- When the delete todo action is clicked
                    |> deleteTodo 1
                    -- Then the todo will not be visible
                    |> ensureTodoNotPresent 1
                    |> done
        , test " RULE-6.2: Should not see the delete todo action label" <|
            \() ->
                -- Given the todo
                startApp
                    |> addNewTodo "Todo 1"
                    |> ensureTodoPresent 1
                    -- When the todo is viewed
                    -- Then the delete todo action text will not be visible
                    |> ensureViewHasNot
                        [ id (ID.buildDeleteButtonId 1)
                        , text ""
                        ]
                    |> done
        ]
