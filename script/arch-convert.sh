#!/usr/bin/env bash
set -e

NEW_ARCH="$1"

if [ "${NEW_ARCH}" != "true" ] && [ "${NEW_ARCH}" != "false" ]; then
  echo "Error: The argument should be either 'true' or 'false'"
  exit 1
fi

pwd
NEW_ARCH_KEY="newArchEnabled"
GRADLE="example/android/gradle.properties"

if grep -q "newArchEnabled=true" $GRADLE; then
  PREV_NEW_ARCH=true
else
  PREV_NEW_ARCH=false
fi

if [[ $PREV_NEW_ARCH == $NEW_ARCH ]]; then
echo "Architecture is already $( [ "$NEW_ARCH" = 'true' ] && echo 'new' || echo 'old') 🎉"
else

sed -i.bak -e "s/${NEW_ARCH_KEY}=.*/${NEW_ARCH_KEY}=${NEW_ARCH}/" "${GRADLE}"
rm "${GRADLE}.bak"

(cd example/android && rm -rf app/build && rm -rf app/.cxx)

  if [[ $NEW_ARCH == 'true' ]]; then
    yarn pod:new
  else
    yarn pod:old
  fi
fi








