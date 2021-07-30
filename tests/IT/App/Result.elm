module IT.App.Result exposing (ensureFilterSelected, ensureItemsLeft, ensureNewTodoValue, ensureTodoActive, ensureTodoCompleted, ensureTodoLabel, ensureTodoNotEditable, ensureTodoNotPresent, ensureTodoPresent, ensureTodoValue)

import Filter exposing (Filter)
import Html.Attributes exposing (checked, value)
import ID
import ProgramTest exposing (ProgramTest, ensureViewHas, ensureViewHasNot, within)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, id, tag, text)


ensureTodoPresent : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureTodoPresent todoId context =
    context
        |> ensureViewHas
            [ id (ID.buildItemId todoId) ]


ensureTodoNotPresent : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureTodoNotPresent todoId context =
    context
        |> ensureViewHasNot
            [ id (ID.buildItemId todoId) ]


ensureTodoLabel : Int -> String -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureTodoLabel todoId expectedValue context =
    context
        |> ensureViewHas
            [ id (ID.buildItemLabelId todoId)
            , text expectedValue
            ]


ensureTodoActive : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureTodoActive todoId context =
    let
        checkId : String
        checkId =
            ID.buildItemCheckId todoId
    in
    context
        |> ensureViewHas
            [ id checkId
            , attribute (checked False)
            ]
        |> ensureViewHasNot
            [ id checkId
            , class "completed"
            ]


ensureItemsLeft : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureItemsLeft expectedCount context =
    context
        |> ensureViewHas
            [ class "todo-count"
            , tag "strong"
            , text (String.fromInt expectedCount)
            ]


ensureTodoCompleted : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureTodoCompleted todoId context =
    context
        |> ensureViewHas
            [ id (ID.buildItemCheckId todoId)
            , attribute (checked True)
            , class "completed"
            ]


ensureFilterSelected : Filter -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureFilterSelected expectedFilter context =
    context
        |> within
            (Query.find
                [ tag "a"
                , class "selected"
                ]
            )
            (ensureViewHas [ text (Filter.toString expectedFilter) ])


ensureNewTodoValue : String -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureNewTodoValue expectedValue context =
    context
        |> ensureViewHas
            [ id "new-todo"
            , attribute (value expectedValue)
            ]


ensureTodoValue : Int -> String -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureTodoValue todoId expectedValue context =
    context
        |> ensureViewHas
            [ id (ID.buildItemId todoId)
            , attribute (value expectedValue)
            ]


ensureTodoNotEditable : Int -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureTodoNotEditable todoId context =
    context
        |> ensureViewHasNot
            [ id (ID.buildItemId todoId)
            , class "editing"
            ]
