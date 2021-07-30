module IT.ToggleAllTodosCompletePT exposing (all)

import Common.TestData exposing (buildTestModel)
import IT.App.Action exposing (completeAllTodos, startAppWith)
import IT.App.Result exposing (ensureTodoActive, ensureTodoCompleted)
import ProgramTest exposing (done)
import Test exposing (Test, describe, test)


all : Test
all =
    describe "GOAL-13: Toggle All Todos Complete"
        [ test "RULE-13.1: Should mark the todos complete" <|
            \() ->
                -- Given the todo list has an active todo
                buildTestModel { totalItems = 3, completedItems = 2 }
                    |> startAppWith
                    -- When the complete all todo action is clicked
                    |> completeAllTodos
                    -- Then all the todos will be marked complete
                    |> ensureTodoCompleted 1
                    |> ensureTodoCompleted 2
                    |> ensureTodoCompleted 3
                    |> done
        , test
            "RULE-13.2: Should mark the todos active"
          <|
            \() ->
                -- Given all the todos are marked complete
                buildTestModel { totalItems = 3, completedItems = 3 }
                    |> startAppWith
                    -- When the complete all todo action is clicked
                    |> completeAllTodos
                    -- Then all the todos will be marked active
                    |> ensureTodoActive 1
                    |> ensureTodoActive 2
                    |> ensureTodoActive 3
                    |> done
        ]
