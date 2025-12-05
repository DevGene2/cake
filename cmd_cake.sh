#!/bin/bash
# this is a user built-in command which overrides 'cat' command
# the usual cat command corrupts the console and switches the keyboard layout and prompt.
# this is a fixed version which let the user know that file is not a ASCII text file and suggests the alternate file readers

warning() {
  echo -e "\033[38;5;11mWARNING\033[0m: $1 is a $2 file, use hexdump -C or xxd to view file content."
  read -p "do you want to proceed anyway [y/N]: " in
  if [[ "$in" == 'y' ]] || [[ "$in" == 'Y' ]]
  then
    command cat $FILE
    command fix
  elif [[ "$in" == "" ]] || [[ "$in" == 'n' ]] || [[ "$in" == 'N' ]]
  then
    :
  else
    echo -e "\033[38;5;9mERROR\033[0m: invalid user input!"
    return 1
    break
  fi
}


cake() {
  local __in__
  for FILE in "$@"
  do
    if [ -f "$FILE" ]
    then
      if file "$FILE" | grep -q 'symbolic'
      then
        warning "$FILE" "symbolic"
      elif file "$FILE" | grep -q 'binary'
      then
        warning "$FILE" "binary"
      elif file "$FILE" | grep -q -i "eas 64 bit lsb executable"
      then
        warning "$FILE" "encrypted"
      else
        if [ $# -gt 1 ]
        then
          echo -e "\033[38;5;99m${FILE}>>>\033[0m"
        fi
        command cat "$FILE"
      fi
    else
      echo -e "\033[38;5;9mERROR\033[0m: failed to open file ${FILE}, no such file or directory!" 
    fi
  done
}
