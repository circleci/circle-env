#!/bin/bash

function install_circle_env() {
  distro=$(lsb_release -c | awk '{print $2}')
  url="https://s3-external-1.amazonaws.com/circle-downloads/circle-env-$distro"
  pkg_dir=/opt/circleci
  bin_dir="$pkg_dir/bin"
  bin="$bin_dir/circle-env"

  sudo mkdir -p $bin_dir
  sudo curl -L -o $bin $url
  sudo chmod +x $bin

  # Remove this once the path is added to precise image
  echo "PATH=$bin_dir:"'$PATH' >> /home/ubuntu/.circlerc
}

install_circle_env
