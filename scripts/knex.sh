#!/bin/bash

# Constants --------------------------------------------------------------------
DOCKER_FILE=`realpath ./dockerfiles/knex.Dockerfile`
DOCKER_IMAGE_NAME='pg-express-knex'
DOCKER_IMAGE_TAG=`cat ./package.json | jq -r .version`

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
  print "  -b Build a Knex image."
  print "  -i Install npm dependencies."
  print "  -d Rollback all Knex migrations."
  print "  -u Run all Knex migrations."
  print "  -s Run all Knex seeds."
}

build() {
  docker image inspect "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" > /dev/null 2>&1 \
    || docker rmi "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"

  print "Building a new ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} image..."
  docker build --tag="${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" - < "${DOCKER_FILE}"
}

npmInstall() {
  docker run \
    --interactive \
    --rm \
    --tty \
    --volume `realpath ./`:/opt/pg-express \
    "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
    -c 'npm install'
}

knexMigrateRollback() {
  docker run \
    --env-file=`realpath ./envs/postgres.env` \
    --interactive \
    --rm \
    --tty \
    --volume `realpath ./`:/opt/pg-express \
    "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
    -c 'npm run knex:migrate:rollback'
}

knexMigrateLatest() {
  docker run \
    --env-file=`realpath ./envs/postgres.env` \
    --interactive \
    --rm \
    --tty \
    --volume `realpath ./`:/opt/pg-express \
    "$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG" \
    -c 'npm run knex:migrate:latest'
}

knexSeedRun() {
  docker run \
    --env-file=`realpath ./envs/postgres.env` \
    --interactive \
    --rm \
    --tty \
    --volume `realpath ./`:/opt/pg-express \
    "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
    -c 'npm run knex:seed:run'
}

while getopts 'hbidus' OPT; do
  case "${OPT}" in
    h)
      help
      ;;
    b)
      build
      ;;
    i)
      npmInstall
      ;;
    d)
      knexMigrateRollback
      ;;
    u)
      knexMigrateLatest
      ;;
    s)
      knexSeedRun
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
