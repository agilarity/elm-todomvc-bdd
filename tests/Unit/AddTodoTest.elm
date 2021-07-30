module Unit.AddTodoTest exposing (action, update, view)

import Common.TestData exposing (buildTestModel)
import Expect
import Html.Attributes exposing (placeholder)
import KeyboardEvent
import Main exposing (Effect(..), Msg(..), handleMsg, viewBody)
import Model exposing (buildModel)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, id, tag, text)
import Todo exposing (buildTodo)



{-
   Tests are grouped by responsibility into the following suites.

    update - Assure each message updates the model and sends the effect message correctly
    action - Assure each user action sends the correct message
    view - Assure the correct markup is generated
-}


update : Test
update =
    describe "Verify Update"
        [ test "Should not save the empty todo" <|
            \() ->
                let
                    model : Model.Model
                    model =
                        { buildModel | newTodoTitle = "    " }
                in
                model
                    |> handleMsg AddTodo
                    |> Expect.equal ( model, NoEffect )
        , test "Should save the new todo" <|
            \() ->
                let
                    model : Model.Model
                    model =
                        { buildModel | newTodoTitle = "Todo 23", maxId = 22 }

                    expectedModel : Model.Model
                    expectedModel =
                        { buildModel
                            | newTodoTitle = ""
                            , maxId = 23
                            , todos =
                                [ { buildTodo | title = "Todo 23", id = 23 } ]
                        }
                in
                model
                    |> handleMsg AddTodo
                    |> Expect.equal
                        ( expectedModel
                        , SaveModel expectedModel
                        )
        , test "Should save the todo without leading or trailing spaces" <|
            \() ->
                let
                    model : Model.Model
                    model =
                        { buildModel | newTodoTitle = "  Todo 14  ", maxId = 13 }

                    expectedModel : Model.Model
                    expectedModel =
                        { buildModel
                            | newTodoTitle = ""
                            , maxId = 14
                            , todos =
                                [ { buildTodo | title = "Todo 14", id = 14 } ]
                        }
                in
                model
                    |> handleMsg AddTodo
                    |> Expect.equal
                        ( expectedModel
                        , SaveModel expectedModel
                        )
        ]


action : Test
action =
    describe "Verify Action"
        [ test "Should send the update new todo message on input" <|
            \() ->
                buildModel
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ tag "input", id "new-todo" ]
                    |> Event.simulate (Event.input "Type in the new todo")
                    |> Event.expect (UpdateNewTodo "Type in the new todo")
        , test "Should send the add todo message on blur" <|
            \() ->
                buildModel
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ tag "input", id "new-todo" ]
                    |> Event.simulate Event.blur
                    |> Event.expect AddTodo
        , test "Should send the add todo message on enter" <|
            \() ->
                buildModel
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ tag "input", id "new-todo" ]
                    |> Event.simulate KeyboardEvent.enter
                    |> Event.expect AddTodo
        ]


view : Test
view =
    describe "Verify View"
        [ test "Should see the new todo placeholder" <|
            \() ->
                -- GIVEN
                buildModel
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.has
                        [ attribute (placeholder "What needs to be done?") ]
        , test "Should see the todo title" <|
            \() ->
                let
                    model : Model.Model
                    model =
                        buildTestModel { totalItems = 54, completedItems = 32 }
                in
                -- GIVEN
                model
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.findAll
                        [ class "todo-list"
                        , tag "li"
                        ]
                    |> Query.index 30
                    |> Query.has [ text "Todo 31" ]
        , test "Should see the expected number of todos" <|
            \() ->
                -- GIVEN
                buildTestModel { totalItems = 23, completedItems = 17 }
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.findAll
                        [ class "todo-list"
                        , tag "li"
                        ]
                    |> Query.count (Expect.equal 23)
        ]
