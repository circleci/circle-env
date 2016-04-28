#!/bin/bash

[ "$DEBUG" ] && set -x

set -eo pipefail -o errtrace

dir=$(cd $(dirname $BASH_SOURCE); pwd)
supported_distros=(precise trusty)
src_dir="$dir/src"
lib_dir="$src_dir/lib"
main_script="$src_dir/circle-env"
dist_dir="$dir/dist"
dist_base="$dist_dir/circle-env"
scripts_path_base="$dir/src/scripts"
version=$(git rev-parse HEAD)

precise_scripts=(
    "common/chrome.sh"
)

trusty_scripts=(
    "trusty/android-ndk.sh"
    "trusty/android-sdk.sh"
    "trusty/awscli.sh"
    "trusty/base.sh"
    "trusty/casperjs.sh"
    "trusty/circleci-specific.sh"
    "trusty/clojure.sh"
    "trusty/docker.sh"
    "trusty/firefox.sh"
    "trusty/go.sh"
    "trusty/heroku.sh"
    "trusty/java.sh"
    "trusty/misc.sh"
    "trusty/mongo.sh"
    "trusty/mysql.sh"
    "trusty/nodejs.sh"
    "trusty/phantomjs.sh"
    "trusty/php.sh"
    "trusty/postgres.sh"
    "trusty/python.sh"
    "trusty/qt.sh"
    "trusty/ruby.sh"
    "trusty/scala.sh"
    "common/chrome.sh"
)

compile() {
    local distro=$1

    case "$distro" in
	"precise" ) local scripts=${precise_scripts[@]} ;;
	"trusty"  ) local scripts=${trusty_scripts[@]} ;;
	* ) echo "unknown distro: $distro"; exit 1 ;;
    esac

    target=$dist_base-$distro

    cat <<'EOF' >> $target
#!/bin/bash
#
# circle-env: Installing what you want on CircleCI on the fly!
#
EOF

    cat <<EOF >> $target
# Version: $version
# Distro: $distro
#
EOF

    cat $main_script >> $target
    cat $lib_dir/helper.sh >> $target

    for s in ${scripts[@]}; do
	scripts_path=$scripts_path_base/$s
	echo "compiling: $scripts_path -> $target"
	cat $scripts_path >> $target
    done

    cat <<'EOF' >> $target
main "$@"
EOF

    chmod +x $target
}

rm -rf $dist_dir
mkdir -p $dist_dir

compile "trusty"
compile "precise"
