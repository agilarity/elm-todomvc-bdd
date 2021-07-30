module Unit.ClearCompletedTest exposing (action, update, view)

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
        [ test "Should remove the completed todos" <|
            \() ->
                let
                    model : Model.Model
                    model =
                        buildTestModel { totalItems = 8, completedItems = 8 }

                    expectedModel : Model.Model
                    expectedModel =
                        { buildModel | todos = [], initMessage = "Started with 8 todos", maxId = 8 }
                in
                -- GIVEN
                model
                    -- WHEN
                    |> handleMsg ClearCompletedTodos
                    -- THEN
                    |> Expect.equal ( expectedModel, SaveModel expectedModel )
        ]


action : Test
action =
    describe "Verify Action"
        [ test "Should send the clear completed todos message" <|
            \() ->
                buildModel
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id "clear-completed" ]
                    |> Event.simulate Event.click
                    |> Event.expect ClearCompletedTodos
        ]


view : Test
view =
    describe "Verify View"
        [ test "Should see the active todos" <|
            \() ->
                -- GIVEN
                buildTestModel { totalItems = 12, completedItems = 0 }
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.findAll
                        [ class "todo-list"
                        , tag "li"
                        ]
                    |> Query.count (Expect.equal 12)
        ]
