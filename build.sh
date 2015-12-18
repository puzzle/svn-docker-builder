#!/bin/bash
set -o pipefail
#IFS=$'\n\t'

DOCKER_SOCKET=/var/run/docker.sock

if [ ! -e "${DOCKER_SOCKET}" ]; then
  echo "Docker socket missing at ${DOCKER_SOCKET}"
  exit 1
fi

if [ -n "${OUTPUT_IMAGE}" ]; then
  TAG="${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}"
fi

BUILD_DIR=$(mktemp --directory --suffix=docker-build)
pushd "${BUILD_DIR}"

if [ -e /etc/secret-volume/.subversion ]; then
  cp -r /etc/secret-volume/.subversion $HOME
fi

svn checkout "${SOURCE_REPOSITORY}" .

echo -e ".d2i" >> .dockerignore

popd

if [ -x "${BUILD_DIR}/.d2i/pre_build" ]; then
  "${BUILD_DIR}/.d2i/pre_build" "$BUILD_DIR" "$TAG"
fi

docker build --rm -t "${TAG}" -f "${DOCKERFILE:-Dockerfile}"  "${BUILD_DIR}"

if [[ -d /var/run/secrets/openshift.io/push ]] && [[ ! -e /root/.dockercfg ]]; then
  cp /var/run/secrets/openshift.io/push/.dockercfg /root/.dockercfg
fi

if [ -n "${OUTPUT_IMAGE}" ] || [ -s "/root/.dockercfg" ]; then
  docker push "${TAG}"

  if [ -x "${BUILD_DIR}/.d2i/post_build" ]; then
    "${BUILD_DIR}/.d2i/post_build" "$BUILD_DIR" "$TAG"
  fi
fi
