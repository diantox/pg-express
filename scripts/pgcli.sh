#!/bin/bash

# Constants --------------------------------------------------------------------
DOCKER_FILE=`realpath ./dockerfiles/pgcli.Dockerfile`
DOCKER_IMAGE_NAME='pg-express-pgcli'
DOCKER_IMAGE_TAG=`cat ./package.json | jq -r .version`

# Variables --------------------------------------------------------------------
DOCKER_NETWORK=''

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
  print "  -b Build a pgcli image."
  print "  -v <VPN_CONTAINER_NAME> Use a VPN."
  print "  -r <postgres|pgbouncer|ENV_FILE_NAME> Run a pgcli container."
}

build() {
  docker image inspect "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" > /dev/null 2>&1 \
    || docker rmi "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"

  print "Building a new ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} image..."
  docker build --tag="${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" - < "${DOCKER_FILE}"
}

useVpn() {
  DOCKER_NETWORK="--network=container:${1}"
}

run() {
  docker run \
    --env-file=`realpath ./envs/"${1}".env` \
    --interactive \
    --rm \
    --tty \
    $DOCKER_NETWORK \
    "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
    -c '$HOME/.local/bin/pgcli postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB'
}

while getopts 'hbv:r:' OPT; do
  case "${OPT}" in
    h)
      help
      ;;
    b)
      build
      ;;
    v)
      useVpn "${OPTARG}"
      ;;
    r)
      run "${OPTARG}"
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
