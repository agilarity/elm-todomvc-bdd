module Unit.ToggleAllCompleteTest exposing (action, update, view)

import Common.TestData exposing (buildTestModel)
import Expect
import Main exposing (Effect(..), Msg(..), handleMsg, viewBody)
import Model exposing (buildModel)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (class, id, tag)



{-
   Tests are grouped by responsibility into the following suites.

    update - Assure each message updates the model and sends the effect message correctly
    action - Assure each user action sends the correct message
    view - Assure the correct markup is generated
-}


update : Test
update =
    describe "Verify Update"
        [ describe "Verify Model"
            [ test "Should complete the active todos" <|
                \() ->
                    -- GIVEN
                    modelWithSomeCompleted
                        -- WHEN
                        |> handleMsg ToggleAllComplete
                        -- THEN
                        |> Tuple.first
                        |> Expect.equal
                            modelWithAllCompleted
            , test "Should activate the completed todos" <|
                \() ->
                    -- GIVEN
                    modelWithAllCompleted
                        -- WHEN
                        |> Model.toggleAllTodosComplete
                        -- THEN
                        |> Expect.equal
                            modelWithNoneCompleted
            ]
        , describe "Verify Effects"
            [ test "Should save the complete status toggle" <|
                \() ->
                    -- GIVEN
                    buildModel
                        -- WHEN
                        |> handleMsg ToggleAllComplete
                        -- THEN
                        |> Tuple.second
                        |> Expect.equal (SaveModel buildModel)
            ]
        ]


action : Test
action =
    describe "Verify Action"
        [ test "Should send the toggle all complete message" <|
            \() ->
                buildModel
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id "toggle-all" ]
                    |> Event.simulate Event.click
                    |> Event.expect ToggleAllComplete
        ]


view : Test
view =
    describe "Verify View"
        [ test "Should all the completed todos" <|
            \() ->
                -- GIVEN
                modelWithAllCompleted
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.findAll
                        [ class "todo-list"
                        , tag "li"
                        ]
                    |> Query.count (Expect.equal totalItems)
        , test "Should see all the active todos" <|
            \() ->
                -- GIVEN
                modelWithNoneCompleted
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.findAll
                        [ class "todo-list"
                        , tag "li"
                        ]
                    |> Query.count (Expect.equal totalItems)
        ]


totalItems : number
totalItems =
    10


modelWithSomeCompleted : Model.Model
modelWithSomeCompleted =
    buildTestModel { totalItems = totalItems, completedItems = 4 }


modelWithAllCompleted : Model.Model
modelWithAllCompleted =
    buildTestModel { totalItems = totalItems, completedItems = totalItems }


modelWithNoneCompleted : Model.Model
modelWithNoneCompleted =
    buildTestModel { totalItems = totalItems, completedItems = 0 }
