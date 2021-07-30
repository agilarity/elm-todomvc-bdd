port module Main exposing (Effect(..), Msg(..), handleMsg, initApp, main, view, viewBody)

import Browser
import Browser.Dom as Dom
import Filter exposing (Filter(..))
import Flags
import Html exposing (Attribute, Html, a, button, div, footer, h1, header, input, label, li, p, section, span, strong, text, ul)
import Html.Attributes exposing (autofocus, checked, class, classList, for, hidden, href, id, placeholder, type_, value)
import Html.Events exposing (keyCode, on, onBlur, onClick, onDoubleClick, onInput)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy, lazy3, lazy4)
import ID
import Json.Decode as Decode
import Json.Encode as Encode
import KeyboardEvent exposing (enterKey, escapeKey)
import Model exposing (Model)
import Task
import Todo exposing (Todo)



---- PROGRAM ----


main : Program Decode.Value Model Msg
main =
    Browser.document
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


view : Model -> { title : String, body : List (Html Msg) }
view model =
    { title = "Elm • TodoMVC ~ BDD", body = [ viewBody model ] }


{-| Two phase design supports testing with avh4/elm-program-test
-}
init : Decode.Value -> ( Model, Cmd Msg )
init flags =
    initApp flags
        |> Tuple.mapSecond handleEffect


{-| Two phase design supports testing with avh4/elm-program-test
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    handleMsg msg model
        |> Tuple.mapSecond handleEffect


subscriptions : Model -> Sub Msg
subscriptions _ =
    onUrlChange ChangeUrl



---- PORTS ----


port setStorage : Encode.Value -> Cmd msg


port onUrlChange : (String -> msg) -> Sub msg



---- MODEL ----


{-| Supports testing with avh4/elm-program-test
-}
initApp : Decode.Value -> ( Model, Effect )
initApp flags =
    Flags.loadModel flags
        |> withSaveModelEffect


type Effect
    = NoEffect
    | IgnoreModelChange
    | SaveModel Model
    | FocusElement String



---- UPDATE ----


type Msg
    = NoOp
    | AddTodo
    | ChangeFilter Filter
    | ChangeTitle Int
    | ClearCompletedTodos
    | DeleteTodo Int
    | EditTodo Todo
    | ToggleAllComplete
    | ToggleComplete Int
    | UpdateNewTodo String
    | UpdateTodo Int String
    | ChangeUrl String


{-| Supports testing with avh4/elm-program-test
-}
handleMsg : Msg -> Model -> ( Model, Effect )
handleMsg msg model =
    case msg of
        NoOp ->
            model
                |> withNoEffect

        AddTodo ->
            if String.isEmpty (String.trim model.newTodoTitle) then
                model
                    |> withNoEffect

            else
                Model.addNewTodo model
                    |> withSaveModelEffect

        ChangeFilter filter ->
            Model.changeFilter filter model
                |> withEffect IgnoreModelChange

        ChangeUrl locationHref ->
            Model.changeFilter (Filter.fromLocation locationHref) model
                |> withEffect IgnoreModelChange

        ChangeTitle id ->
            Model.setEditingMode id False model
                |> withSaveModelEffect

        ClearCompletedTodos ->
            Model.deleteCompleted model
                |> withSaveModelEffect

        DeleteTodo id ->
            Model.deleteTodo id model
                |> withSaveModelEffect

        EditTodo todo ->
            if todo.complete == True then
                model
                    |> withNoEffect

            else
                Model.setEditingMode todo.id True model
                    |> withEffect (FocusElement (ID.buildEditInputId todo.id))

        ToggleAllComplete ->
            Model.toggleAllTodosComplete model
                |> withSaveModelEffect

        ToggleComplete id ->
            Model.toggleTodoComplete id model
                |> withSaveModelEffect

        UpdateNewTodo todo ->
            Model.updateNewTodo todo model
                |> withEffect IgnoreModelChange

        UpdateTodo id todo ->
            Model.updateTodo id todo model
                |> withEffect IgnoreModelChange


handleEffect : Effect -> Cmd Msg
handleEffect effect =
    case effect of
        NoEffect ->
            Cmd.none

        FocusElement id ->
            Task.attempt (\_ -> NoOp) (Dom.focus id)

        IgnoreModelChange ->
            Cmd.none

        SaveModel model ->
            Cmd.batch [ setStorage (Model.encode model), Cmd.none ]



---- VIEW ----


viewBody : Model -> Html Msg
viewBody model =
    let
        activeTodos : List { title : String, id : Int, complete : Bool, editing : Bool }
        activeTodos =
            List.filter (\todo -> todo.complete == False) model.todos

        completedTodos : List { title : String, id : Int, complete : Bool, editing : Bool }
        completedTodos =
            List.filter (\todo -> todo.complete == True) model.todos

        visibleTodos : List { title : String, id : Int, complete : Bool, editing : Bool }
        visibleTodos =
            case model.filter of
                Active ->
                    activeTodos

                Completed ->
                    completedTodos

                _ ->
                    model.todos

        itemsLeft : Int
        itemsLeft =
            List.length activeTodos

        hideClearCompletedButton : Bool
        hideClearCompletedButton =
            List.isEmpty completedTodos

        hideFooter : Bool
        hideFooter =
            List.isEmpty model.todos

        areAllTodosComplete : Bool
        areAllTodosComplete =
            List.isEmpty activeTodos
    in
    span []
        [ section [ class "todoapp" ]
            [ lazy viewNewTodoInput model.newTodoTitle
            , lazy3 viewTodoList visibleTodos hideFooter areAllTodosComplete
            , lazy4 viewLisFooter
                model.filter
                itemsLeft
                hideFooter
                hideClearCompletedButton
            ]
        , viewAppInfo
        ]


viewNewTodoInput : String -> Html Msg
viewNewTodoInput newTodoTitle =
    header [ class "header" ]
        [ h1 [] [ text "todos" ]
        , label [ for "new-todo", hidden True ] [ text "New Todo" ]
        , input
            [ id "new-todo"
            , class "new-todo"
            , placeholder "What needs to be done?"
            , autofocus True
            , onInput UpdateNewTodo
            , onNewTodoKeyDown AddTodo
            , onBlur AddTodo
            , value newTodoTitle
            ]
            []
        ]


viewTodoList : List Todo -> Bool -> Bool -> Html Msg
viewTodoList visibleTodos hideFooter areAllTodosComplete =
    section
        [ class "main"
        , hidden hideFooter
        ]
        [ input
            [ id "toggle-all"
            , class "toggle-all"
            , type_ "checkbox"
            , onClick ToggleAllComplete
            , checked areAllTodosComplete
            ]
            []
        , label [ for "toggle-all" ]
            [ text "Mark all as complete" ]
        , Keyed.ul [ class "todo-list" ] <|
            List.map viewKeyedTodo visibleTodos
        ]


viewLisFooter : Filter -> Int -> Bool -> Bool -> Html Msg
viewLisFooter filter itemsLeft hideFooter hideClearCompletedButton =
    footer
        [ id "list-footer"
        , class "footer"
        , hidden hideFooter
        ]
        [ lazy viewItemsLeft itemsLeft
        , lazy viewListFilter filter
        , lazy viewClearCompleted hideClearCompletedButton
        ]


viewAppInfo : Html Msg
viewAppInfo =
    footer [ class "info" ]
        [ p [] [ text "Double-click to edit a todo" ]
        , p []
            [ text "Created by "
            , a [ href "http://agilarity.com" ] [ text "Joseph Cruz" ]
            , text " with "
            , a [ href "https://dannorth.net/introducing-bdd/" ] [ text "BDD" ]
            ]
        , p []
            [ text "Part of "
            , a [ href "http://todomvc.com" ] [ text "TodoMVC" ]
            ]
        ]


viewItemsLeft : Int -> Html Msg
viewItemsLeft itemsLeft =
    let
        itemsLeftLabel : String
        itemsLeftLabel =
            if itemsLeft /= 1 then
                " items left"

            else
                " item left"
    in
    span [ class "todo-count" ]
        [ strong []
            [ text (String.fromInt itemsLeft) ]
        , text itemsLeftLabel
        ]


viewListFilter : Filter -> Html Msg
viewListFilter currentFilter =
    ul [ class "filters" ]
        [ viewTodoLink All currentFilter
        , viewTodoLink Active currentFilter
        , viewTodoLink Completed currentFilter
        ]


viewTodoLink : Filter -> Filter -> Html Msg
viewTodoLink filter currentFilter =
    let
        filterName : String
        filterName =
            Filter.toString filter

        path : String
        path =
            if filterName == "All" then
                ""

            else
                String.toLower filterName
    in
    li
        [ id (ID.buildFilterId filter)
        , onClick (ChangeFilter filter)
        ]
        [ a
            [ id (ID.buildFilterlinkId filter)
            , classList [ ( "selected", filter == currentFilter ) ]
            , href ("#/" ++ path)
            ]
            [ text filterName ]
        ]


viewClearCompleted : Bool -> Html Msg
viewClearCompleted hideClearCompletedButton =
    button
        [ id "clear-completed"
        , class "clear-completed"
        , hidden hideClearCompletedButton
        , onClick ClearCompletedTodos
        ]
        [ text "Clear completed" ]



---- KEYED UL SUPPORT ----


viewKeyedTodo : Todo -> ( String, Html Msg )
viewKeyedTodo todo =
    ( String.fromInt todo.id, viewTodoItem todo )


viewTodoItem : Todo -> Html Msg
viewTodoItem todo =
    li
        [ id (ID.buildItemId todo.id)
        , classList [ ( "completed", todo.complete ), ( "editing", todo.editing ) ]
        ]
        [ div [ class "view" ]
            [ input
                [ class "toggle"
                , type_ "checkbox"
                , checked todo.complete
                , id (ID.buildItemCheckId todo.id)
                , onClick (ToggleComplete todo.id)
                ]
                []
            , label
                [ id (ID.buildItemLabelId todo.id)
                , onDoubleClick (EditTodo todo)
                ]
                [ text todo.title ]
            , button
                [ class "destroy"
                , id (ID.buildDeleteButtonId todo.id)
                , onClick (DeleteTodo todo.id)
                ]
                []
            ]
        , label [ for (ID.buildEditInputId todo.id) ] [ text "" ]
        , input
            [ class "edit"
            , value todo.title
            , id (ID.buildEditInputId todo.id)
            , onInput (UpdateTodo todo.id)
            , onTodoKeyDown (changeTitleOrDelete todo.id (String.trim todo.title))
            , onBlur (changeTitleOrDelete todo.id (String.trim todo.title))
            ]
            []
        ]


changeTitleOrDelete : Int -> String -> Msg
changeTitleOrDelete id title =
    if title == "" then
        DeleteTodo id

    else
        ChangeTitle id



---- CUSTOM HANDLERS ----


onNewTodoKeyDown : Msg -> Attribute Msg
onNewTodoKeyDown msg =
    sendMsgOnKey [ enterKey ] msg


onTodoKeyDown : Msg -> Attribute Msg
onTodoKeyDown msg =
    sendMsgOnKey [ enterKey, escapeKey ] msg


sendMsgOnKey : List Int -> Msg -> Attribute Msg
sendMsgOnKey keys msg =
    let
        sendMsg : Int -> Decode.Decoder Msg
        sendMsg code =
            if List.member code keys then
                Decode.succeed msg

            else
                Decode.fail "Quietly ignore other key presses"
    in
    on "keydown" (Decode.andThen sendMsg keyCode)



-- EFFECT SUGAR inspired by the Janiczek/cmd-extra package


withNoEffect : Model -> ( Model, Effect )
withNoEffect model =
    ( model, NoEffect )


withSaveModelEffect : Model -> ( Model, Effect )
withSaveModelEffect model =
    ( model, SaveModel model )


withEffect : Effect -> Model -> ( Model, Effect )
withEffect effect model =
    ( model, effect )
