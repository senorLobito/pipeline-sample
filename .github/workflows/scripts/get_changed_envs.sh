#!/bin/bash

ENVS=("deva" "int", "prs", "pred", "prod")
CHANGED_ENVS=""

OLD_SETUP_FILE=$(git show HEAD~1:deploy_setup.json)
NEW_SETUP_FILE=$(git show HEAD:deploy_setup.json)

for ENV in "${ENVS[@]}"; do
  echo "Checking environment: $ENV"
  if diff <(echo "$OLD_SETUP_FILE" | jq -S ".$ENV") <(echo "$NEW_SETUP_FILE" | jq -S ".$ENV") > /dev/null; then
    echo "No changes detected for $ENV"
  else
    echo "Changes detected for $ENV"
    CHANGED_ENVS="$CHANGED_ENVS $ENV"
  fi
done

echo "$CHANGED_ENVS" >> $GITHUB_ENV