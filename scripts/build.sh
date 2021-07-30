#!/bin/bash

# Files
BUILD_DIR=build
OPTIMIZED_FILE="$BUILD_DIR/elm.js"
MINIFIED_FILE="$BUILD_DIR/elm-min.js"
DIST_DIR=site/dist
APP_FILE=elm.js

function optimize {
    rm -rf $BUILD_DIR
    mkdir $BUILD_DIR

    elm make src/Main.elm --optimize --output=$OPTIMIZED_FILE "$@"
    uglifyjs $OPTIMIZED_FILE --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output $MINIFIED_FILE

    echo "Compiled size:$(wc $OPTIMIZED_FILE -c) bytes  ($OPTIMIZED_FILE)"
    echo "Minified size:$(wc $MINIFIED_FILE -c) bytes  ($MINIFIED_FILE)"
    echo "Gzipped size: $(gzip $MINIFIED_FILE -c | wc -c) bytes"
}

function assureDistDir {

    if [ ! -d "$DIST_DIR" ]; then
        echo Creating $DIST_DIR
        mkdir -p $DIST_DIR
    fi
}

function build:prod {
    optimize
    assureDistDir
    cp --force $MINIFIED_FILE $DIST_DIR/$APP_FILE
    echo Minified file deployed to $DIST_DIR
}

${@:-build:prod} # Build the minimized files by default
