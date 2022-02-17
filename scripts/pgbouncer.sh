#!/bin/bash

# Constants --------------------------------------------------------------------
DOCKER_FILE=`realpath ./dockerfiles/pgbouncer.Dockerfile`
DOCKER_IMAGE_NAME='pg-express-pgbouncer'
DOCKER_IMAGE_TAG=`cat ./package.json | jq -r .version`
DOCKER_CONTAINER_NAME="${DOCKER_IMAGE_NAME}"

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
  print "  -b Build a PgBouncer image."
  print "  -s Stop a PgBouncer container."
  print "  -r Run a PgBouncer container."
  print "  -a <pgbouncer|bash> Attach to a PgBouncer container."
}

build() {
  docker image inspect "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" > /dev/null 2>&1 \
    || docker rmi "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"

  print "Building a new ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} image..."
  docker build --tag="${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" - < "${DOCKER_FILE}"
}

stop() {
  docker stop "${DOCKER_CONTAINER_NAME}"
}

run() {
  docker run \
    --interactive \
    --name "${DOCKER_CONTAINER_NAME}" \
    --publish 6432:6432 \
    --rm \
    --tty \
    --volume `realpath ./`:/opt/pg-express \
    "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
    -c 'pgbouncer ./pgbouncer/configs/pgbouncer.ini'
}

attachPgBouncer() {
  docker attach "${DOCKER_CONTAINER_NAME}"
}

attachBash() {
  docker exec \
    --interactive \
    --tty \
    "${DOCKER_CONTAINER_NAME}" \
    bash
}

while getopts 'hbsra:' OPT; do
  case "${OPT}" in
    h)
      help
      ;;
    b)
      build
      ;;
    s)
      stop
      ;;
    r)
      run
      ;;
    a)
      if [[ "${OPTARG}" == 'pgbouncer' ]]; then
        attachPgBouncer
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
