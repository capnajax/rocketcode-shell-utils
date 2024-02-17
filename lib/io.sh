#!/bin/bash

#
# Call with $LIB set to this directory
#

source ${LIB}/consumed-args.sh

isColor=false

function ioInit {
  local testingItem=''
  for arg in $(unconsumedArgs $@); do
    case $arg in 
      --color)
        testingItem='color'
        isColor=true
        argConsumed $arg
        ;;
      --color=*)
        testingItem=''
        color=$(echo $arg | sed 's/--color=//')
        isColor=true
        argConsumed $arg
        ;;
      --tty)
        testingItem=''
        isColor=true
        isTTY=true
        ;;
      *)
        if [ -n "$testingItem" ]; then
          case $testingItem in
            color)
              if [ -n "$arg" ]; then
                color=$arg
              fi
              testingItem=''
              ;;
          esac
        fi
    esac
  done
}

