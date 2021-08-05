#!/bin/bash

# Files
BUILD_DIR=build
OPTIMIZED_FILE="$BUILD_DIR/elm.js"
MINIFIED_FILE="$BUILD_DIR/elm-min.js"
DIST_DIR=site/dist
APP_FILE=elm.js

# Color Codes
BOLD="\e[1m"
UNDERLINE="\e[4m"
RESET="\e[0m"

function build_dev { #command: build and copy DEV `elm.js` to site
    npx elm make src/Main.elm
}

function build_prod { #command: build and copy minified `elm.js` to site
    _build_minified
    _assure_dist_dir
    cp --force $MINIFIED_FILE $DIST_DIR/$APP_FILE
    echo Minified file deployed to $DIST_DIR
}

# Internal

function _build_minified {
    rm -rf $BUILD_DIR
    mkdir $BUILD_DIR

    npx elm make src/Main.elm --optimize --output=$OPTIMIZED_FILE "$@"
    npx uglifyjs $OPTIMIZED_FILE --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx uglifyjs --mangle --output $MINIFIED_FILE

    echo "Compiled size:$(wc $OPTIMIZED_FILE -c) bytes  ($OPTIMIZED_FILE)"
    echo "Minified size:$(wc $MINIFIED_FILE -c) bytes  ($MINIFIED_FILE)"
    echo "Gzipped size: $(gzip $MINIFIED_FILE -c | wc -c) bytes"
}

function _assure_dist_dir {

    if [ ! -d "$DIST_DIR" ]; then
        echo Creating $DIST_DIR
        mkdir -p $DIST_DIR
    fi
}

function _command_lines {
    grep -E '^function.+ #command' "$0" |
        sed 's/function/ /' |
        sed -e 's| { #command: |~|g' |
        column -s"~" -t |
        sort
}

function help {
    echo -e "${BOLD}Usage:${RESET} $(basename "$0") COMMAND"
    echo
    echo Make the Elm file
    echo
    echo -e "${BOLD}Commands:${RESET}"
    _command_lines
    echo
}

${@:-help} # Show the help message by default
