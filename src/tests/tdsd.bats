#!/usr/bin/env bats
#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

__setup() {
  source ~/.todayrc
}

__rm_if_exists() {
  if [ -d "$PROJECTS/$1" ]; then
    if [ -n "$1"  ]; then
      rm -Rf "$PROJECTS/$1"
    fi
  fi
}

__save_today_and_tasks(){
  if [ ! -e "/tmp/Today" ]; then
    mkdir -p /tmp/Today
  fi

  cp -R "$TODAY/." /tmp/Today/
  cp "$TODO_DIR/todo.txt" /tmp
}

__restore_today_and_tasks(){
  find "$TODAY" -type l -delete
  cp -R /tmp/Today/. "$TODAY/"
  cp /tmp/todo.txt "$TODO_DIR/todo.txt"
  rm -f /tmp/todo.txt
  rm -rf /tmp/Today
}

@test "01 - tdsd" {
  # skip
  __setup
  run things someday > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$SOMEDAY"
}

@test "02 - tdsdl" {
  # skip
  __setup
  run things someday list > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "$SOMEDAY"
  assert_line "$PWD"
}

@test "03 - tdsdi and tdsde" {
  # skip
  __setup
  __rm_if_exists project-test

  #checking sucessful execution
  things projects new project-test > /dev/null
  run things someday start > /dev/null
  [ "$status" -eq 0 ]

  #checking existence project symlink in Someday
  PROJECTDIR=`find "$SOMEDAY" -maxdepth 1 -name "*project-test"`
  [ -n "$PROJECTDIR" ] && readlink "$PROJECTDIR"
  [ "$status" -eq 0 ]

  #checking sucessful execution
  run things someday stop > /dev/null
  [ "$status" -eq 0 ]

  #checking non-existence project symlink in Someday
  PROJECTDIR=`find "$SOMEDAY" -maxdepth 1 -name "*project-test"`
  [ -z "$PROJECTDIR" ]

  __rm_if_exists project-test
}

@test "04 - tdsdi and tdsde <project>" {
  # skip
  __setup
  __rm_if_exists project-test

  #checking sucessful execution
  things projects new project-test > /dev/null
  run things someday start project-test > /dev/null
  [ "$status" -eq 0 ]

  #checking existence project symlink in Someday
  PROJECTDIR=`find "$SOMEDAY" -maxdepth 1 -name "*project-test"`
  [ -n "$PROJECTDIR" ] && readlink "$PROJECTDIR"
  [ "$status" -eq 0 ]

  #checking sucessful execution
  run things someday stop project-test > /dev/null
  [ "$status" -eq 0 ]

  #checking non-existence project symlink in Someday
  PROJECTDIR=`find "$SOMEDAY" -maxdepth 1 -name "*project-test"`
  [ -z "$PROJECTDIR" ]

  __rm_if_exists project-test
}

@test "05 - tdsdi bad number of args" {
  # skip
  __setup

  run things someday start project-test project > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "06 - tdsde bad number of args" {
  # skip
  __setup

  run things someday stop project-test project > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "07 - tdsdi bad arg" {
  # skip
  __setup

  run things someday start project-test > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument"
}

@test "08 - tdsde bad arg" {
  # skip
  __setup

  run things someday stop project-test > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument"
}
