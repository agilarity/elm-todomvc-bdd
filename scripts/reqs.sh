#!/bin/bash

set -u

# DATA FILES
DATA_FOLDER=tmp/reqs

ALL_REQS=$DATA_FOLDER/all.txt
ALL_TESTED=$DATA_FOLDER/all-tested.txt
ALL_NOT_TESTED=$DATA_FOLDER/all-not_tested.txt
ALL_PENDING=$DATA_FOLDER/all-pending.txt
ALL_WAVED=$DATA_FOLDER/all-waved.txt

GOAL_REQS=$DATA_FOLDER/goals.txt
GOAL_TESTED=$DATA_FOLDER/goal-tested.txt
GOAL_NOT_TESTED=$DATA_FOLDER/goal-not_tested.txt
GOAL_PENDING=$DATA_FOLDER/goal-pending.txt

RULE_REQS=$DATA_FOLDER/rules.txt
RULE_TESTED=$DATA_FOLDER/rule-tested.txt
RULE_NOT_TESTED=$DATA_FOLDER/rule-not_tested.txt
RULE_PENDING=$DATA_FOLDER/rule-pending.txt
RULE_WAVED=$DATA_FOLDER/rule-waved.txt

WAVED_REQS=doc/requirements/not-covered.txt

# SEARCH PATTERNS
ALL="GOAL|RULE"
GOAL="GOAL"
RULE="RULE"

# COLOR CODES
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
PURPLE="\e[0;35m"
CYAN="\e[0;36m"

BOLD="\e[1m"
UNDERLINE="\e[4m"
RESET="\e[0m"

function coverage {
    _create_data_dir
    _create_all_data
    _create_rule_data

    local all_waved_count=$(wc -l $ALL_WAVED | tr -dc '0-9')
    local all_pending_count=$(wc -l $ALL_PENDING | tr -dc '0-9')
    local all_rules_count=$(wc -l $RULE_REQS | tr -dc '0-9')
    local tested_rules_count=$(wc -l $RULE_TESTED | tr -dc '0-9')
    local waved_rules_count=$(wc -l $RULE_WAVED | tr -dc '0-9')
    local pending_rules_count=$(wc -l $RULE_PENDING | tr -dc '0-9')

    if [[ $tested_rules_count -gt 0 && $all_rules_count -gt 0 ]]; then
        local rule_coverage=$(awk -v a=$tested_rules_count -v b=$all_rules_count 'BEGIN{printf "%.0f",(a/b)*100}')
    else
        local rule_coverage=0
    fi

    if [ $all_pending_count -eq 0 ]; then
        local coverage_color=${GREEN}${BOLD}
    else
        local coverage_color=${BOLD}
    fi

    echo -e "Scenario coverage:$coverage_color $rule_coverage%${RESET} ➺ $tested_rules_count tested, $waved_rules_count waved, $pending_rules_count pending"

    if [ $all_pending_count -gt 0 ]; then
        echo -e "${BLUE} ${BOLD}PENDING - ${RESET}${BLUE}Test or wave the following requirements${RESET}"
        echo -e "${RED}$(cat $ALL_PENDING)${RESET}"
    fi

    if [ $all_waved_count -gt 0 ]; then
        echo -e "${BLUE} ${BOLD}WAVED - ${RESET}${BLUE}Not covered by Elm Program Tests${RESET}"
        list_waved_with_comments
    fi
}

function all {
    _create_data_dir
    _list_reqs $ALL >$ALL_REQS
    cat $ALL_REQS
}

function pending {
    _create_data_dir
    _create_all_data
    cat $ALL_PENDING
}

function waved {
    _create_data_dir
    _list_reqs $ALL >$ALL_REQS
    _list_waved $ALL_REQS >$ALL_WAVED
    list_waved_with_comments
}

function list_waved_with_comments {
    while read requirement; do
        local line=$(grep --no-filename "$requirement" $WAVED_REQS)
        local comment=${line:${#requirement}+1}
        echo -e " $requirement ${UNDERLINE}$comment${RESET}"
    done <$ALL_WAVED
}

# Support badges

function coverage_message {
    _create_data_dir
    _create_all_data
    _create_rule_data

    local all_rules_count=$(wc -l $RULE_REQS | tr -dc '0-9')
    local tested_rules_count=$(wc -l $RULE_TESTED | tr -dc '0-9')
    local waved_rules_count=$(wc -l $RULE_WAVED | tr -dc '0-9')
    local pending_rules_count=$(wc -l $RULE_PENDING | tr -dc '0-9')

    if [[ $tested_rules_count -gt 0 && $all_rules_count -gt 0 ]]; then
        local rule_coverage=$(awk -v a=$tested_rules_count -v b=$all_rules_count 'BEGIN{printf "%.0f",(a/b)*100}')
    else
        local rule_coverage=0
    fi

    echo "$rule_coverage% ➺ $tested_rules_count tested, $waved_rules_count waved, $pending_rules_count pending"
}

function progress_message {
    _create_data_dir
    _create_all_data
    _create_rule_data

    local all_rules_count=$(wc -l $RULE_REQS | tr -dc '0-9')
    local tested_rules_count=$(wc -l $RULE_TESTED | tr -dc '0-9')
    local waved_rules_count=$(wc -l $RULE_WAVED | tr -dc '0-9')
    local completed_count=$((tested_rules_count + waved_rules_count))
    local rules_left=$((all_rules_count - completed_count))

    if [ $rules_left -gt 0 ]; then
        local percent=$(awk -v a=$completed_count -v b=$all_rules_count 'BEGIN{printf "%.0f",(a/b)*100}')
        local progress="$percent% ($completed_count/$all_rules_count) ➺ $rules_left scenarios left"
    else
        local progress="100% ➺ $all_rules_count scenarios completed"
    fi

    echo $progress
}

# Internal

function _create_all_data {
    _list_reqs $ALL >$ALL_REQS
    _list_waved $ALL_REQS >$ALL_WAVED
    _list_tested $ALL_REQS >$ALL_TESTED
    _list_not_tested $ALL_REQS $ALL_TESTED >$ALL_NOT_TESTED
    _list_pending $ALL_NOT_TESTED $ALL_WAVED >$ALL_PENDING
}

function _create_goal_data {
    _list_reqs $GOAL >$GOAL_REQS
    _list_tested $GOAL_REQS >$GOAL_TESTED
    _list_not_tested $GOAL_REQS $GOAL_TESTED >$GOAL_NOT_TESTED
    _list_pending $GOAL_NOT_TESTED $ALL_WAVED >$GOAL_PENDING
}

function _create_rule_data {
    _list_reqs $RULE >$RULE_REQS
    _list_waved $RULE_REQS >$RULE_WAVED
    _list_tested $RULE_REQS >$RULE_TESTED
    _list_not_tested $RULE_REQS $RULE_TESTED >$RULE_NOT_TESTED
    _list_pending $RULE_NOT_TESTED $ALL_WAVED >$RULE_PENDING
}

function _create_data_dir {
    mkdir -p tmp/reqs
}

function _list_reqs {
    pattern=$1
    if [ -n "${pattern:-}" ]; then
        grep --no-filename --extended-regexp $pattern doc/requirements/details/*.md | sed 's/[#]*//'
    fi
}

function _list_tested {
    requirements=$1
    while read requirement; do
        grep --no-filename --only-matching "$requirement" tests/IT/*.elm
    done <$requirements
}

function _list_not_tested {
    requirements=$1
    covered=$2
    grep --invert-match --file $covered $requirements
}

function _list_waved {
    requirements=$1
    while read requirement; do
        grep --no-filename --only-matching "$requirement" $WAVED_REQS
    done <$requirements
}

function _list_pending {
    not_tested=$1
    expections=$2
    grep --invert-match --file $expections $not_tested
}

function help {
    echo "Usage: $0 <task> <args>"
    echo "Tasks:"
    echo "  coverage           Report requirements coverage"
    echo "  coverage_percent   Report requirements coverage"
    echo "  all                List all requirements"
    echo "  pending            List pending requirements"
    echo "  waved              List waved requirements with comments"
}

${@:-help} # Show the help message by default
