#!/bin/sh

export GIT_URL=$1
export REF_NAME=$2

if [ -z "$GIT_URL" ]; then
    echo "GIT_URL not defined"
fi

if [ -z "$REF_NAME" ]; then
    echo "REF_NAME not defined"
fi

IMAGE_NAME=nunux/$REF_NAME

echo "Building $IMAGE_NAME ..."

# Check that we've a valid working directory.
if [ ! -d "$APP_WORKING_DIR" ]; then
    echo "Error, APP_WORKING_DIR not found"
    exit 1
fi

# Check that the deploy key is valid.
export DEPLOY_KEY=/root/.ssh/id_rsa
if [ ! -f "$DEPLOY_KEY" ]; then
    echo "Error, DEPLOY_KEY not found"
    exit 1
fi

# Remove old repository if exist
rm -rf $APP_WORKING_DIR/$REF_NAME

# Clone repository
ssh-agent bash -c 'ssh-add ${DEPLOY_KEY}; git clone --depth 1 ${GIT_URL} ${APP_WORKING_DIR}/${REF_NAME}'
if [ $? != 0 ]; then
    echo "Error, unable to clone repository"
    exit 1
fi

# Build Dockerfile
docker build --rm -t $IMAGE_NAME $APP_WORKING_DIR/${REF_NAME}
if [ $? != 0 ]; then
    echo "Error, unable to build Docker image"
    exit 1
fi

echo "Build complete!"
exit 0

