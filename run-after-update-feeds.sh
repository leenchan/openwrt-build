#!/bin/sh

echo "GITHUB_ENV: $GITHUB_ENV"

install_go() {
	GO_PATH=$(curl -skL 'https://go.dev/dl/' | grep -Eo 'href="/dl/[^"]+"' | sed -E 's/.*"(.*)"/\1/g' | grep 'amd64.*\.tar\.gz'| head -n1)
	[ -z "$GO_PATH" ] || {
		GO_ROOT_DIR="$1/go"
		curl -kL "https://go.dev$GO_PATH" > go.tar.gz && tar -xf go.tar.gz -C $1
		[ -d "$GO_ROOT_DIR/bin" ] && echo "GO_ROOT_DIR=$GO_ROOT_DIR" >> $GITHUB_ENV
	}
}

fix_rust() {
	echo "Fix rust ..."
}

install_go
