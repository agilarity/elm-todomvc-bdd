module Unit.ChangeTitleTest exposing (action, update, view)

import Expect
import ID
import KeyboardEvent
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
            [ test "Should exit the editing mode" <|
                \() ->
                    -- GIVEN
                    modelEditing7
                        -- WHEN
                        |> handleMsg (ChangeTitle 7)
                        -- THEN
                        |> Tuple.first
                        |> Expect.equal modelNotEditing7
            ]
        , describe "Verify Effect"
            [ test "Should store the edit mode change" <|
                \() ->
                    -- GIVEN
                    modelEditing7
                        -- WHEN
                        |> handleMsg (ChangeTitle 7)
                        -- THEN
                        |> Tuple.second
                        |> Expect.equal (SaveModel modelNotEditing7)
            ]
        ]


action : Test
action =
    describe "Verify Action"
        [ test "Should send the change title message on enter" <|
            \() ->
                modelEditing7
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildEditInputId 7) ]
                    |> Event.simulate KeyboardEvent.enter
                    |> Event.expect (ChangeTitle 7)
        , test "Should send the change title message on blur" <|
            \() ->
                modelEditing7
                    |> viewBody
                    |> Query.fromHtml
                    |> Query.find [ id (ID.buildEditInputId 7) ]
                    |> Event.simulate Event.blur
                    |> Event.expect (ChangeTitle 7)
        ]


view : Test
view =
    describe "Verify View"
        [ test "Should not see the editing mode" <|
            \() ->
                -- GIVEN
                modelNotEditing7
                    -- WHEN
                    |> viewBody
                    -- THEN
                    |> Query.fromHtml
                    |> Query.hasNot
                        [ class "editing"
                        , id (ID.buildItemId 7)
                        ]
        ]


todo7 : Todo
todo7 =
    { buildTodo
        | title = "Todo 7"
        , id = 7
        , editing = True
    }


modelEditing7 : Model
modelEditing7 =
    { buildModel
        | todos =
            [ todo7 ]
    }


modelNotEditing7 : Model
modelNotEditing7 =
    { buildModel
        | todos =
            [ { todo7
                | editing = False
              }
            ]
    }
