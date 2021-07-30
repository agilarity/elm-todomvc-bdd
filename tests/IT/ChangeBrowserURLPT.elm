module IT.ChangeBrowserURLPT exposing (all)

import Filter exposing (Filter(..))
import IT.App.Action exposing (startApp)
import IT.App.Result exposing (ensureFilterSelected)
import Json.Encode as Encode
import ProgramTest exposing (done, simulateIncomingPort)
import Test exposing (Test, describe)
import Test.Table exposing (testTable2)


all : Test
all =
    describe "GOAL-19: Change Browser URL"
        [ testTable2 "RULE-19.1: Should select the filter" locationHrefToFilterList <|
            \locationHref filter ->
                -- Given the new URL is <locationHref>
                startApp
                    -- When the URL is changed
                    |> simulateIncomingPort
                        "onUrlChange"
                        (Encode.string locationHref)
                    -- Then the selected filter will be <filter>
                    |> ensureFilterSelected filter
                    |> done
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
