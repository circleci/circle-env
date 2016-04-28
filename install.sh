#!/bin/bash

supported_distros=(precise trusty)
distro=$1
inst_dir="/opt/circleci/bin"

mkdir -p $inst_dir

if ! [[ -n $distro ]]; then
    distro=$(lsb_release -c 2>/dev/null | awk '{print $2}')
fi

for d in "${supported_distros[@]}"; do
    if [[ "$d" -eq "$distro" ]] ; then
	target="dist/circle-env-$distro"

	if [[ -e $target ]]; then
            cp $target $inst_dir/circle-env
	    exit 0
	fi
    fi
done

echo "distro: '$distro' is not supported!"
echo "supported distros: $supported_distros"
