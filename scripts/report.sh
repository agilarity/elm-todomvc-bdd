#!/bin/bash

# Data folders
DATA_FOLDER=tmp/reqs
TOTAL_REQS_FILE=$DATA_FOLDER/all-reqs.txt
TESTED_REQS_FILE=$DATA_FOLDER/tested-reqs.txt
NOT_COVERED_REQS_FILE=$DATA_FOLDER/not-covered-reqs.txt
KNOWN_NOT_COVERED_FILE=doc/requirements/not-covered.txt

# Ansi color code variables
RED="\e[0;31m"
BLUE="\e[0;34m"
GREEN="\e[0;32m"
PURPLE="\e[0;35m"
BOLD="\e[1m"
RESET="\e[0m"

function coverage {
    create-reqs-data
    totalReqs=$(wc -l $TOTAL_REQS_FILE | tr -dc '0-9')
    testedReqs=$(wc -l $TESTED_REQS_FILE | tr -dc '0-9')

    if [[ $testedReqs -gt 0 && $totalReqs -gt 0 ]]; then
        let notCovered=$totalReqs-$testedReqs
        coverage=$(awk -v a=$testedReqs -v b=$totalReqs 'BEGIN{printf "%.0f",(a/b)*100}')

        if [ $coverage -eq 100 ]; then
            echo -e "${GREEN}Coverage: $coverage% - All requirements are covered by automated testing with avh4/elm-program-test.${RESET}"
        else
            echo -e "${BLUE}${BOLD}Coverage: $coverage%, Requirements: $totalReqs, Covered: $testedReqs, Not Covered: $notCovered${RESET}"

            if [ $notCovered -gt 0 ]; then
                list-not-covered
            fi
        fi
    else
        echo Coverage: 0%, Requirements: $totalReqs, Covered: $testedReqs, Not Covered: $totalReqs
    fi
}

function help {
    echo "Usage: $0 <task> <args>"
    echo "Tasks:"
    echo "     coverage  Report requirements coverage"
}

### INTERNAL ###

function create-reqs-data {
    mkdir -p tmp/reqs
    list-reqs >$TOTAL_REQS_FILE
    list-tested-reqs >$TESTED_REQS_FILE
    list-not-covered-reqs >$NOT_COVERED_REQS_FILE
}

function list-reqs {
    grep --no-filename --extended-regexp --exclude=\overview.md "GOAL|RULE" doc/requirements/details/*.md | sed 's/#//' | sed 's/#//'
}

function list-tested-reqs {
    while read requirement; do
        grep --no-filename --only-matching "$requirement" tests/IT/*.elm
    done <$TOTAL_REQS_FILE
}

function list-not-covered-reqs {
    grep --invert-match --file $TESTED_REQS_FILE $TOTAL_REQS_FILE
}

function list-not-covered {
    echo "The following requirements are not covered by automated testing with avh4/elm-program-test."
    echo " $(list-colorized-not-covered)"
}

function list-colorized-not-covered {
    while read requirement; do
        known=$(grep --no-filename --only-matching "$requirement" $KNOWN_NOT_COVERED_FILE)

        if [ "$requirement" == "$known" ]; then
            echo -e "${PURPLE}$requirement${RESET} (${GREEN}${BOLD}OK${RESET}, Test Manually)"
        else
            echo -e "${RED}$requirement${RESET}"
        fi

    done <$NOT_COVERED_REQS_FILE
}

${@:-coverage} # Show the coverage report by default
