module Unit.UpdateTodoTest exposing (action, update, view)

import Expect
import Html.Attributes exposing (value)
import ID
import Main exposing (Effect(..), Msg(..), handleMsg, viewBody)
import Model exposing (Model, buildModel)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id)
import Todo exposing (Todo, buildTodo)



{-
   Tests are grouped by responsibility into the following suites.

    update - Assure each message updates the model and sends the effect message correctly
    action - Assure each user action sends the correct message
    view - Assure the correct markup is generated
-}


update : Test
update =
    describe "Input Todo"
        [ describe "Verify Model"
            [ test "Should update the todo" <|
                \() ->
                    -- GIVEN
                    modelWithEditableTodo
                        -- WHEN
                        |> handleMsg (UpdateTodo editableTodo.id "Verify update")
                        -- THEN
                        |> Tuple.first
                        |> Expect.equal
                            { modelWithEditableTodo
                                | todos =
                                    [ { editableTodo | title = "Verify update" }
                                    ]
                            }
            ]
        , describe "Verify Effects"
            [ test "Should ignore the model change" <|
                \() ->
                    modelWithEditableTodo
                        -- WHEN
                        |> handleMsg (UpdateTodo editableTodo.id "Verify update")
                        -- THEN
                        |> Tuple.second
                        |> Expect.equal IgnoreModelChange
            ]
        ]


action : Test
action =
    describe "Verify Action"
        [ test "Should send the update todo message" <|
            \() ->
                modelWithEditableTodo
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildEditInputId editableTodo.id) ]
                    |> Event.simulate (Event.input "Verify input")
                    |> Event.expect (UpdateTodo editableTodo.id "Verify input")
        ]


view : Test
view =
    describe "Verify View"
        [ test "Should see the todo input" <|
            \() ->
                -- GIVEN
                modelWithEditableTodo
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildEditInputId editableTodo.id) ]
                    |> Query.has [ attribute (value editableTodo.title) ]
        ]


editableTodo : Todo
editableTodo =
    { buildTodo | title = "Todo 7", id = 7, editing = True }


modelWithEditableTodo : Model
modelWithEditableTodo =
    { buildModel | todos = [ { editableTodo | editing = True } ] }
