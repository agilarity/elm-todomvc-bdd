module Common.TestData exposing (TodoListConfig, buildTestModel)

import Model exposing (Model, buildModel)
import Todo exposing (Todo, buildTodo)


type alias TodoListConfig =
    { totalItems : Int
    , completedItems : Int
    }


buildTestModel : TodoListConfig -> Model
buildTestModel todoListConfig =
    let
        testTodos : List Todo
        testTodos =
            buildTestTodos todoListConfig

        numberOfTodos : Int
        numberOfTodos =
            List.length testTodos

        model : Model
        model =
            { buildModel
                | todos = testTodos
                , maxId = numberOfTodos
                , initMessage = "Started with " ++ String.fromInt numberOfTodos ++ " todos"
            }
    in
    model


buildTestTodos : TodoListConfig -> List Todo
buildTestTodos todoListConfig =
    let
        todoIds : List Int
        todoIds =
            List.range 1 todoListConfig.totalItems

        totalTodos : List Todo
        totalTodos =
            List.map
                (\id ->
                    { buildTodo
                        | id = id
                        , complete = False
                        , title = "Todo " ++ String.fromInt id
                    }
                )
                todoIds

        testTodos : List Todo
        testTodos =
            completeTestTodos todoListConfig.completedItems totalTodos
    in
    testTodos


completeTestTodos : Int -> List Todo -> List Todo
completeTestTodos maxId todos =
    let
        markComplete : Int -> Todo -> Todo
        markComplete id todo =
            if todo.id <= id then
                { todo | complete = True }

            else
                todo
    in
    List.map (\todo -> markComplete maxId todo) todos
