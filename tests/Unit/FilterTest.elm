module Unit.FilterTest exposing (all)

import Expect
import Filter exposing (Filter(..), fromLocation)
import Json.Decode exposing (decodeValue)
import Json.Encode as Encode
import Test exposing (Test, describe)
import Test.Table exposing (testTable, testTable2)


all : Test
all =
    describe "Verify Filter"
        [ testTable "Should decode the filter" filterList <|
            \filter ->
                -- GIVEN
                Filter.toString filter
                    |> Encode.string
                    -- WHEN
                    |> decodeValue Filter.decode
                    -- THEN
                    |> Expect.equal (Ok filter)
        , testTable "should encode the filter" filterList <|
            \filter ->
                -- GIVEN
                filter
                    -- WHEN
                    |> Filter.encode
                    -- THEN
                    |> Expect.equal (Encode.string (Filter.toString filter))
        , describe "From Location"
            [ testTable2 "Should select the filter for a URL" locationHrefToFilterList <|
                \locationHref filter ->
                    locationHref
                        |> fromLocation
                        |> Expect.equal filter
            ]
        ]


filterList : List Filter
filterList =
    [ All, Active, Completed ]


locationHrefToFilterList : List ( String, Filter )
locationHrefToFilterList =
    [ ( "http://localhost:300", All )
    , ( "http://localhost:3000/", All )
    , ( "http://localhost:3000/#/active", Active )
    , ( "http://localhost:3000/#/completed", Completed )
    , ( "http://localhost:3000/#!/active", Active )
    , ( "http://localhost:3000/#!/completed", Completed )
    ]
