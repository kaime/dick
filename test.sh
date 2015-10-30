#!/bin/bash

# http://www.cyberciti.biz/tips/how-do-i-find-out-what-shell-im-using.html
SHELL=`ps -hp $$ | awk '{print $5}'`

ok() {
  echo -e " \e[32m√\e[0m"
}

fail() {
  echo -e " \e[31mFail!\e[0m"
  echo "$1"
}

test_output() {
  COMMAND="dick"
  if [[ "$1" != "" ]]; then
    COMMAND="$COMMAND $1"
  fi

  DICK="`dick $1`"
  EXPECTED="$2"

  echo -ne " - '\e[1m$COMMAND\e[0m' should output '\e[1m$EXPECTED\e[0m'"

  if [[ "$?" != 0 ]]; then
    fail "'$COMMAND' exit status was $?."
    exit 1
  fi

  if [[ $DICK != $EXPECTED ]]; then
    fail "Expected '$2', but got '$DICK'."
    exit 1
  fi
  ok
}

test_fails() {
  COMMAND="dick $1"

  echo -ne " - '\e[1m$COMMAND\e[0m' should fail"

  $COMMAND > /dev/null

  if [[ $? == "0" ]]; then
    fail "$COMMAND should have failed, but it didn't."
    exit 1
  fi

  ok
}

echo -e "Testing \e[1mdick\e[0m with \e[1m$SHELL\e[0m"

test_output "" "8=====D"
test_output "10" "8==========D"
test_output "1" "8=D"
test_output "--length=2 -s" "8==D ~~~"
test_output "-l  2 -s=1" "8==D ~"
test_output "4 -s 1" "8====D ~"
test_output "-l --sperm=5" "8=====D ~~~~~"
test_output "12 -s 10" "8============D ~~~~~~~~~~"
test_output "-l 12 --sperm 0" "8============D"

test_fails '-p'
test_fails '-q'
test_fails '--length --s'
test_fails '--l'
test_fails '--len'
test_fails '0'
test_fails 'bar'
test_fails '-l 0'
test_fails '-l none'
test_fails '--length=0'
test_fails '--length 00'
test_fails '--length -1'
test_fails '--length "0.1"'
test_fails '--length ".01"'
test_fails '--length -2.76'
test_fails '-s -1'
test_fails '--sperm 1.2'
test_fails '--sperm=0.7'
test_fails '--sperm=foo'
