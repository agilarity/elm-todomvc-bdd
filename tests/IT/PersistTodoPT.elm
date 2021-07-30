module IT.PersistTodoPT exposing (all)

import Common.TestData exposing (buildTestModel)
import Expect
import IT.App.Action exposing (addNewTodo, clearCompletedTodos, completeAllTodos, completeTodo, deleteTodo, enterTodo, fillInTodo, startApp, startAppWith)
import IT.App.Result exposing (ensureTodoLabel)
import Model exposing (Model, buildModel)
import ProgramTest exposing (ProgramTest, done, ensureOutgoingPortValues)
import Test exposing (Test, describe, test)
import Todo exposing (Todo, buildTodo)


all : Test
all =
    describe "GOAL-20: Persist Todo"
        [ test "RULE-20.1: Should load the default model" <|
            \() ->
                -- Given there are no todos in local storage
                -- When the todo app is started
                startApp
                    -- Then the default model will be saved
                    |> ensureModelSaved initialModel
                    |> done
        , test "RULE-20.2: Should load the todo data" <|
            \() ->
                let
                    model : Model
                    model =
                        buildTestModel { totalItems = 10, completedItems = 3 }
                in
                -- Given the todos in local storage
                model
                    -- When the todo app is started
                    |> startAppWith
                    -- Then the todos will be loaded from local storage
                    |> ensureModelSaved model
                    |> done
        , test "RULE-20.3: Should add the new todo" <|
            \() ->
                -- Given the todos
                buildModel
                    |> startAppWith
                    |> ensureModelSaved initialModel
                    -- When the todo is added
                    |> addNewTodo "Todo 1"
                    -- Then the todo will be added to local storage
                    |> ensureModelSaved
                        { initialModel
                            | todos = [ { buildTodo | title = "Todo 1", id = 1 } ]
                            , maxId = 1
                        }
                    |> done
        , test "RULE-20.4: Should delete the todo" <|
            \() ->
                -- Given the todo
                modelWithTodo1
                    |> startAppWith
                    |> ensureModelSaved modelWithTodo1
                    -- When the todo is deleted
                    |> deleteTodo 1
                    -- Then the todo will be removed from local storage
                    |> ensureModelSaved
                        { modelWithTodo1
                            | todos = []
                        }
                    |> done
        , test "RULE-20.5: Should update the title of a todo" <|
            \() ->
                -- Given the todo
                modelWithTodo1
                    |> startAppWith
                    |> ensureModelSaved modelWithTodo1
                    -- When the title is changed
                    |> fillInTodo 1 "Verify title change"
                    |> ensureTodoLabel 1 "Verify title change"
                    |> enterTodo 1
                    -- Then the todo will be updated in local storage
                    |> ensureModelSaved
                        { modelWithTodo1
                            | todos =
                                [ { todo1
                                    | title = "Verify title change"
                                  }
                                ]
                        }
                    |> done
        , test "RULE-20.6: Should update the complete status of a todo" <|
            \() ->
                -- Given the todo
                modelWithTodo1
                    |> startAppWith
                    |> ensureModelSaved modelWithTodo1
                    -- When the complete status is changed
                    |> completeTodo 1
                    -- Then the todo will be updated in local storage
                    |> ensureModelSaved
                        { modelWithTodo1
                            | todos =
                                [ { todo1
                                    | complete = True
                                  }
                                ]
                        }
                    |> done
        , test "RULE-20.7: Should update the completed status of all todos" <|
            \() ->
                let
                    model : Model
                    model =
                        buildTestModel { totalItems = 7, completedItems = 0 }
                in
                -- Given the todos
                model
                    |> startAppWith
                    |> ensureModelSaved model
                    -- When the complete status of all todos is changed
                    |> completeAllTodos
                    -- Then the todos will be updated in local storage
                    |> ensureModelSaved (buildTestModel { totalItems = 7, completedItems = 7 })
                    |> done
        , test "RULE-20.8: Should delete the cleared todos" <|
            \() ->
                let
                    model : Model
                    model =
                        buildTestModel { totalItems = 5, completedItems = 5 }
                in
                -- Given the completed todos
                model
                    |> startAppWith
                    |> ensureModelSaved model
                    -- When the clear completed todos action is clicked
                    |> clearCompletedTodos
                    -- Then the todos will be updated in local storage
                    |> ensureModelSaved
                        { model
                            | todos = []
                        }
                    -- THEN
                    |> done
        ]


initialModel : Model
initialModel =
    { buildModel
        | initMessage = "Started with 0 todos"
    }


modelWithTodo1 : Model
modelWithTodo1 =
    { buildModel
        | initMessage = "Started with 1 todos"
        , todos =
            [ todo1
            ]
        , maxId = 1
    }


todo1 : Todo
todo1 =
    { buildTodo | title = "Todo 1", id = 1 }


ensureModelSaved : Model -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureModelSaved model context =
    context
        |> ensureOutgoingPortValues
            "setStorage"
            Model.decode
            (Expect.equal [ model ])
