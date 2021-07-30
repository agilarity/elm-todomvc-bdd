module KeyboardEvent exposing (enter, enterKey, escape, escapeKey)

import Json.Encode as Encode exposing (Value)


enterKey : Int
enterKey =
    13


escapeKey : Int
escapeKey =
    27


enter : ( String, Value )
enter =
    keydown enterKey


escape : ( String, Value )
escape =
    keydown escapeKey


keydown : Int -> ( String, Value )
keydown value =
    ( "keydown"
    , Encode.object [ ( "keyCode", Encode.int value ) ]
    )
