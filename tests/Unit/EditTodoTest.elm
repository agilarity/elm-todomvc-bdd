module Unit.EditTodoTest exposing (action, update, view)

import Expect
import ID
import Main exposing (Effect(..), Msg(..), handleMsg, viewBody)
import Model exposing (Model, buildModel)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (class, id)
import Todo exposing (Todo, buildTodo)



{-
   Tests are grouped by responsibility into the following suites.

    update - Assure each message updates the model and sends the effect message correctly
    action - Assure each user action sends the correct message
    view - Assure the correct markup is generated
-}


update : Test
update =
    describe "Verify Update"
        [ describe "Verify Model"
            [ test "Should make the todo editable" <|
                \() ->
                    -- GIVEN
                    modelWithTodo5
                        -- WHEN
                        |> handleMsg (EditTodo todo5)
                        -- THEN
                        |> Tuple.first
                        |> Expect.equal modelWithEditableTodo5
            , test "Should not make the completed todo editable" <|
                \() ->
                    -- GIVEN
                    modelWithCompletedTodo8
                        -- WHEN
                        |> handleMsg (EditTodo todo8)
                        -- THEN
                        |> Tuple.first
                        |> Expect.equal modelWithCompletedTodo8
            ]
        , describe "Verify Effects"
            [ test "Should set the focus on the editable todo" <|
                \() ->
                    -- GIVEN
                    modelWithTodo5
                        -- WHEN
                        |> handleMsg (EditTodo todo5)
                        -- THEN
                        |> Tuple.second
                        |> Expect.equal (FocusElement "edit-todo-5")
            , test "Should not have an affect" <|
                \() ->
                    -- GIVEN
                    modelWithCompletedTodo8
                        -- WHEN
                        |> handleMsg (EditTodo todo8)
                        -- THEN
                        |> Tuple.second
                        |> Expect.equal NoEffect
            ]
        ]


action : Test
action =
    describe "Verify Action"
        [ test "Should send the edit todo message on input" <|
            \() ->
                modelWithTodo5
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildItemLabelId 5) ]
                    |> Event.simulate Event.doubleClick
                    |> Event.expect (EditTodo todo5)
        ]


view : Test
view =
    describe "Verify View"
        [ test "Should make the input editable" <|
            \() ->
                -- GIVEN
                modelWithEditableTodo5
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildItemId 5) ]
                    |> Query.has
                        [ class "editing" ]
        ]


todo5 : Todo
todo5 =
    { buildTodo | title = "Todo 5", id = 5, editing = False }


modelWithTodo5 : Model.Model
modelWithTodo5 =
    { buildModel | todos = [ todo5 ] }


todo8 : Todo
todo8 =
    { buildTodo | title = "Todo 8", id = 8, editing = False, complete = True }


modelWithCompletedTodo8 : Model
modelWithCompletedTodo8 =
    { buildModel | todos = [ todo8 ] }


modelWithEditableTodo5 : Model
modelWithEditableTodo5 =
    { buildModel | todos = [ { todo5 | editing = True } ] }
