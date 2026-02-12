#!/bin/bash
set -e

# Script ki directory nikalna
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# version.env file se VERSION_TAG load karein
if [ -f "$SCRIPT_DIR/version.env" ]; then
    source "$SCRIPT_DIR/version.env"
fi

# Agar tag nahi mila toh default latest (safety check)
VERSION_TAG=${VERSION_TAG:-latest}

echo "Deploying version: $VERSION_TAG"

# Purana container saaf karein
docker rm -f online-shop-app || true

# Versioned image pull karein
docker pull saadgeeus/app-online-shop:$VERSION_TAG

# Container run karein
docker run -d --name online-shop-app -p 5173:5173 saadgeeus/app-online-shop:$VERSION_TAG

# Purani images clean karein taake disk full na ho
docker image prune -f
