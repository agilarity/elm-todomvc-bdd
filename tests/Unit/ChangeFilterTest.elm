module Unit.ChangeFilterTest exposing (action, update, view)

import Expect
import Filter exposing (Filter(..))
import ID
import Main exposing (Effect(..), Msg(..), handleMsg, viewBody)
import Model exposing (buildModel)
import Test exposing (Test, describe)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (class, id, tag, text)
import Test.Table exposing (testTable)



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
            [ testTable "Should update the filter" filterList <|
                \filter ->
                    -- GIVEN
                    buildModel
                        -- WHEN
                        |> handleMsg (ChangeFilter filter)
                        -- THEN
                        |> Tuple.first
                        |> .filter
                        |> Expect.equal filter
            ]
        , describe "Verify Effect"
            [ testTable "Should not save the updated model" filterList <|
                \filter ->
                    -- GIVEN
                    buildModel
                        -- WHEN
                        |> handleMsg (ChangeFilter filter)
                        -- THEN
                        |> Tuple.second
                        |> Expect.equal IgnoreModelChange
            ]
        ]


action : Test
action =
    describe "Verify Action"
        [ testTable "Should send the change filter message" filterList <|
            \filter ->
                buildModel
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildFilterId filter) ]
                    |> Event.simulate Event.click
                    |> Event.expect (ChangeFilter filter)
        ]


view : Test
view =
    describe "Verify View"
        [ testTable "Should see the selected filter" filterList <|
            \filter ->
                -- GIVEN
                { buildModel | filter = filter }
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.find
                        [ tag "ul"
                        , class "filters"
                        ]
                    |> Query.find
                        [ tag "a"
                        , class "selected"
                        ]
                    |> Query.has
                        [ text (Filter.toString filter)
                        ]
        ]


filterList : List Filter
filterList =
    [ All, Active, Completed ]
