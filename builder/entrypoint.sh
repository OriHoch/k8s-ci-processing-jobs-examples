#!/usr/bin/env bash

if [ "${1}" == "--list" ]; then
  exec go tool dist list
else
  export GOOS="$(echo "${1}" | cut -d"/" -f1)" &&\
  export GOARCH="$(echo "${1}" | cut -d"/" -f2)" &&\
  REPO_USER="${2}" &&\
  TAG="${3}" &&\
  if [ "${GOOS}" == "windows" ]; then EXT=.exe; fi &&\
  echo GOOS=$GOOS GOARCH=$GOARCH REPO_USER=$REPO_USER TAG=$TAG EXT=$EXT &&\
  UPLOAD_URL="$(curl -s -u "${REPO_USER}:${TOKEN}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${REPO_USER}/k8s-ci-processing-jobs-examples/releases/tags/${TAG}" | jq -r .upload_url | cut -d'{' -f1)" &&\
  echo UPLOAD_URL=$UPLOAD_URL &&\
  echo Compiling... &&\
  go build -o bin/main src/main.go &&\
  echo OK &&\
  echo Publishing... &&\
  curl -s -u "${REPO_USER}:${TOKEN}" -X POST -H "Accept: application/vnd.github.v3+json" \
    -H "Content-Type: application/x-executable" --data-binary @bin/main \
    "${UPLOAD_URL}?name=hello-world-${GOOS}-${GOARCH}${EXT}" &&\
  echo OK
fi
