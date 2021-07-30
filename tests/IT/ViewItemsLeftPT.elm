module IT.ViewItemsLeftPT exposing (all)

import Common.TestData exposing (buildTestModel)
import IT.App.Action exposing (startAppWith)
import IT.App.Result exposing (ensureItemsLeft)
import Model exposing (Model)
import ProgramTest exposing (done, ensureViewHas, expectViewHas, within)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (checked, class, tag, text)
import Test.Table exposing (testTable)


all : Test
all =
    describe "GOAL-15: View Items Left"
        [ testTable "RULE-15.1: Should see the number of items left" [ 0, 1, 2, 3, 4, 5 ] <|
            \activeTodos ->
                -- Given the number of active todos
                setupModel activeTodos
                    -- When the home page is viewed
                    |> startAppWith
                    -- Then the number of item left will match the number of active todos
                    |> ensureItemsLeft activeTodos
                    |> done
        , testTable "RULE-15.2: Should see the plural form of the items left label" [ 0, 2, 3, 4, 5 ] <|
            \activeTodos ->
                -- Given the number of items left is not 1
                setupModel activeTodos
                    -- When the home page is viewed
                    |> startAppWith
                    -- Then the label will be "items left"
                    |> expectViewHas
                        [ class "todo-count"
                        , text "items left"
                        ]
        , test "RULE-15.3: Should see the singular form of the items left label" <|
            \() ->
                -- Given there is 1 item left
                setupModel 1
                    -- When the home page is viewed
                    |> startAppWith
                    -- Then the label will be "item left"
                    |> expectViewHas
                        [ class "todo-count"
                        , text "item left"
                        ]
        , test "RULE-15.4: Should wrap the items left count with strong element" <|
            \() ->
                -- Given the items left count is visible
                setupModel 1
                    |> startAppWith
                    -- Then the count will be in a strong element
                    |> expectViewHas
                        [ class "todo-count"
                        , tag "strong"
                        ]
        , test "RULE-15.5: Should see all the todos are complete" <|
            \() ->
                -- Given the number of items left is 0
                setupModel 0
                    -- When the home page is viewed
                    |> startAppWith
                    -- Then the complete all todos action will be checked
                    |> within
                        (Query.find [ class "toggle-all" ])
                        (ensureViewHas [ checked True ])
                    |> done
        , testTable "RULE-15.6: Should see some of the todos are not complete" [ 1, 2, 3, 4, 5 ] <|
            \activeTodos ->
                -- Given the number of items left is not 0
                setupModel activeTodos
                    -- When the home page is viewed
                    |> startAppWith
                    -- Then the complete all todos action will not be checked
                    |> within
                        (Query.find [ class "toggle-all" ])
                        (ensureViewHas [ checked False ])
                    |> done
        ]


setupModel : Int -> Model
setupModel activeTodos =
    let
        totalTodos : number
        totalTodos =
            10

        completedTodos : Int
        completedTodos =
            totalTodos - activeTodos
    in
    buildTestModel
        { totalItems = totalTodos
        , completedItems = completedTodos
        }
