#!/bin/bash

set -e

__consumedArgs=()

function argConsumed {
  __consumedArgs+=($1)
}

function isArgConsumed {
  local testArg=$1
  local consumedArg=''
  for consumedArg in ${__consumedArgs[@]}; do
    if [ "$testArg" == "$consumedArg" ]; then
      return 0
    fi
  done
  return 1
}

function unconsumedArgs {
  local unconsumedArgs=()
  local testArg=''
  for testArg in $@; do
    if ! isArgConsumed $testArg; then
      unconsumedArgs+=($testArg)
    fi
  done
  echo ${unconsumedArgs[@]}
}

isHelp=false
isVerbose=false
isQuiet=false
isTTY=false
command=''
subCommand=''

function globalArgs {
  local hasSubCommand=$1 # true if command is expecting a subcommand
  local unconsumedArg=''
  shift  
  for unconsumedArg in $(unconsumedArgs $@); do
    local doNotConsume=false
    case $unconsumedArg in
    --help)
      isHelp=true
      ;;
    --quiet)
      # if both --verbose and --quiet are set, the last one wins
      isQuiet=true
      isVerbose=false
      ;;
    --tty)
      # allows the use of colour in output
      isTTY=true
      ;;
    --verbose)
      # if both --verbose and --quiet are set, the last one wins
      isVerbose=true
      isQuiet=false
      ;;
    *)
      if [ "${unconsumedArg:0:1}" == '-' ]; then
        doNotConsume=true
      else
        if ${hasSubCommand} && [ -z "$subCommand" ]; then
          subCommand=$unconsumedArg
        else
          doNotConsume=true
        fi
      fi
    esac
    if ! ${doNotConsume}; then
      argConsumed $unconsumedArg
    fi
  done
}
