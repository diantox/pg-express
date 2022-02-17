#!/bin/bash

# Constants --------------------------------------------------------------------
DOCKER_IMAGE_NAME='postgres'
DOCKER_IMAGE_TAG='14-bullseye'
DOCKER_CONTAINER_NAME='pg-express-postgres'

# Utility Functions ------------------------------------------------------------

# Usage: print message
print() {
  printf "${1}\n"
}

# Usage: warning warning_message
warning() {
  printf "\e[33m${1}\e[m\n"
}

# Usage: error error_message
error() {
  printf "\e[31m${1}\e[m\n"
}

# Main Functions ---------------------------------------------------------------
help() {
  print "Usage: `basename ${0}` [options]"
  print "  -h Display help."
  print "  -s Stop a Postgres container."
  print "  -r Run a Postgres container."
  print "  -a <postgres|bash> Attach to a Postgres container."
}

stop() {
  docker stop "${DOCKER_CONTAINER_NAME}"
}

run() {
  docker run \
    --detach \
    --env-file=`realpath ./envs/postgres.env` \
    --interactive \
    --name "${DOCKER_CONTAINER_NAME}" \
    --publish 5432:5432 \
    --rm \
    --tty \
    --volume `realpath ./postgres/initdb`:/docker-entrypoint-initdb.d \
    --volume `realpath ./postgres/configs`:/var/lib/postgresql/config \
    --volume `realpath ./postgres/data`:/var/lib/postgresql/data \
    --volume `realpath ./pgbouncer/configs`:/var/lib/pgbouncer/config \
    "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
    -c 'config_file=/var/lib/postgresql/config/postgresql.conf'
}

attachPostgres() {
  docker attach "${DOCKER_CONTAINER_NAME}"
}

attachBash() {
  docker exec \
    --interactive \
    --tty \
    "${DOCKER_CONTAINER_NAME}" \
    bash
}

while getopts 'hsra:' OPT; do
  case "${OPT}" in
    h)
      help
      ;;
    s)
      stop
      ;;
    r)
      run
      ;;
    a)
      if [[ "${OPTARG}" == 'postgres' ]]; then
        attachPostgres
      elif [[ "${OPTARG}" == 'bash' ]]; then
        attachBash
      else
        help
        exit 128
      fi
      ;;
    *)
      help
      exit 128
      ;;
  esac
done

if [[ -z "${1}" ]]; then
  help
  exit 128
fi
