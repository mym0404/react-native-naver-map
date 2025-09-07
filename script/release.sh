#!/bin/bash
set -e
pnpm t
#pnpm codegen
pnpm prepack
export $(grep -v '^#' .env | xargs) && release-it $1 $2
