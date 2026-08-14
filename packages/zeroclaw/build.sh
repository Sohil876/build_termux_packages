TERMUX_PKG_HOMEPAGE="https://github.com/zeroclaw-labs/zeroclaw"
TERMUX_PKG_DESCRIPTION="Fast, small, and fully autonomous AI personal assistant infrastructure"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@Sohil876"

# These placeholders are dynamically overwritten by the workflow
TERMUX_PKG_VERSION="0.0.0"
TERMUX_PKG_SRCURL="https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="0000000000000000000000000000000000000000000000000000000000000000"

# Add any other runtime dependencies ZeroClaw needs here
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --release --target $CARGO_TARGET_NAME
}

termux_step_make_install() {
	install -Dm700 target/${CARGO_TARGET_NAME}/release/zeroclaw "$TERMUX_PREFIX/bin/zeroclaw"
}
