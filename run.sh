#!/bin/bash

set -u

# See: https://github.com/adriancooney/Taskfile
# Add the following alias to your shell

# Run your tasks like: run <task>
# alias run=./Taskfile

BOLD="\e[1m"
UNDERLINE="\e[4m"
RESET="\e[0m"

function tools {

    if ! command -v npm &>/dev/null; then
        echo "npm could not be found"
        exit
    else
        npm install
    fi
}

function clean {
    rm -rf elm-stuff out build tmp site/dist
}

function install {
    npx elm install "$@"
}

function test {
    npx elm-test --watch "$@"
}

function format {
    npx elm-format "$@"
}

function coverage {
    ./scripts/reqs.sh coverage
}

function review {
    npx elm-review
}

function fix {
    npx elm-review --fix
}

function fix-all {
    npx elm-review --fix-all
}

function live {
    ./scripts/start-live.sh
}

function prod {
    ./scripts/build.sh build:prod
}

function reqs {
    ./scripts/reqs.sh all
}

function waved {
    ./scripts/reqs.sh waved
}

function pending {
    ./scripts/reqs.sh pending
}

function help {
    echo "Usage: $0 <task> <args>"
    echo "Tasks:"
    echo ""
    echo -e "${BOLD}${UNDERLINE}Development:${RESET}"
    echo "  tools     Install Elm tools"
    echo "  clean     Remove generated files"
    echo "  format    Alias for elm-format"
    echo "  install   Alias for elm install"
    echo "  live      Start elm-live server"
    echo "  reivew    Alias for elm-review"
    echo "  fix   Alias for elm-review --fix"
    echo "  fix-all   Alias for elm-review --fix-all"
    echo "  test      Alias for elm-test --watch"
    echo ""
    echo -e "${BOLD}${UNDERLINE}Production:${RESET}"
    echo "  prod      Build and copy minimized app to dist directory"
    echo ""
    echo -e "${BOLD}${UNDERLINE}Requirements:${RESET}"
    echo "  coverage  Report requirements coverage"
    echo "  pending   List pending requirements"
    echo "  reqs      List requirements"
    echo "  waved     List requirements that will not be covered by Elm Program Tests"
    echo "  help      Show this list"
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help} # Show the help message by default
