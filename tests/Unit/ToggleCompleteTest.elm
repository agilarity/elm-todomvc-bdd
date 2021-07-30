module Unit.ToggleCompleteTest exposing (action, update, view)

import Expect
import Html.Attributes exposing (checked)
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
    describe "Verify Update"
        [ describe "Verify Model"
            [ test "Should complete the todo" <|
                \() ->
                    -- GIVEN
                    modelWithActiveTodo1
                        -- WHEN
                        |> handleMsg (ToggleComplete 1)
                        -- THEN
                        |> Tuple.first
                        |> Expect.equal modelWithCompleteTodo1
            , test "Should activate the todo" <|
                \() ->
                    -- GIVEN
                    modelWithCompleteTodo1
                        -- WHEN
                        |> handleMsg (ToggleComplete 1)
                        -- THEN
                        |> Tuple.first
                        |> Expect.equal modelWithActiveTodo1
            ]
        , describe "Verify Effects"
            [ test "Should save the model after toggle complete" <|
                \() ->
                    -- GIVEN
                    buildModel
                        -- WHEN
                        |> handleMsg (ToggleComplete 1)
                        -- THEN
                        |> Tuple.second
                        |> Expect.equal (SaveModel buildModel)
            ]
        ]


action : Test
action =
    describe "Verify Action"
        [ test "Should send the toggle complete todo message" <|
            \() ->
                modelWithActiveTodo1
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildItemCheckId 1) ]
                    |> Event.simulate Event.click
                    |> Event.expect (ToggleComplete 1)
        ]


view : Test
view =
    describe "Verify View"
        [ test "Should send the toggle complete todo message" <|
            \() ->
                modelWithCompleteTodo1
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildItemCheckId 1) ]
                    |> Query.has [ attribute (checked True) ]
        ]


todo1 : Todo
todo1 =
    { buildTodo | title = "Todo 1", id = 1, complete = False }


modelWithActiveTodo1 : Model
modelWithActiveTodo1 =
    { buildModel
        | todos = [ todo1 ]
    }


modelWithCompleteTodo1 : Model
modelWithCompleteTodo1 =
    { buildModel
        | todos = [ { todo1 | complete = True } ]
    }
