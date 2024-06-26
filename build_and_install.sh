#! /bin/bash

# TODO: convert to ansible module later

set -euo pipefail
set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pacman_package_name=$1
echo "Package name: $pacman_package_name"
pushd $SCRIPT_DIR/${pacman_package_name}

build_package_ver=$( ( source PKGBUILD; echo $pkgver-$pkgrel ) )
installed_package_ver=$(pacman -Qim $pacman_package_name  | grep Version | awk -F':' '{print $2}' | awk '{print $1}') || true

if [[ $build_package_ver == $installed_package_ver ]]; then
    echo "Package is already installed."
    exit 0
fi
echo "Building package..."
makepkg -f
echo "Installing package..."
sudo pacman -U ${pacman_package_name}*.pkg.tar.zst --noconfirm --ask 4
