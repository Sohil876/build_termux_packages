# Termux Package Builds

This repository builds custom Termux `.deb` packages using GitHub Actions and the official Termux build environment.

Builds are done with:

- `termux/termux-packages`
- Official `run-docker.sh` builder
- Termux package builder Docker image
- Uploaded GitHub Actions artifacts

## Current Packages

| Package    | Description                                                            | License           | Upstream                                                            |
| ---------- | ---------------------------------------------------------------------- | ----------------- | ------------------------------------------------------------------- |
| `zeroclaw` | Fast, small, and fully autonomous AI personal assistant infrastructure | `Apache-2.0, MIT` | [zeroclaw-labs/zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) |

## Installing Built Packages

Download the artifact for your architecture from GitHub Actions, extract it, then install the `.deb`:

```bash
pkg install ./package_name_*.deb
```

or:

```bash
dpkg -i ./package_name_*.deb
apt --fix-broken install
```

Check your Termux architecture with:

```bash
dpkg --print-architecture
```

Common values:

- `aarch64`
- `arm`

## Building a Package

1. Go to the repository on GitHub.
1. Open **Actions**.
1. Select **Termux package**.
1. Click **Run workflow**.
1. Choose the package to build.
1. Optional:
   - Leave version blank to build the latest stable release.
   - Enter a specific version such as `0.8.4`.
1. Download the artifact after the workflow finishes.

## Adding a New Package

### 1. Create the package directory

For a package named `exampletool`:

```bash
mkdir -p packages/exampletool
```

### 2. Add a `build.sh`

Create:

```text
packages/exampletool/build.sh
```

Example template:

```bash
TERMUX_PKG_HOMEPAGE="https://github.com/OWNER/REPO"
TERMUX_PKG_DESCRIPTION="Short description of the package"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Sohil876"

# These placeholders are dynamically overwritten by the workflow
TERMUX_PKG_VERSION="0.0.0"
TERMUX_PKG_SRCURL="https://github.com/OWNER/REPO/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="0000000000000000000000000000000000000000000000000000000000000000"

# Runtime dependencies
TERMUX_PKG_DEPENDS=""

# Build-time dependencies, if needed
# TERMUX_PKG_BUILD_DEPENDS=""

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    # Replace this with the correct build steps for the project.
    # Rust example:
    termux_setup_rust
    cargo build --release --target "$CARGO_TARGET_NAME"
}

termux_step_make_install() {
    # Replace binary path/name as needed.
    install -Dm700 \
        "target/${CARGO_TARGET_NAME}/release/exampletool" \
        "$TERMUX_PREFIX/bin/exampletool"
}
```

### 3. Use a GitHub homepage URL

For automatic latest-release detection, set:

```bash
TERMUX_PKG_HOMEPAGE="https://github.com/OWNER/REPO"
```

The workflow reads this field to detect the upstream GitHub repository.

If the project is not hosted on GitHub, you may need to handle version/source URLs more manually.

### 4. Add the package to the workflow selector

Open:

```text
.github/workflows/termux-build.yml
```

Add the new package name under:

```yaml
      package:
        description: 'Package to build'
        required: true
        type: choice
        options:
          - zeroclaw
          - exampletool
```

### 5. Update this README

Add the new package to the **Current Packages** table.

### 6. Commit and push

```bash
git add packages/exampletool/build.sh .github/workflows/termux-build.yml README.md
git commit -m "Add exampletool package"
git push
```

## Repository Layout

```text
.github/workflows/termux-build.yml   # GitHub Actions build workflow
packages/                            # Custom Termux package definitions
README.md                            # This file
```

## Notes

- The workflow builds for `aarch64` and `arm`.
- Version field blank means latest stable GitHub release.
- Pre-releases are ignored.
- Dependency `.deb` files may appear in the Termux build output, but only the selected package `.deb` files are uploaded.
- Do not commit generated `.deb` files or Termux build directories.
