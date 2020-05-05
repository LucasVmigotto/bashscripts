#!/usr/bin/env bash

set -eo pipefail

[[ "${TRACE:-0}" == 1 ]] && set -x

# shellcheck disable=SC1091
readonly DISTRO=$(. /etc/os-release && echo "$ID_LIKE")
readonly COLOR_ERROR="\033[0;31m"
readonly COLOR_SUCCESS="\033[0;32m"
readonly NO_COLOR="\033[0m"
readonly VSCODE_URL="https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable"
readonly DIRECTORY="/tmp/code.deb"
readonly SUB="    |_"
readonly CRR_USER=$(whoami)

success() {

    local message="${1:-Sucess}"

    echo -e "${COLOR_SUCCESS}$message${NO_COLOR}"

}

error() {

    local message="${1:-Error}"

    echo -e "${COLOR_ERROR}$message${NO_COLOR}"

}

download_vscode () {
  
    echo "==> Downloading VSCode"

    echo "$SUB Downloadin into $DIRECTORY"

    echo -e "\n"

    curl -L -o "$DIRECTORY" "$VSCODE_URL"

    echo -e "\n"

    if [[ -f "$DIRECTORY" ]]; then

        success "$SUB VSCode downloaded"

    else

        error "$SUB Error downloading VSCode"

    fi
  
}

install_vscode () {
  
    echo "==> Installing VSCode"

    dpkg -i -E "$DIRECTORY"

    if [[ $(which code) ]]; then

        success "$SUB VSCode Installed"

        echo "$SUB removing $DIRECTORY"

        rm -rf "$DIRECTORY"

        if [[ -f "$DIRECTORY" ]]; then

            error "$SUB Error removing $DIRECTORY"

        else

            success

        fi

    else

        error "$SUB Error installing VSCode"

    fi

}

main() {

	echo -e "\n=> VSCode"

	if [[ "$DISTRO" == "debian" ]]; then
		
        download_vscode

        install_vscode

		end

		exit 0

	else
		
        echo -e "==> ${COLOR_ERROR}System not distribution .deb${NO_COLOR}"

		end

		exit 1

	fi
}

if [[ "$UID" -ne "$ROOT_UID" ]]; then
  
  error "=> You must run this command as root"
  
  exit $ERROR_NOTROOT

fi

main $@
