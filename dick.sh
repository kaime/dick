#!/bin/bash

VERSION='0.2.0'

is_numeric() {
  echo "$1" | grep -E "^[0-9]+$"
}

dick_usage() {
  echo "
  Usage: dick [<length>] [options]

  Options:

     -b, --big               Change dick format to a bigger one.
     -l, --length [<length>] Set dick length, in characters. Default is 5, a
                             moderate dick length. It must be an integer,
                             positive number (some dignity applies).
     -s, --sperm [<length>]  Display sperm stream with given <length>, in
                             characters. Default is 3. Omit this option or set
                             it to 0 to output no sperm at all.
     -n                      Do not echo trailing newline.
     -v, --version           Display dick version.
     -h, --help              Display this help information.
  "
}

LENGTH=5
SPERM=0
LAST_OPT="-l"
NEW_LINE=1
BIG=0

while [ "$1" != "" ]; do
  OPT=`printf '%q' "$1" | awk -F= '{print $1}'`
  VAL=`printf '%q' "$1" | awk -F= '{print $2}'`

  case $OPT in
    -h | --help)
      dick_usage
      exit
      ;;
    -v | --version)
      echo "dick $VERSION"
      exit
      ;;
    -b | --big)
      BIG=1
      ;;
    -n)
      NEW_LINE=""
      ;;
    -s | --sperm)
      if [[ "$VAL" == "" ]]; then
        SPERM=3
        LAST_OPT="-s"
      else
        SPERM=$VAL
      fi
      ;;
    -l | --length)
      if [[ "$VAL" == "" ]]; then
        LAST_OPT="-l"
      else
        LENGTH=$VAL
      fi
      ;;
    *)
      case $LAST_OPT in
        -s)
          SPERM=$OPT
          ;;
        -l)
          LENGTH=$OPT
          ;;
        *)
          printf "Unexpected argument: '%q'\n" "$OPT"
          dick_usage
          exit 1
          ;;
      esac
      LAST_OPT=""
  esac

  shift

done

LENGTH_IS_NUMERIC=`is_numeric $LENGTH`

if [[ $LENGTH_IS_NUMERIC != "" ]]; then

  if [[ "$LENGTH" -lt 1 ]]; then
    echo "Underestimated 'length' argument"
    dick_usage
    exit 1
  fi

else
  echo "Bad 'length' argument: $LENGTH is not an integer, positive number"
  dick_usage
  exit 1
fi

SPERM_IS_NUMERIC=`is_numeric $SPERM`

if [[ $SPERM_IS_NUMERIC == "" ]]; then
  echo "Bad 'sperm' length: $SPERM is not an integer, positive number"
  dick_usage
  exit 1
fi

if
[[ $BIG == "0" ]]; then
  DICK="8`seq 1 $LENGTH | sed 's/.*/=/' | tr -d '\n'`D"
  if [[ $SPERM != "0" ]]; then
  DICK="$DICK `seq 1 $SPERM | sed 's/.*/~/' | tr -d '\n'`"
  fi
else

  if [[ $SPERM != "0" ]]; then
    DICK=" 
   ____
  /    \_`seq 1 $LENGTH | sed 's/.*/_/' | tr -d '\n'`____
  \___   `seq 1 $LENGTH | sed 's/.*/ /' | tr -d '\n'`|  _\ `seq 1 $SPERM | sed 's/.*/_ /' | tr -d '\n'`
  /     _`seq 1 $LENGTH | sed 's/.*/_/' | tr -d '\n'`|___/
  \____/

  "
  else
    DICK=" 
   ____
  /    \_`seq 1 $LENGTH | sed 's/.*/_/' | tr -d '\n'`____
  \___   `seq 1 $LENGTH | sed 's/.*/ /' | tr -d '\n'`|  _\ 
  /     _`seq 1 $LENGTH | sed 's/.*/_/' | tr -d '\n'`|___/
  \____/

  "
  fi
fi


echo -n "$DICK"

if [[ $NEW_LINE != "" ]]; then
  echo
fi
