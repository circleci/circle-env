function as_user() {
    sudo -H -u ${CIRCLECI_USER} $@
}

function add_path() {
    local PATH=$1

    echo "export PATH=$PATH:"'$PATH' >> $CIRCLECI_RC
}

function append_rc() {
    echo "export $1" >> $CIRCLECI_RC
}

function load_rc() {
    source $CIRCLECI_RC
}

function use_precompile() {
    local PKG=$1

    [ -n "$USE_PRECOMPILE" ] && type -t install_${PKG}_precompile >/dev/null
}

function circle-downloads() {
    echo "https://s3-external-1.amazonaws.com/circle-downloads"
}

function install_deb_force() {
    local pkg=$1
    sudo dpkg -i $pkg || sudo apt-get -y -f install
}

function install_remote_deb() {
    local pkg=$1
    local base_url="https://s3-external-1.amazonaws.com/circle-downloads"
    local remote_deb="$base_url/$pkg"

    pushd /tmp
    wget $remote_deb
    install_deb_force $pkg
    rm $pkg
    popd
}
