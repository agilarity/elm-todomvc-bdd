module IT.EnableTodoEditingPT exposing (all)

import ID
import IT.App.Action exposing (addNewTodo, completeTodo, enableTodoEditing, startApp)
import ProgramTest exposing (expectViewHas, expectViewHasNot)
import Test exposing (Test, describe, test)
import Test.Html.Selector exposing (class, id)



-- import IT.App.Result exposing (ensure)


all : Test
all =
    describe "GOAL-7: Enable Todo Editing"
        [ test "RULE-7.1: Should make the todo editable" <|
            \() ->
                -- Given the todo
                startApp
                    |> addNewTodo "Todo 1"
                    -- When the todo is double-clicked
                    |> enableTodoEditing 1
                    -- Then the todo input will be visible
                    |> expectViewHas
                        [ class "editing"
                        , id (ID.buildItemId 1)
                        ]
        , test "RULE-7.5: Should not make the todo editable" <|
            \() ->
                -- Given the todo is complete
                startApp
                    |> addNewTodo "Todo 1"
                    |> completeTodo 1
                    -- When the todo is double-clicked
                    |> enableTodoEditing 1
                    -- Then the complete todo action will not be visible
                    |> expectViewHasNot
                        [ class "editing"
                        , id (ID.buildItemId 1)
                        ]
        ]



{- NOT COVERED

   RULE-7.2: Should see the focus on the todo input
   Given the todo
   When the todo is double-clicked
   Then the focus will be on the todo input

   RULE-7.3: Should not see the complete todo action
   Given the todo
   When the todo is double-clicked
   Then the complete todo action will not be visible

   RULE-7.4: Should not see the delete todo action
   Given the todo
   And the todo is double-clicked
   When the cursor hovers the todo
   Then the delete todo action will not be visible
-}
