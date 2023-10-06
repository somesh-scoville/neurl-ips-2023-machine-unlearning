#!/usr/bin/env bash
set -Eeuo pipefail
echo "================="
echo "Run docker image"
echo "================="

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..  # Always navigate to project root from anywhere

docker build --tag machine-unlearning:$USER -f docker/local/Dockerfile \
--build-arg GROUP_ID=$(id -g) --build-arg  USER_ID=$(id -u) .

docker run --shm-size=10g --gpus all -it --rm -p 8882:8882 --group-add 1013 \
 --mount type=bind,source="$(pwd)"/.,target=/workspace \
 --name "$USER"_unlearning machine-unlearning:$USER
