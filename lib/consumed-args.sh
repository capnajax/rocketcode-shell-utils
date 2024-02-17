#!/bin/bash

function argConsumed {
  if [ -z "${consumedArgs}" ]; then
    consumedArgs=$1
  else
    consumedArgs="${consumedArgs} $1"
  fi
}

function isArgConsumed {
  for arg in ${consumedArgs}; do
    if [ "$1" == "$arg" ]; then
      return 0
    fi
  done
  return 1
}

function unconsumedArgs {
  for arg in $@; do
    if ! isArgConsumed $arg; then
      echo $arg
    fi
  done
}

isHelp=false
isVerbose=false
isQuiet=false
isTTY=false
command=''
subCommand=''

function globalArgs {
  local hasSubCommand=$1 # true if command is expecting a subcommand
  shift
  for arg in $(unconsumedArgs $@); do
    case $arg in
    --help)
      isHelp=true
      argConsumed $arg
      ;;
    --quiet)
      isQuiet=true
      argConsumed $arg
      ;;
    --tty)
      isTTY=true
      argConsumed $arg
      ;;
    --verbose)
      isVerbose=true
      argConsumed $arg
      ;;
    *)
      if [ "${arg:0:1}" != '-' ]; then
        if [ -z "$command" ]; then
          command=$arg
          argConsumed $arg
        elif ${hasSubCommand} && [ -z "$subCommand" ]; then
          subCommand=$arg
          argConsumed $arg
        fi
      fi
    esac
  done
}
