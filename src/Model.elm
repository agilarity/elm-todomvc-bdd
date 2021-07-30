module Model exposing (Model, addNewTodo, buildModel, changeFilter, decode, deleteCompleted, deleteTodo, encode, setEditingMode, toggleAllTodosComplete, toggleTodoComplete, updateNewTodo, updateTodo)

import Filter exposing (Filter(..))
import Html.Attributes exposing (id)
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode
import Todo exposing (Todo, buildTodo)


type alias Model =
    { newTodoTitle : String
    , todos : List Todo
    , maxId : Int
    , filter : Filter
    , initMessage : String
    }


{-| Creates the model with default values
-}
buildModel : Model
buildModel =
    { newTodoTitle = ""
    , todos = []
    , maxId = 0
    , filter = All
    , initMessage = ""
    }


decode : Decoder Model
decode =
    Decode.succeed Model
        |> optional "newTodo" string ""
        |> optional "todos" (list Todo.decode) []
        |> required "maxId" int
        |> required "filter" Filter.decode
        |> required "initMessage" string


encode : Model -> Encode.Value
encode model =
    Encode.object
        [ ( "newTodo", Encode.string model.newTodoTitle )
        , ( "todos", Encode.list Todo.encode model.todos )
        , ( "maxId", Encode.int model.maxId )
        , ( "filter", Filter.encode model.filter )
        , ( "initMessage", Encode.string model.initMessage )
        ]



-- MODEL UPDATES


addNewTodo : Model -> Model
addNewTodo model =
    let
        nextId : Int
        nextId =
            model.maxId + 1

        newTodo : Todo
        newTodo =
            { buildTodo | title = String.trim model.newTodoTitle, id = nextId }
    in
    { model
        | maxId = nextId
        , todos = model.todos ++ [ newTodo ]
        , newTodoTitle = ""
    }


changeFilter : Filter -> Model -> Model
changeFilter filter model =
    { model | filter = filter }


deleteCompleted : Model -> Model
deleteCompleted model =
    { model | todos = List.filter (\todo -> todo.complete == False) model.todos }


deleteTodo : Int -> Model -> Model
deleteTodo id model =
    { model | todos = List.filter (\todo -> todo.id /= id) model.todos }


toggleTodoComplete : Int -> Model -> Model
toggleTodoComplete id model =
    { model | todos = List.map (\todo -> toggleCompleteStatusById id todo) model.todos }


toggleCompleteStatusById : Int -> Todo -> Todo
toggleCompleteStatusById id todo =
    if todo.id == id then
        { todo | complete = not todo.complete }

    else
        todo


toggleAllTodosComplete : Model -> Model
toggleAllTodosComplete model =
    { model | todos = toggleCompleteAll model.todos }


toggleCompleteAll : List Todo -> List Todo
toggleCompleteAll todos =
    let
        awaitingCompletion : List { title : String, id : Int, complete : Bool, editing : Bool }
        awaitingCompletion =
            List.filter (\todo -> todo.complete == False) todos

        checkState : Bool
        checkState =
            if List.isEmpty awaitingCompletion then
                False

            else
                True
    in
    List.map (\todo -> { todo | complete = checkState }) todos


updateNewTodo : String -> Model -> Model
updateNewTodo title model =
    { model | newTodoTitle = title }


setEditingMode : Int -> Bool -> Model -> Model
setEditingMode id isEditing model =
    { model | todos = List.map (\todo -> setEditingModeById id isEditing todo) model.todos }


setEditingModeById : Int -> Bool -> Todo -> Todo
setEditingModeById id isEditing todo =
    if todo.id == id then
        { todo | editing = isEditing }

    else
        todo


updateTodo : Int -> String -> Model -> Model
updateTodo id title model =
    { model | todos = List.map (\todo -> updateTodoById id title todo) model.todos }


updateTodoById : Int -> String -> Todo -> Todo
updateTodoById id title todo =
    if todo.id == id then
        { todo | title = title }

    else
        todo
