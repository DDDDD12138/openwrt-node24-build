#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENWRT_SRC_DIR="${OPENWRT_SRC_DIR:-$ROOT_DIR/work/openwrt-src}"
BUILD_JOBS="${BUILD_JOBS:-$(nproc)}"

pushd "$OPENWRT_SRC_DIR" >/dev/null
# Run the download phase serially. Parallel download can race on shared
# temporary .hash files when multiple targets fetch the same source archive.
make -j1 download V=s
FORCE_UNSAFE_CONFIGURE=1 make -j"$BUILD_JOBS" tools/install V=s
FORCE_UNSAFE_CONFIGURE=1 make -j"$BUILD_JOBS" toolchain/install V=s
make -j"$BUILD_JOBS" package/lang/node24/prepare V=s
make -j"$BUILD_JOBS" package/lang/node24/compile V=s
popd >/dev/null
