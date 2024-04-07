#!/bin/bash

yarn t
yarn codegen
export $(grep -v '^#' .env | xargs) && release-it --increment=patch --ci