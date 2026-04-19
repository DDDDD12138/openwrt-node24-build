# openwrt-node24-build

Build private OpenWrt `node24` and `node24-npm` packages from the official OpenWrt source tree with GitHub Actions.

## Scope

This repository keeps only the local package overlay and CI/build scripts.

It does not commit the full OpenWrt source tree. A fresh OpenWrt checkout is created during each build.

## Supported targets

- OpenWrt series: `24.10`
- OpenWrt branch: `openwrt-24.10`
- Package version: `node24 24.14.1`

| Target ID | Board/Subtarget | Package arch | CPU family |
| --- | --- | --- | --- |
| `rockchip-armv8` | `rockchip/armv8` | `aarch64_generic` | `aarch64` |
| `x86-64` | `x86/64` | `x86_64` | `x86_64` |

## Repository layout

- `openwrt/package/lang/node24/`
  Private Node 24 package overlay.
- `openwrt/configs/24.10/*.config`
  One minimal OpenWrt config per supported target.
- `scripts/prepare_openwrt.sh`
  Clones OpenWrt, updates feeds, applies local overlay, and writes config.
- `scripts/build_openwrt_node24.sh`
  Builds tools, toolchain, and the `node24` package.
- `.github/workflows/build-node24.yml`
  GitHub Actions matrix workflow.

## Local build

```bash
export OPENWRT_SERIES=24.10
export OPENWRT_TARGET_ID=x86-64
export OPENWRT_SRC_DIR="$PWD/work/openwrt-src"
./scripts/prepare_openwrt.sh
./scripts/build_openwrt_node24.sh
```

To pick a different target explicitly:

```bash
export CONFIG_FILE="$PWD/openwrt/configs/24.10/rockchip-armv8.config"
```

Artifacts are produced under:

```text
$OPENWRT_SRC_DIR/bin/packages/<target-packages-arch>/base/
```

## Notes

- The build removes the obsolete OpenWrt `tools/gnulib/patches/000-bootstrap.patch` after checkout because it no longer applies cleanly in the tested environment.
- The package overlay already includes the Node 24 patch adjustments needed for this build.
- Node.js 24 treats 32-bit Linux targets as experimental upstream and does not ship official 32-bit release binaries, so this repository only supports 64-bit OpenWrt targets.
- `OPENWRT_TARGET_ID` defaults to `rockchip-armv8`, which keeps the previous single-target behavior for local builds.
