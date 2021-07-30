module IT.ToggleTodoCompletePT exposing (all)

import Common.TestData exposing (buildTestModel)
import IT.App.Action exposing (completeTodo, startAppWith)
import IT.App.Result exposing (ensureTodoActive, ensureTodoCompleted)
import ProgramTest exposing (done)
import Test exposing (Test, describe, test)


all : Test
all =
    describe "GOAL-5: Toggle Todo Complete"
        [ test "RULE-5.1: Should mark the todo complete" <|
            \() ->
                -- Given the todo is not complete
                buildTestModel { totalItems = 1, completedItems = 0 }
                    |> startAppWith
                    -- When the complete todo action is clicked
                    |> completeTodo 1
                    -- Then the todo will be complete
                    |> ensureTodoCompleted 1
                    |> done
        , test "RULE-5.2: Should mark the todo active" <|
            \() ->
                -- Given the todo is complete
                buildTestModel { totalItems = 1, completedItems = 1 }
                    |> startAppWith
                    -- When the complete todo action is clicked
                    |> completeTodo 1
                    -- Then the todo will be not be complete
                    |> ensureTodoActive 1
                    |> done
        ]
