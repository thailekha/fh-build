#!/bin/bash

function template () {
  # Find out Node version => choose appropriate docker build-image
  nodeversion=`node -v`

  if [[ $nodeversion == "v6"* ]]
  then
    buildimage="registry.access.redhat.com/rhscl/nodejs-6-rhel7"
  elif [[ $nodeversion == "v4"* ]]
  then
    buildimage="registry.access.redhat.com/rhscl/nodejs-4-rhel7"
  else
    buildimage="registry.access.redhat.com/openshift3/nodejs-010-rhel7"
  fi
  
  # npm installation
  npm install -g npm@2.13.5
  
  # grunt installation
  npm install -g grunt-cli
  
  # fh-npm dependency installation
  npm install -g fh-npm@0.0.9-41
  
  # fh-npm build test
  fhnpm="`which node` `which npm`"
  fhnpm_install="install --production --strict-ssl=false --cache=$HOME/.fh-npm/fhnpm_install_cache"
  fhnpm_cache="$HOME/.fh-npm/fhnpm_cache"
  dynodir=`pwd`
  fh-npm --npm="$fhnpm" --install="$fhnpm_install" --dir="$dynodir" --cache="$fhnpm_cache"
  
  # s2i dependencies installation
  sudo apt-get install golang -y
  curl -L https://github.com/openshift/source-to-image/releases/download/v1.0.9/source-to-image-v1.0.9-f9ff77d-linux-amd64.tar.gz | tar -xz
  
  # s2i build test
  ./s2i build . $buildimage build_test
}

if [[ -z $1 ]]
then
  echo "Please specify a component type."
  exit 1
fi

if [[ `type -t $1` != function ]]
then
  echo "Build function for '$1' is not defined"
  exit 1
else
  echo "Running a build for the '$1'"
  $1
fi
