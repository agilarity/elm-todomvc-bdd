module Unit.TodoTest exposing (all)

import Expect
import Json.Decode exposing (decodeValue)
import Json.Encode as Encode
import Test exposing (Test, describe, test)
import Todo exposing (buildTodo)


all : Test
all =
    describe "Verify Todo"
        [ test "Should decode the todo" <|
            \() ->
                let
                    todo : Todo.Todo
                    todo =
                        { buildTodo | title = "Verify decoding", id = 7 }
                in
                -- GIVEN
                [ ( "title", Encode.string todo.title )
                , ( "id", Encode.int todo.id )
                , ( "complete", Encode.bool todo.complete )
                , ( "editing", Encode.bool todo.editing )
                ]
                    |> Encode.object
                    -- WHEN
                    |> decodeValue Todo.decode
                    -- THEN
                    |> Expect.equal (Ok todo)
        , test "Should encode the todo" <|
            \() ->
                let
                    todo : Todo.Todo
                    todo =
                        { buildTodo | title = "Verify encoding", id = 3 }
                in
                -- GIVEN
                todo
                    -- WHEN
                    |> Todo.encode
                    -- THEN
                    |> Expect.equal
                        (Encode.object
                            [ ( "title", Encode.string todo.title )
                            , ( "id", Encode.int todo.id )
                            , ( "complete", Encode.bool todo.complete )
                            , ( "editing", Encode.bool todo.editing )
                            ]
                        )
        ]
