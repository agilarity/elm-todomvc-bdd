module Unit.DeleteTodoTest exposing (action, update, view)

import Common.TestData exposing (buildTestModel)
import Expect
import Html.Attributes exposing (hidden)
import ID
import KeyboardEvent
import Main exposing (Effect(..), Msg(..), handleMsg, viewBody)
import Model exposing (Model, buildModel)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, id)
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
        [ test "Should remove the todo" <|
            \() ->
                let
                    model : Model
                    model =
                        { buildModel
                            | todos =
                                [ { buildTodo | title = "d1", id = 1 }
                                , { buildTodo | title = "d2", id = 2 }
                                , { buildTodo | title = "d3", id = 3 }
                                ]
                        }

                    expectedModel : Model
                    expectedModel =
                        { buildModel
                            | todos =
                                [ { buildTodo | title = "d1", id = 1 }
                                , { buildTodo | title = "d3", id = 3 }
                                ]
                        }
                in
                -- GIVEN
                model
                    -- WHEN
                    |> handleMsg (DeleteTodo 2)
                    -- THEN
                    |> Expect.equal ( expectedModel, SaveModel expectedModel )
        ]


action : Test
action =
    describe "Verify Action"
        [ test "Should send the delete todo message on click" <|
            \() ->
                buildTestModel { totalItems = 5, completedItems = 3 }
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildDeleteButtonId 2) ]
                    |> Event.simulate Event.click
                    |> Event.expect (DeleteTodo 2)
        , test "Should send the delete todo message on enter" <|
            \() ->
                modelWithEmptyTodo5
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildEditInputId 5) ]
                    |> Event.simulate KeyboardEvent.enter
                    |> Event.expect (DeleteTodo 5)
        , test "Should send the delete todo message on blur" <|
            \() ->
                modelWithEmptyTodo5
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildEditInputId 5) ]
                    |> Event.simulate Event.blur
                    |> Event.expect (DeleteTodo 5)
        ]


view : Test
view =
    describe "Verify View"
        [ test "Should not see the empty todo list" <|
            \() ->
                -- GIVEN
                { buildModel | todos = [] }
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.find [ class "main" ]
                    |> Query.has
                        [ attribute (hidden True) ]
        ]


emptyTodo5 : Todo
emptyTodo5 =
    { buildTodo
        | title = ""
        , id = 5
        , editing = True
    }


modelWithEmptyTodo5 : Model
modelWithEmptyTodo5 =
    { buildModel
        | todos =
            [ emptyTodo5 ]
    }
