# openwrt-node24-build

Build private OpenWrt `node24` and `node24-npm` packages from the official OpenWrt source tree with GitHub Actions.

## Scope

This repository keeps only the local package overlay and CI/build scripts.

It does not commit the full OpenWrt source tree. A fresh OpenWrt checkout is created during each build.

## Current target

- OpenWrt series: `24.10`
- OpenWrt branch: `openwrt-24.10`
- Package version: `node24 24.14.1`
- Target packages arch: `aarch64_generic`
- Target board/subtarget: `rockchip/armv8`

## Repository layout

- `openwrt/package/lang/node24/`
  Private Node 24 package overlay.
- `openwrt/configs/24.10/aarch64_generic.config`
  Minimal OpenWrt config for the only supported target line.
- `scripts/prepare_openwrt.sh`
  Clones OpenWrt, updates feeds, applies local overlay, and writes config.
- `scripts/build_openwrt_node24.sh`
  Builds tools, toolchain, and the `node24` package.
- `.github/workflows/build-node24.yml`
  GitHub Actions workflow.

## Local build

```bash
export OPENWRT_SERIES=24.10
export OPENWRT_PKG_ARCH=aarch64_generic
export OPENWRT_SRC_DIR="$PWD/work/openwrt-src"
./scripts/prepare_openwrt.sh
./scripts/build_openwrt_node24.sh
```

Artifacts are produced under:

```text
$OPENWRT_SRC_DIR/bin/packages/aarch64_generic/base/
```

## Notes

- The build removes the obsolete OpenWrt `tools/gnulib/patches/000-bootstrap.patch` after checkout because it no longer applies cleanly in the tested environment.
- The package overlay already includes the Node 24 patch adjustments needed for this build.
