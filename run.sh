#!/bin/bash

set -u

BOLD="\e[1m"
UNDERLINE="\e[4m"
RESET="\e[0m"

function tools { #command: install Elm tools

    if ! command -v npm &>/dev/null; then
        echo "npm could not be found"
        exit
    else
        npm install
    fi
}

function clean { #command: remove generated files
    rm -rf elm-stuff out build tmp site/dist
}

function install { #alias-command: alias for `npx elm install` [OPTIONS]
    npx elm install "$@"
}

function test { #alias-command: alias for `npx elm-test --watch` [OPTIONS]
    npx elm-test --watch "$@"
}

function format { #alias-command: alias for `npx elm-format` [OPTIONS]
    npx elm-format "$@"
}

function coverage { #req-command: report scenario coverage
    ./scripts/reqs.sh coverage
}

function review { #alias-command: alias for `elm-review` [OPTIONS]
    npx elm-review "$@"
}

function fix { #alias-command: alias for `npx elm-review --fix` [OPTIONS]
    npx elm-review --fix "$@"
}

function fix-all { #alias-command: alias for `npx elm-review --fix-all` [OPTIONS]
    npx elm-review --fix-all "$@"
}

function live { #command: start `elm-live` server
    ./scripts/start-live.sh
}

function build:prod { #command: build and copy minified `elm.js` to site
    ./scripts/build.sh build_prod
}

function build:dev { #command: build and copy DEV `elm.js` to site
    ./scripts/build.sh build_dev
}

function reqs { #req-command: list all requirements
    ./scripts/reqs.sh all
}

function waived { #req-command: list waived requirements
    ./scripts/reqs.sh waived
}

function pending { #req-command: list pend requirements
    ./scripts/reqs.sh pending
}

function progress { #req-command: report progress
    ./scripts/reqs.sh progress_message
}

function _command_lines {
    grep -E '^function.+ #command' "$0" |
        sed 's/function/ /' |
        sed -e 's| { #command: |~|g' |
        column -s"~" -t |
        sort
}

function _req_command_lines {
    grep -E '^function.+ #req-command' "$0" |
        sed 's/function/ /' |
        sed -e 's| { #req-command: |~|g' |
        column -s"~" -t |
        sort
}

function _alias_command_lines {
    grep -E '^function.+ #alias-command' "$0" |
        sed 's/function/ /' |
        sed -e 's| { #alias-command: |~|g' |
        column -s"~" -t |
        sort
}

function help {
    echo -e "${BOLD}Usage:${RESET} $(basename "$0") COMMAND [OPTIONS]"
    echo
    echo Uniform interface for running project commands
    echo
    echo -e "${BOLD}Commands:${RESET}"
    _command_lines
    echo
    echo -e "${BOLD}Alias Commands:${RESET}"
    _alias_command_lines
    echo
    echo -e "${BOLD}Requirement Commands:${RESET}"
    _req_command_lines
    echo
    echo -e "${BOLD}Options:${RESET}"
    echo "  Alias commands that accept tool specific options are tagged with [OPTIONS]"
    echo
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help} # Show the help message by default
