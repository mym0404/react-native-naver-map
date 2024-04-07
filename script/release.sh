#!/bin/bash

export $(grep -v '^#' .env | xargs) && release-it --increment=patch --ci