module Unit.ModelTest exposing (all)

import Expect
import Filter exposing (Filter(..))
import Json.Decode exposing (decodeValue)
import Json.Encode as Encode
import Model exposing (buildModel)
import Test exposing (Test, describe, test)
import Todo exposing (buildTodo)


all : Test
all =
    describe "Verify Model"
        [ test "Should decode model" <|
            \() ->
                let
                    model : Model.Model
                    model =
                        { buildModel
                            | newTodoTitle = "Verify decoding"
                            , todos =
                                [ { buildTodo | title = "d1", id = 1 }
                                , { buildTodo | title = "d2", id = 2 }
                                , { buildTodo | title = "d3", id = 3 }
                                ]
                            , maxId = 89
                            , filter = All
                        }
                in
                -- GIVEN
                [ ( "newTodo", Encode.string model.newTodoTitle )
                , ( "todos", Encode.list Todo.encode model.todos )
                , ( "maxId", Encode.int model.maxId )
                , ( "filter", Filter.encode model.filter )
                , ( "initMessage", Encode.string model.initMessage )
                ]
                    |> Encode.object
                    -- WHEN
                    |> decodeValue Model.decode
                    -- THEN
                    |> Expect.equal (Ok model)
        , test "Should encode the model" <|
            \() ->
                let
                    model : Model.Model
                    model =
                        { buildModel
                            | newTodoTitle = "Verify encoding"
                            , todos =
                                [ { buildTodo | title = "d1", id = 1 }
                                , { buildTodo | title = "d2", id = 2 }
                                , { buildTodo | title = "d3", id = 3 }
                                ]
                            , maxId = 75
                            , filter = Active
                        }
                in
                -- GIVEN
                model
                    -- WHEN
                    |> Model.encode
                    -- THEN
                    |> Expect.equal
                        (Encode.object
                            [ ( "newTodo", Encode.string model.newTodoTitle )
                            , ( "todos", Encode.list Todo.encode model.todos )
                            , ( "maxId", Encode.int model.maxId )
                            , ( "filter", Filter.encode model.filter )
                            , ( "initMessage", Encode.string model.initMessage )
                            ]
                        )
        ]
