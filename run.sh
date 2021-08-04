#!/bin/bash

set -u

BOLD="\e[1m"
UNDERLINE="\e[4m"
RESET="\e[0m"

function tools { #help: install Elm tools

    if ! command -v npm &>/dev/null; then
        echo "npm could not be found"
        exit
    else
        npm install
    fi
}

function clean { #help: remove generated files
    rm -rf elm-stuff out build tmp site/dist
}

function install { #help: alias for `elm install`
    npx elm install "$@"
}

function test { #help: alias for `elm-test --watch`
    npx elm-test --watch "$@"
}

function format { #help: alias for `elm-format`
    npx elm-format "$@"
}

function coverage { #help: report scenario coverage
    ./scripts/reqs.sh coverage
}

function review { #help: alias for `elm-review`
    npx elm-review "$@"
}

function fix { #help: alias for `elm-review --fix`
    npx elm-review --fix
}

function fix-all { #help: alias for `elm-review --fix-all`
    npx elm-review --fix-all
}

function live { #help: start `elm-live` server
    ./scripts/start-live.sh
}

function prod { #help: build and copy minified `elm.js` to site
    ./scripts/build.sh build_prod
}

function reqs { #help: list all requirements
    ./scripts/reqs.sh all
}

function waved { #help: list waved requirements
    ./scripts/reqs.sh waved
}

function pending { #help: list pend requirements
    ./scripts/reqs.sh pending
}

function progress { #help: report progress
    ./scripts/reqs.sh progress_message
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

TIMEFORMAT="Task completed in %3lR"
time ${@:-help} # Show the help message by default
