#!/usr/bin/env bash


# Abort on any error
set -e -u

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh
source libs/docker.sh

# Check access to docker daemon
assert_dependency "docker"
if ! docker version &> /dev/null; then
	echo "Docker daemon is not running or you have unsufficient permissions!"
	exit -1
fi

APP_NAME="php-fpm-mkl"
IMG_NAME="hetsh/$APP_NAME"
docker build --tag "$IMG_NAME" --tag "$IMG_NAME:$(git describe --tags --abbrev=0)" .

# Start the test
case "${1-}" in
	"--test")
		docker run \
		--rm \
		--tty \
		--interactive \
		--publish 9000:9000/tcp \
		--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
		--name "$APP_NAME" \
		"$IMG_NAME"
	;;
	"--upload")
		if ! tag_exists "$IMG_NAME"; then
			docker push "$IMG_NAME"
		fi
	;;
esac
