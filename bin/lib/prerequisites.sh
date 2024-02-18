#!/bin/bash

# test for necessary commands
if ! which yq > /dev/null 2>&1; then
  (>&2 echo "yq not found. Please install yq")
  if [ "$(uname)" == "Darwin" ]; then
    (>&2 echo "  brew install yq")
  fi

  exit 1
fi
