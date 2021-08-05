#!/bin/bash

set -u

# DATA FILES
DATA_FOLDER=tmp/reqs

ALL_REQS=$DATA_FOLDER/all.txt
ALL_TESTED=$DATA_FOLDER/all-tested.txt
ALL_NOT_TESTED=$DATA_FOLDER/all-not_tested.txt
ALL_PENDING=$DATA_FOLDER/all-pending.txt
ALL_WAIVED=$DATA_FOLDER/all-waived.txt

GOAL_REQS=$DATA_FOLDER/goals.txt
GOAL_TESTED=$DATA_FOLDER/goal-tested.txt
GOAL_NOT_TESTED=$DATA_FOLDER/goal-not_tested.txt
GOAL_PENDING=$DATA_FOLDER/goal-pending.txt

RULE_REQS=$DATA_FOLDER/rules.txt
RULE_TESTED=$DATA_FOLDER/rule-tested.txt
RULE_NOT_TESTED=$DATA_FOLDER/rule-not_tested.txt
RULE_PENDING=$DATA_FOLDER/rule-pending.txt
RULE_WAIVED=$DATA_FOLDER/rule-waived.txt

WAIVED_REQS=doc/requirements/not-covered.txt

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

function coverage { #help: report scenario coverage
    _load_rule_data

    local all_waived_count=$(wc -l $ALL_WAIVED | tr -dc '0-9')
    local all_pending_count=$(wc -l $ALL_PENDING | tr -dc '0-9')
    local all_rules_count=$(wc -l $RULE_REQS | tr -dc '0-9')
    local tested_rules_count=$(wc -l $RULE_TESTED | tr -dc '0-9')
    local waived_rules_count=$(wc -l $RULE_WAIVED | tr -dc '0-9')
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

    echo -e "Scenario coverage:$coverage_color $rule_coverage%${RESET} ➺ $tested_rules_count tested, $waived_rules_count waived, $pending_rules_count pending"

    if [ $all_pending_count -gt 0 ]; then
        echo -e "${BLUE} ${BOLD}PENDING - ${RESET}${BLUE}Test or wave the following requirements${RESET}"
        echo -e "${RED}$(cat $ALL_PENDING)${RESET}"
    fi

    if [ $all_waived_count -gt 0 ]; then
        echo -e "${BLUE} ${BOLD}WAIVED - ${RESET}${BLUE}Not covered by Elm Program Tests${RESET}"
        _list_waived_with_comments
    fi
}

function all { #help: list all requirements
    _create_data_dir
    _list_reqs $ALL >$ALL_REQS
    cat $ALL_REQS
}

function pending { #help: list pending requirements
    _create_data_dir
    _create_all_data
    cat $ALL_PENDING
}

function waived { #help: list waived requirements
    _create_data_dir
    _list_reqs $ALL >$ALL_REQS
    _list_waived $ALL_REQS >$ALL_WAIVED
    _list_waived_with_comments
}

# Support badges

function coverage_message { #help: show scenario coverage badge message
    _load_rule_data

    local all_rules_count=$(wc -l $RULE_REQS | tr -dc '0-9')
    local tested_rules_count=$(wc -l $RULE_TESTED | tr -dc '0-9')
    local waived_rules_count=$(wc -l $RULE_WAIVED | tr -dc '0-9')
    local pending_rules_count=$(wc -l $RULE_PENDING | tr -dc '0-9')

    if [[ $tested_rules_count -gt 0 && $all_rules_count -gt 0 ]]; then
        local rule_coverage=$(awk -v a=$tested_rules_count -v b=$all_rules_count 'BEGIN{printf "%.0f",(a/b)*100}')
    else
        local rule_coverage=0
    fi

    echo "$rule_coverage% - $tested_rules_count tested, $waived_rules_count waived, $pending_rules_count pending"
}

function progress_message { #help: show progress badge message
    _load_rule_data

    local all_rules_count=$(wc -l $RULE_REQS | tr -dc '0-9')
    local tested_rules_count=$(wc -l $RULE_TESTED | tr -dc '0-9')
    local waived_rules_count=$(wc -l $RULE_WAIVED | tr -dc '0-9')
    local completed_count=$((tested_rules_count + waived_rules_count))
    local rules_left=$((all_rules_count - completed_count))

    if [ $all_rules_count -eq 0 ]; then
        local progress="0% - no requirements"
    else
        if [ $rules_left -gt 0 ]; then
            local percent=$(awk -v a=$completed_count -v b=$all_rules_count 'BEGIN{printf "%.0f",(a/b)*100}')
            local progress="$percent% ($completed_count/$all_rules_count) ➺ $rules_left scenarios left"
        else
            local progress="100% - $all_rules_count scenarios completed"
        fi
    fi

    echo $progress
}

function progress_color { #help: show progress badge color
    _load_rule_data

    local all_rules_count=$(wc -l $RULE_REQS | tr -dc '0-9')
    local pending_rules_count=$(wc -l $RULE_PENDING | tr -dc '0-9')

    if [ $all_rules_count -eq 0 ]; then
        local progress="blue"
    else
        if [ $pending_rules_count -gt 0 ]; then
            local progress="yellow"
        else
            local progress="brightgreen"
        fi
    fi

    echo $progress
}

# Internal

function _load_rule_data {
    _create_data_dir
    _create_all_data
    _create_rule_data
}

function _create_all_data {
    _list_reqs $ALL >$ALL_REQS
    _list_waived $ALL_REQS >$ALL_WAIVED
    _list_tested $ALL_REQS >$ALL_TESTED
    _list_not_tested $ALL_REQS $ALL_TESTED >$ALL_NOT_TESTED
    _list_pending $ALL_NOT_TESTED $ALL_WAIVED >$ALL_PENDING
}

function _create_goal_data {
    _list_reqs $GOAL >$GOAL_REQS
    _list_tested $GOAL_REQS >$GOAL_TESTED
    _list_not_tested $GOAL_REQS $GOAL_TESTED >$GOAL_NOT_TESTED
    _list_pending $GOAL_NOT_TESTED $ALL_WAIVED >$GOAL_PENDING
}

function _create_rule_data {
    _list_reqs $RULE >$RULE_REQS
    _list_waived $RULE_REQS >$RULE_WAIVED
    _list_tested $RULE_REQS >$RULE_TESTED
    _list_not_tested $RULE_REQS $RULE_TESTED >$RULE_NOT_TESTED
    _list_pending $RULE_NOT_TESTED $ALL_WAIVED >$RULE_PENDING
}

function _create_data_dir {
    mkdir -p tmp/reqs
}

function _list_reqs {
    local pattern=$1
    if [ -n "${pattern:-}" ]; then
        grep --no-filename --extended-regexp $pattern doc/requirements/details/*.md | sed 's/[#]*//'
    fi
}

function _list_tested {
    local requirements=$1
    while read requirement; do
        grep --no-filename --only-matching "$requirement" tests/IT/*.elm
    done <$requirements
}

function _list_not_tested {
    local requirements=$1
    local covered=$2
    grep --invert-match --file $covered $requirements
}

function _list_waived {
    local requirements=$1
    while read requirement; do
        grep --no-filename --only-matching "$requirement" $WAIVED_REQS
    done <$requirements
}

function _list_pending {
    local not_tested=$1
    local expections=$2
    grep --invert-match --file $expections $not_tested
}

function _list_waived_with_comments {
    while read requirement; do
        local line=$(grep --no-filename "$requirement" $WAIVED_REQS)
        local comment=${line:${#requirement}+1}
        echo -e " $requirement ${UNDERLINE}$comment${RESET}"
    done <$ALL_WAIVED
}

function _help_lines {
    grep -E '^function.+ #help' "$0" |
        sed 's/function/      /' |
        sed -e 's| { #help: |~|g' |
        column -s"~" -t |
        sort
}

function help { #help: show available commands
    echo -e "${BOLD}help:${RESET} $(basename "$0") <command>"
    echo "    Display information about $(basename "$0") commands"
    echo
    echo -e "    ${BOLD}Commands:${RESET}"
    _help_lines
    echo
}

${@:-help} # Show the help message by default
