module IT.AddNewTodoOnBlurPT exposing (all)

import IT.App.Action exposing (blurNewTodo, fillInNewTodo, startApp)
import IT.App.Result exposing (ensureNewTodoValue, ensureTodoNotPresent, ensureTodoValue)
import ProgramTest exposing (done)
import Test exposing (Test, describe, test)


all : Test
all =
    describe "GOAL-3: Add New Todo (on blur)"
        [ test "RULE-3.1: Should not add an empty new todo" <|
            \() ->
                -- Given the new todo is filled with only space characters
                startApp
                    |> fillInNewTodo "  "
                    -- When the todo loses focus
                    |> blurNewTodo
                    -- Then the new todo will not be visible in the list
                    |> ensureTodoNotPresent 1
                    |> done
        , test "RULE-3.2: Should add the new todo" <|
            \() ->
                -- Given the new todo is filled
                startApp
                    |> fillInNewTodo "Todo 1"
                    -- When the todo loses focus
                    |> blurNewTodo
                    -- Then the new todo will be visible in the list
                    |> ensureTodoValue 1 "Todo 1"
                    |> done
        , test "RULE-3.3: Should clear the new todo input" <|
            \() ->
                -- Given the new todo is filled
                startApp
                    |> fillInNewTodo "Todo 1"
                    -- When the todo loses focus
                    |> blurNewTodo
                    -- Then the new todo input will be empty
                    |> ensureNewTodoValue ""
                    |> done
        , test "RULE-3.4: Should trim the new todo" <|
            \() ->
                -- Given the new todo is filled with leading and trailing spaces
                startApp
                    |> fillInNewTodo "  Todo 1  "
                    -- When the todo loses focus
                    |> blurNewTodo
                    -- Then the new todo will not have leading or trailing spaces
                    |> ensureTodoValue 1 "Todo 1"
                    |> done
        ]
