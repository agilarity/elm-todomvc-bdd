module Unit.ChangeUrlTest exposing (update)

import Expect
import Filter exposing (Filter(..))
import Main exposing (Effect(..), Msg(..), handleMsg)
import Model exposing (buildModel)
import Test exposing (Test, describe)
import Test.Table exposing (testTable2)



{-
   Tests are grouped by responsibility into the following suites.

    update - Assure each message updates the model and sends the effect message correctly
    action - Assure each user action sends the correct message
      * Cannot call port function
      * Covered by ChangeBrowserURLPT
    view - Assure the correct markup is generated
      * Covered by ChangeFilterTest
-}


update : Test
update =
    describe "Change URL"
        [ describe "Verify Model"
            [ testTable2 "Should set the filter for a URL" locationHrefToFilterList <|
                \locationHref filter ->
                    -- GIVEN
                    buildModel
                        -- WHEN
                        |> handleMsg (ChangeUrl locationHref)
                        -- THEN
                        |> Tuple.first
                        |> .filter
                        |> Expect.equal filter
            ]
        , describe "Verify Effect"
            [ testTable2 "Should not persist the filter change" locationHrefToFilterList <|
                \locationHref _ ->
                    -- GIVEN
                    buildModel
                        -- WHEN
                        |> handleMsg (ChangeUrl locationHref)
                        -- THEN
                        |> Tuple.second
                        |> Expect.equal IgnoreModelChange
            ]
        ]


locationHrefToFilterList : List ( String, Filter )
locationHrefToFilterList =
    [ ( "http://localhost:300", All )
    , ( "http://localhost:3000/", All )
    , ( "http://localhost:3000/#/active", Active )
    , ( "http://localhost:3000/#/completed", Completed )
    , ( "http://localhost:3000/#!/active", Active )
    , ( "http://localhost:3000/#!/completed", Completed )
    ]
