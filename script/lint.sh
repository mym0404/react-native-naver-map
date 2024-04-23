#!/usr/bin/env bash

echo '⚒️ eslint .'
yarn lint:js
yarn lint:ios
yarn lint:android
echo '🐋 typescript .'
yarn typecheck