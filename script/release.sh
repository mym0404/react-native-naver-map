#!/bin/bash
git pull origin main
yarn t
yarn codegen
export $(grep -v '^#' .env | xargs) && release-it --ci