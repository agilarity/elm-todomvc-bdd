module IT.ViewInfoFooterPT exposing (all)

import Html.Attributes exposing (href)
import IT.App.Action exposing (startApp)
import ProgramTest exposing (ProgramTest, done, ensureViewHas, expectViewHas, within)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, tag, text)


all : Test
all =
    describe "GOAL-2: View Info Footer"
        [ test "RULE-2.1: Should see the edit instructions" <|
            \() ->
                -- When the home page is viewed
                startApp
                    -- Then the "Double-click to edit a todo" text will be visible
                    |> expectViewHas
                        [ text "Double-click to edit a todo" ]
        , test "RULE-2.2: Should see the created by message" <|
            \() ->
                -- When the home page is viewed
                startApp
                    -- Then the "Created by" text will be visible
                    |> expectViewHas
                        [ text "Created by" ]
        , test "RULE-2.3: Should see the created by link" <|
            \() ->
                -- When the home page is viewed
                startApp
                    -- Then the "Created by" link will be visible
                    |> ensureHasFooterLink "Joseph Cruz" "http://agilarity.com"
                    |> done
        , test "RULE-2.4: Should see the part of message" <|
            \() ->
                -- When the home page is viewed
                startApp
                    -- Then the "Part of" text will be visible
                    |> expectViewHas
                        [ text "Part of" ]
        , test "RULE-2.5: Should see the part of link" <|
            \() ->
                -- When the home page is viewed
                startApp
                    -- Then the "TodoMVC" text will be visible
                    |> ensureHasFooterLink "TodoMVC" "http://todomvc.com"
                    |> done
        ]


ensureHasFooterLink : String -> String -> ProgramTest model msg effect -> ProgramTest model msg effect
ensureHasFooterLink linkLabel locationHref context =
    context
        |> within
            (Query.find
                [ tag "footer"
                , class "info"
                ]
            )
            (ensureViewHas
                [ tag "a"
                , text linkLabel
                , attribute (href locationHref)
                ]
            )
