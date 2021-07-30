module Todo exposing (Todo, buildTodo, decode, encode)

import Json.Decode as Decode exposing (Decoder, bool, int, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode


type alias Todo =
    { title : String
    , id : Int
    , complete : Bool
    , editing : Bool
    }


{-| Creates the todo with default values
-}
buildTodo : Todo
buildTodo =
    { title = ""
    , id = 0
    , complete = False
    , editing = False
    }


decode : Decoder Todo
decode =
    Decode.succeed Todo
        |> required "title" string
        |> required "id" int
        |> required "complete" bool
        |> required "editing" bool


encode : Todo -> Encode.Value
encode todo =
    Encode.object
        [ ( "title", Encode.string todo.title )
        , ( "id", Encode.int todo.id )
        , ( "complete", Encode.bool todo.complete )
        , ( "editing", Encode.bool todo.editing )
        ]
