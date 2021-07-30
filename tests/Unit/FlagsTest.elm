module Unit.FlagsTest exposing (all)

import Expect
import Filter exposing (Filter(..))
import Flags exposing (buildFlags)
import Json.Decode exposing (decodeValue)
import Json.Encode as Encode
import Model exposing (buildModel)
import Test exposing (Test, describe, test)
import Test.Table exposing (testTable2)
import Todo exposing (buildTodo)


all : Test
all =
    describe "Verify Flags"
        [ describe "Translate Flags"
            [ test "Should decode the flags" <|
                \() ->
                    -- GIVEN
                    [ ( "locationHref", Encode.string buildFlags.locationHref )
                    , ( "model", Model.encode buildModel )
                    ]
                        |> Encode.object
                        -- WHEN
                        |> decodeValue Flags.decode
                        -- THEN
                        |> Expect.equal (Ok { buildFlags | model = Just buildModel })
            , test "Should encode the flags" <|
                \() ->
                    -- GIVEN
                    { buildFlags | model = Just buildModel }
                        -- WHEN
                        |> Flags.encode
                        -- THEN
                        |> Expect.equal
                            (Encode.object
                                [ ( "locationHref", Encode.string buildFlags.locationHref )
                                , ( "model", Model.encode buildModel )
                                ]
                            )
            ]
        , describe "Load Model"
            [ test "Should load the existing model" <|
                \() ->
                    let
                        model : Model.Model
                        model =
                            { buildModel
                                | todos = [ buildTodo, buildTodo ]
                                , maxId = 24
                            }

                        flags : Flags.Flags
                        flags =
                            { buildFlags | model = Just model }
                    in
                    -- GIVEN
                    flags
                        |> Flags.encode
                        -- WHEN
                        |> Flags.loadModel
                        -- THEN
                        |> Expect.equal
                            { model | initMessage = "Started with 2 todos" }
            , test "Should load the new model" <|
                \() ->
                    -- GIVEN
                    buildFlags
                        |> Flags.encode
                        -- WHEN
                        |> Flags.loadModel
                        -- THEN
                        |> Expect.equal
                            { buildModel | initMessage = "Started with 0 todos" }
            , test "Should recover from an invalid model" <|
                \() ->
                    let
                        expectedMessage : String
                        expectedMessage =
                            "Problem with the given value:\n\nnull\n\nExpecting an OBJECT with a field named `locationHref`"
                    in
                    -- GIVEN
                    Encode.null
                        -- WHEN
                        |> Flags.loadModel
                        -- THEN
                        |> Expect.equal
                            { buildModel | initMessage = expectedMessage }
            , testTable2 "Should initialize the filter" locationHrefToFilterList <|
                \locationHref filter ->
                    -- GIVEN
                    { buildFlags | locationHref = locationHref }
                        |> Flags.encode
                        -- WHEN
                        |> Flags.loadModel
                        -- THEN
                        |> Expect.equal
                            { buildModel | initMessage = "Started with 0 todos", filter = filter }
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
