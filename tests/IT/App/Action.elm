module IT.App.Action exposing (addNewTodo, blurNewTodo, blurTodo, cancelChange, clearCompletedTodos, completeAllTodos, completeTodo, deleteTodo, enableTodoEditing, enterNewTodo, enterTodo, fillInNewTodo, fillInTodo, showActiveTodos, showAllTodos, showCompletedTodos, startApp, startAppWith)

import Flags exposing (buildFlags)
import ID
import Json.Decode as Decode
import KeyboardEvent
import Main exposing (Effect(..), Msg(..))
import Model exposing (Model)
import ProgramTest exposing (ProgramTest, fillIn, simulateDomEvent)
import SimulatedEffect.Cmd
import SimulatedEffect.Ports
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (id)


createApp : ProgramTest.ProgramDefinition Decode.Value Model Main.Msg Main.Effect
createApp =
    ProgramTest.createDocument
        { init = Main.initApp
        , update = Main.handleMsg
        , view = Main.view
        }
        |> ProgramTest.withBaseUrl "http://localhost:3000/"
        |> ProgramTest.withSimulatedEffects simulateEffects
        |> ProgramTest.withSimulatedSubscriptions simulateSubscriptions


startApp : ProgramTest Model Main.Msg Main.Effect
startApp =
    let
        encodedFlags : Decode.Value
        encodedFlags =
            buildFlags
                |> Flags.encode
    in
    createApp
        |> ProgramTest.start encodedFlags


startAppWith : Model -> ProgramTest Model Main.Msg Main.Effect
startAppWith model =
    let
        encodedFlags : Decode.Value
        encodedFlags =
            { buildFlags | model = Just model }
                |> Flags.encode
    in
    createApp
        |> ProgramTest.start encodedFlags


simulateEffects : Main.Effect -> ProgramTest.SimulatedEffect Main.Msg
simulateEffects effect =
    case effect of
        NoEffect ->
            SimulatedEffect.Cmd.none

        IgnoreModelChange ->
            SimulatedEffect.Cmd.none

        SaveModel model ->
            SimulatedEffect.Ports.send "setStorage" (Model.encode model)

        FocusElement _ ->
            SimulatedEffect.Cmd.none


simulateSubscriptions : Model -> ProgramTest.SimulatedSub Main.Msg
simulateSubscriptions _ =
    SimulatedEffect.Ports.subscribe "onUrlChange"
        Decode.string
        ChangeUrl


enterNewTodo : ProgramTest model msg effect -> ProgramTest model msg effect
enterNewTodo =
    simulateDomEvent (Query.find [ id "new-todo" ]) KeyboardEvent.enter


completeTodo : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
completeTodo todoId =
    simulateDomEvent (Query.find [ id (ID.buildItemCheckId todoId) ]) Event.click


deleteTodo : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
deleteTodo todoId =
    simulateDomEvent (Query.find [ id (ID.buildDeleteButtonId todoId) ]) Event.click


addNewTodo : String -> ProgramTest model msg effect -> ProgramTest model msg effect
addNewTodo todo context =
    context
        |> fillInNewTodo todo
        |> enterNewTodo


fillInNewTodo : String -> ProgramTest model msg effect -> ProgramTest model msg effect
fillInNewTodo todo context =
    context
        |> fillIn "new-todo" "New Todo" todo


completeAllTodos : ProgramTest model msg effect -> ProgramTest model msg effect
completeAllTodos =
    simulateDomEvent (Query.find [ id "toggle-all" ]) Event.click


clearCompletedTodos : ProgramTest model msg effect -> ProgramTest model msg effect
clearCompletedTodos =
    simulateDomEvent (Query.find [ id "clear-completed" ]) Event.click


showAllTodos : ProgramTest model msg effect -> ProgramTest model msg effect
showAllTodos =
    simulateDomEvent (Query.find [ id "show-all" ]) Event.click


showActiveTodos : ProgramTest model msg effect -> ProgramTest model msg effect
showActiveTodos =
    simulateDomEvent (Query.find [ id "show-active" ]) Event.click


showCompletedTodos : ProgramTest model msg effect -> ProgramTest model msg effect
showCompletedTodos =
    simulateDomEvent (Query.find [ id "show-completed" ]) Event.click


enableTodoEditing : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
enableTodoEditing todoId =
    simulateDomEvent (Query.find [ id (ID.buildItemLabelId todoId) ]) Event.doubleClick


fillInTodo : Int -> String -> ProgramTest model msg effect -> ProgramTest model msg effect
fillInTodo todoId todo context =
    context
        |> fillIn (ID.buildEditInputId todoId) "" todo


blurTodo : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
blurTodo todoId =
    simulateDomEvent (Query.find [ id (ID.buildEditInputId todoId) ]) Event.blur


enterTodo : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
enterTodo todoId =
    simulateDomEvent (Query.find [ id (ID.buildEditInputId todoId) ]) KeyboardEvent.enter


blurNewTodo : ProgramTest model msg effect -> ProgramTest model msg effect
blurNewTodo =
    simulateDomEvent (Query.find [ id "new-todo" ]) Event.blur


cancelChange : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
cancelChange todoId =
    simulateDomEvent (Query.find [ id (ID.buildEditInputId todoId) ]) KeyboardEvent.escape
