function install_google-chrome() {
    local default_version="50"
    local version=$1
    local pkg="google-chrome.deb"

    [[ -n $version ]] || local version=$default_version

    case "$version" in
	"50" ) local download_url="$(circle-downloads)/google-chrome-stable_50.0.2661.94-1_amd64.deb" ;;
	"49" ) local download_url="$(circle-downloads)/google-chrome-stable_49.0.2623.87-1_amd64.deb" ;;
	* ) echo "unknown version: $version"; exit 1 ;;
    esac

    echo '>>> Installing Chrome'

    pushd /tmp
    curl -L -o $pkg $download_url
    install_deb_force $pkg
    sudo sed -i 's|HERE/chrome\"|HERE/chrome\" --disable-setuid-sandbox|g' /opt/google/chrome/google-chrome
    rm $pkg
    popd
}

function install_chromedriver() {
    local version="2.12"
    curl -L -o /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/${version}/chromedriver_linux64.zip
    unzip -p /tmp/chromedriver.zip > /usr/local/bin/chromedriver
    chmod +x /usr/local/bin/chromedriver
    rm -rf /tmp/chromedriver.zip
}

function install_chrome() {
    install_google_chrome
    install_chromedriver
}
