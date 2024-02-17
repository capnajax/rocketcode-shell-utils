#!/bin/bash

function max {
  local max=$1
  shift
  for n in $@; do
    if [ $n -gt $max ]; then
      max=$n
    fi
  done
  echo $max
}
