module Flags exposing (Flags, buildFlags, decode, encode, loadModel)

import Filter
import Json.Decode as Decode exposing (Decoder, decodeValue, errorToString, string)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode
import Model exposing (Model, buildModel)


type alias Flags =
    { locationHref : String
    , model : Maybe Model
    }


buildFlags : Flags
buildFlags =
    { locationHref = ""
    , model = Nothing
    }


decode : Decoder Flags
decode =
    Decode.succeed Flags
        |> required "locationHref" string
        |> optional "model" (Decode.nullable Model.decode) (Just buildModel)


encode : Flags -> Encode.Value
encode flags =
    Encode.object
        [ ( "locationHref", Encode.string flags.locationHref )
        , ( "model"
          , flags.model
                |> Maybe.map Model.encode
                |> Maybe.withDefault Encode.null
          )
        ]


loadModel : Decode.Value -> Model
loadModel value =
    let
        buildMessage : Int -> String
        buildMessage items =
            "Started with " ++ String.fromInt items ++ " todos"

        model : Model
        model =
            case decodeValue decode value of
                Ok flags ->
                    let
                        startingModel : Model
                        startingModel =
                            case flags.model of
                                Just decodedModel ->
                                    decodedModel

                                Nothing ->
                                    buildModel
                    in
                    { startingModel | initMessage = buildMessage (List.length startingModel.todos), filter = Filter.fromLocation flags.locationHref }

                Err error ->
                    { buildModel | initMessage = errorToString error }
    in
    model
