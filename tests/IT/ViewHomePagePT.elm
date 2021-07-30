module IT.ViewHomePagePT exposing (all)

import Filter exposing (Filter(..))
import Html.Attributes exposing (autofocus, hidden, placeholder)
import IT.App.Action exposing (startApp, startAppWith)
import IT.App.Result exposing (ensureFilterSelected)
import Model exposing (buildModel)
import ProgramTest exposing (done, expectViewHas, expectViewHasNot)
import Test exposing (Test, describe, test)
import Test.Html.Selector exposing (attribute, class, id)


all : Test
all =
    describe "GOAL-1: View Home Page"
        [ test "RULE-1.1: Should not see the main section" <|
            \() ->
                -- Given the todo list is empty
                { buildModel | todos = [] }
                    -- When the home page is viewed
                    |> startAppWith
                    -- Then the main section will not be visible
                    |> expectViewHasNot
                        [ class "main"
                        , attribute (hidden False)
                        ]
        , test "RULE-1.2: Should not see the footer section" <|
            \() ->
                -- Given the todo list is empty
                { buildModel | todos = [] }
                    -- When the home page is viewed
                    |> startAppWith
                    -- Then the footer section will not be visible
                    |> expectViewHasNot
                        [ class "footer"
                        , attribute (hidden False)
                        ]
        , test "RULE-1.3: Should see the focus on the new todo input" <|
            \() ->
                -- When the home page is first viewed
                startApp
                    -- Then the focus will be on the new todo input
                    |> expectViewHas
                        [ id "new-todo"
                        , attribute (autofocus True)
                        ]
        , test "RULE-1.4: Should see the new todo placeholder" <|
            \() ->
                -- When the home page is first viewed
                startApp
                    -- Then the new todo placeholder will be "What needs to be done?"
                    |> expectViewHas
                        [ id "new-todo"
                        , attribute (placeholder "What needs to be done?")
                        ]
        , test "RULE-1.5: Should select the default filter" <|
            \() ->
                -- When the home page is first viewed
                startApp
                    -- Then the show all todos action will be selected
                    |> ensureFilterSelected All
                    |> done
        ]
