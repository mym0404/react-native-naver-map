#!/usr/bin/env bash

# Gradle property to change
PROPERTY="newArchEnabled"

# New value from first command line argument
NEW_VALUE="$1"
POD="$2"

# Validate new value is either "true" or "false"
if [ "${NEW_VALUE}" != "true" ] && [ "${NEW_VALUE}" != "false" ]; then
  echo "Error: The argument should be either 'true' or 'false'"
  exit 1
fi

# Gradle properties file
FILE="example/android/gradle.properties"

# Create a backup of the original file
# cp ${FILE} ${FILE}.bak

# Use 'sed' to replace the property value
sed -i '' -e "s/${PROPERTY}=.*/${PROPERTY}=${NEW_VALUE}/" ${FILE}

if [[ $POD == 'true' ]]; then
  if [[ $NEW_VALUE == 'true' ]]; then
    yarn pod:new
  else
    yarn pod:old
  fi
fi



