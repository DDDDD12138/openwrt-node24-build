#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENWRT_BRANCH="${OPENWRT_BRANCH:-openwrt-24.10}"
OPENWRT_REPO="${OPENWRT_REPO:-https://github.com/openwrt/openwrt.git}"
OPENWRT_SRC_DIR="${OPENWRT_SRC_DIR:-$ROOT_DIR/work/openwrt-src}"
OPENWRT_DL_DIR="${OPENWRT_DL_DIR:-$ROOT_DIR/work/dl}"
PACKAGES_FEED_REPO="${PACKAGES_FEED_REPO:-https://github.com/openwrt/packages.git}"
CONFIG_FILE="${CONFIG_FILE:-$ROOT_DIR/openwrt/configs/rockchip-armv8-node24.config}"

rm -rf "$OPENWRT_SRC_DIR"
mkdir -p "$OPENWRT_DL_DIR"
git clone --depth 1 --branch "$OPENWRT_BRANCH" "$OPENWRT_REPO" "$OPENWRT_SRC_DIR"

sed -i \
  "s#https://git.openwrt.org/feed/packages.git;${OPENWRT_BRANCH}#${PACKAGES_FEED_REPO};${OPENWRT_BRANCH}#" \
  "$OPENWRT_SRC_DIR/feeds.conf.default"

pushd "$OPENWRT_SRC_DIR" >/dev/null
./scripts/feeds update -a
./scripts/feeds install -a

rm -f tools/gnulib/patches/000-bootstrap.patch
rm -rf package/lang/node24
mkdir -p package/lang
cp -a "$ROOT_DIR/openwrt/package/lang/node24" package/lang/

cp "$CONFIG_FILE" .config
printf '\nCONFIG_DOWNLOAD_FOLDER="%s"\n' "$OPENWRT_DL_DIR" >> .config
make defconfig
popd >/dev/null
