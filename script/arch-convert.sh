#!/usr/bin/env bash
set -e

NEW_ARCH="$1"
OS=$2

if [ "${NEW_ARCH}" != "true" ] && [ "${NEW_ARCH}" != "false" ]; then
  echo "Error: The argument should be either 'true' or 'false'"
  exit 1
fi

pwd

NEW_ARCH_KEY="newArchEnabled"

if grep -q "newArchEnabled=true" example/android/gradle.properties; then
  PREV_NEW_ARCH_ANDROID=true
else
  PREV_NEW_ARCH_ANDROID=false
fi

if grep -q "FBReactNativeSpec" example/ios/Podfile.lock; then
  PREV_NEW_ARCH_IOS=false
else
  PREV_NEW_ARCH_IOS=true
fi

if [[ $PREV_NEW_ARCH_ANDROID != $PREV_NEW_ARCH_IOS ]]; then
  PREV_NEW_ARCH=?
else
  PREV_NEW_ARCH=$PREV_NEW_ARCH_ANDROID
fi

echo "Previous Android : $( [ "$PREV_NEW_ARCH_ANDROID" = 'true' ] && echo 'new' || echo 'old')"
echo "Previous iOS     : $( [ "$PREV_NEW_ARCH_IOS" = 'true' ] && echo 'new' || echo 'old')"

if [[ $PREV_NEW_ARCH == $NEW_ARCH ]]; then
  echo "Architecture is already $( [ "$NEW_ARCH" = 'true' ] && echo 'new' || echo 'old') 🎉"
else

if [[ -z $OS || $OS == 'android' ]]; then
  sed -i.bak -e "s/${NEW_ARCH_KEY}=.*/${NEW_ARCH_KEY}=${NEW_ARCH}/" "example/android/gradle.properties"
  rm "example/android/gradle.properties.bak"
  (cd example/android && rm -rf app/build && rm -rf app/.cxx && ./gradlew clean)
fi

if [[ -z $OS || $OS == 'ios' ]]; then
  if [[ $NEW_ARCH == 'true' ]]; then
    yarn pod:new
  else
    yarn pod:old
  fi
fi

fi
