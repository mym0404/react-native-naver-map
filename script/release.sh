#!/bin/bash
set -e
yarn t
#yarn codegen
yarn prepack
export $(grep -v '^#' .env | xargs) && release-it $1 $2
