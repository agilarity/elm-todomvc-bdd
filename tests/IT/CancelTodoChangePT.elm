module IT.CancelTodoChangePT exposing (all)

import IT.App.Action exposing (addNewTodo, cancelChange, enableTodoEditing, fillInNewTodo, startApp, startAppWith)
import IT.App.Result exposing (ensureTodoNotEditable, ensureTodoValue)
import Model exposing (buildModel)
import ProgramTest exposing (done)
import Test exposing (Test, describe, test)
import Todo exposing (buildTodo)


all : Test
all =
    describe "GOAL-10: Cancel Todo Change"
        [ test "RULE-10.1: Should exit the editing mode" <|
            \() ->
                -- Given the todo is editable
                startApp
                    |> addNewTodo "Todo 1"
                    |> enableTodoEditing 1
                    -- When the escape key is pressed
                    |> cancelChange 1
                    -- Then the todo will not be editable
                    |> ensureTodoNotEditable 1
                    |> done
        , test "RULE-10.2: Should restore the original todo" <|
            \() ->
                let
                    todo5 : Todo.Todo
                    todo5 =
                        { buildTodo | title = "Todo 5", id = 5, editing = True }

                    model : Model.Model
                    model =
                        { buildModel | todos = [ todo5 ] }
                in
                -- Given the todo is filled
                model
                    |> startAppWith
                    |> fillInNewTodo "Verify change is cancelled"
                    -- When the escape key is pressed
                    |> cancelChange todo5.id
                    -- Then the original todo will be visible
                    |> ensureTodoValue todo5.id todo5.title
                    |> done
        ]
