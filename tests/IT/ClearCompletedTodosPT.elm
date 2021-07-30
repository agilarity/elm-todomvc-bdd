module IT.ClearCompletedTodosPT exposing (all)

import Common.TestData exposing (buildTestModel)
import Html.Attributes exposing (hidden)
import IT.App.Action exposing (clearCompletedTodos, startAppWith)
import IT.App.Result exposing (ensureTodoNotPresent)
import ProgramTest exposing (done, ensureViewHas, within)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id)


all : Test
all =
    describe "GOAL-14: Clear Completed Todos"
        [ test "RULE-14.1: Should not see the clear completed action" <|
            \() ->
                -- Given the todos are all active
                buildTestModel
                    { totalItems = 5
                    , completedItems = 0
                    }
                    -- When the home page is viewed
                    |> startAppWith
                    -- Then the clear completed action will be hidden
                    |> within
                        (Query.find
                            [ id "clear-completed" ]
                        )
                        (ensureViewHas [ attribute (hidden True) ])
                    |> done
        , test "RULE-14.2: Should not see the completed todos" <|
            \() ->
                -- Given the completed todos
                buildTestModel
                    { totalItems = 3
                    , completedItems = 3
                    }
                    -- When the home page is viewed
                    |> startAppWith
                    -- When the clear completed action is clicked
                    |> clearCompletedTodos
                    -- Then the completed todos will not be visible
                    |> ensureTodoNotPresent 1
                    |> ensureTodoNotPresent 2
                    |> ensureTodoNotPresent 3
                    |> done
        ]
