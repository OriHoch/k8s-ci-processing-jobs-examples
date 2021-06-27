#!/usr/bin/env bash

REDIS_URL="redis://${RQ_REDIS_HOST:-localhost}:${RQ_REDIS_PORT:-6379}/${RQ_REDIS_DB:-5}"

if [ "${1}" == "--rq-info" ]; then
  exec rq info -u "${REDIS_URL}" "${@:2}"
elif [ "${1}" == "--rq-worker" ]; then
  exec rq worker --burst -u "${REDIS_URL}" "${@:2}"
elif [ "${1}" == "--rq-add" ]; then
  exec python3 builder_queue.py "${@:2}"
else
  exec ./entrypoint.sh "$@"
fi
