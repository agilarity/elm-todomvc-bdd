module Unit.UpdateNewTodoTest exposing (action, update, view)

import Expect
import Fuzz
import Html.Attributes exposing (value)
import Main exposing (Effect(..), Msg(..), handleMsg, viewBody)
import Model exposing (buildModel)
import Test exposing (Test, describe, fuzz, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id)



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
            [ fuzz Fuzz.string "Should update the new todo" <|
                \title ->
                    -- GIVEN
                    buildModel
                        -- WHEN
                        |> handleMsg (UpdateNewTodo title)
                        -- THEN
                        |> Tuple.first
                        |> .newTodoTitle
                        |> Expect.equal title
            ]
        , describe "Verify Effects"
            [ fuzz Fuzz.string "Should ignore the model update" <|
                \title ->
                    -- GIVEN
                    buildModel
                        -- WHEN
                        |> handleMsg (UpdateNewTodo title)
                        -- THEN
                        |> Tuple.second
                        |> Expect.equal IgnoreModelChange
            ]
        ]


action : Test
action =
    describe "Verify Action"
        [ test "Should send the update new todo message" <|
            \() ->
                buildModel
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id "new-todo" ]
                    |> Event.simulate (Event.input "Verify input")
                    |> Event.expect (UpdateNewTodo "Verify input")
        ]


view : Test
view =
    describe "Verify View"
        [ test "Should see the new todo input" <|
            \() ->
                -- GIVEN
                { buildModel | newTodoTitle = "Verify input" }
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.find [ id "new-todo" ]
                    |> Query.has [ attribute (value "Verify input") ]
        ]
