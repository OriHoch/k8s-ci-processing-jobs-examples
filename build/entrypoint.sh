#!/usr/bin/env bash

if [ "${1}" == "--list" ]; then
  exec go tool dist list
else
  export GOOS="$(echo "${1}" | cut -d"/" -f1)"
  export GOARCH="$(echo "${1}" | cut -d"/" -f2)"
  exec go build -o "bin/main-${GOOS}-${GOARCH}" src/main.go
fi
