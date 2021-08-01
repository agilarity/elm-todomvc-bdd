#!/bin/bash

# See: https://github.com/adriancooney/Taskfile
# Add the following alias to your shell

# Run your tasks like: run <task>
# alias run=./Taskfile

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
    ./scripts/report.sh coverage
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
    ./scripts/report.sh list-reqs
}

function help {
    echo "Usage: $0 <task> <args>"
    echo "Tasks:"
    echo "     clean     Remove generated files"
    echo "     coverage  Report requirements coverage"
    echo "     format    Alias for elm-format"
    echo "     help      Show this list"
    echo "     install   Alias for elm install"
    echo "     live      Start elm-live server"
    echo "     prod      Build and copy minimized app to dist directory"
    echo "     reqs      List requirements"
    echo "     test      Alias for elm-test --watch"
    echo "     tools     Install Elm tools via npm"
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help} # Show the help message by default
