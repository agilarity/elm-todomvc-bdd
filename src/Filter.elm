module Filter exposing (Filter(..), decode, encode, fromLocation, toString)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Url
import Url.Parser exposing (fragment)


type Filter
    = All
    | Active
    | Completed


decode : Decoder Filter
decode =
    Decode.string
        |> Decode.andThen
            (\filter ->
                case filter of
                    "All" ->
                        Decode.succeed All

                    "Active" ->
                        Decode.succeed Active

                    "Completed" ->
                        Decode.succeed Completed

                    notFound ->
                        Decode.fail <| "Invalid Filter: " ++ notFound
            )


encode : Filter -> Encode.Value
encode filter =
    filter
        |> toString
        |> Encode.string


toString : Filter -> String
toString filter =
    case filter of
        All ->
            "All"

        Active ->
            "Active"

        Completed ->
            "Completed"


fromLocation : String -> Filter
fromLocation locationUrl =
    let
        filter : Filter
        filter =
            case Url.fromString locationUrl of
                Just url ->
                    case url.fragment of
                        Just fragment ->
                            fromFragment fragment

                        Nothing ->
                            All

                Nothing ->
                    All
    in
    filter


fromFragment : String -> Filter
fromFragment fragment =
    if String.endsWith "/active" fragment then
        Active

    else if String.endsWith "/completed" fragment then
        Completed

    else
        All
