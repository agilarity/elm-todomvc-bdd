module IT.ChangeTitleOnBlurPT exposing (all)

import ID
import IT.App.Action exposing (addNewTodo, blurTodo, enableTodoEditing, fillInTodo, startApp)
import IT.App.Result exposing (ensureTodoLabel)
import ProgramTest exposing (done, ensureViewHasNot)
import Test exposing (Test, describe, test)
import Test.Html.Selector exposing (class, id)


all : Test
all =
    describe "GOAL-8: Change Title (on blur)"
        [ test "RULE-8.1: Should change the todo" <|
            \() ->
                -- Given the todo is editable
                startApp
                    |> addNewTodo "Todo 1"
                    |> enableTodoEditing 1
                    -- And the title is filled
                    |> fillInTodo 1 "Verify change"
                    -- When the todo loses focus
                    |> blurTodo 1
                    -- Then the change will be visible
                    |> ensureTodoLabel 1 "Verify change"
                    |> done
        , test "RULE-8.2: Should exit the editing mode" <|
            \() ->
                -- Given the todo is editable
                startApp
                    |> addNewTodo "Todo 1"
                    |> enableTodoEditing 1
                    -- And the title is filled
                    |> fillInTodo 1 "Change Todo"
                    -- When the todo loses focus
                    |> blurTodo 1
                    -- Then the todo will not be editable
                    |> ensureViewHasNot
                        [ class "editing"
                        , id (ID.buildItemId 1)
                        ]
                    |> done
        ]
