module ID exposing (buildDeleteButtonId, buildEditInputId, buildFilterId, buildFilterlinkId, buildItemCheckId, buildItemId, buildItemLabelId)

import Filter exposing (Filter)


buildItemId : Int -> String
buildItemId id =
    "todo-" ++ String.fromInt id


buildDeleteButtonId : Int -> String
buildDeleteButtonId id =
    buildTodoId "delete" id


buildEditInputId : Int -> String
buildEditInputId id =
    buildTodoId "edit" id


buildItemLabelId : Int -> String
buildItemLabelId id =
    buildTodoId "label" id


buildItemCheckId : Int -> String
buildItemCheckId id =
    buildTodoId "check" id


buildFilterlinkId : Filter -> String
buildFilterlinkId filter =
    buildFilterId filter ++ "-link"


buildFilterId : Filter -> String
buildFilterId filter =
    "show-" ++ String.toLower (Filter.toString filter)



-- INTERNAL


buildTodoId : String -> Int -> String
buildTodoId prefix id =
    prefix ++ "-" ++ buildItemId id
