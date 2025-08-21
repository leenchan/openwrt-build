#!/bin/sh

git clone https://github.com/gdy666/luci-app-lucky.git package/lucky
git clone https://github.com/sbwml/luci-app-openlist2 package/openlist2
git clone --recurse-submodules https://github.com/leenchan/openwrt-package-custom.git package/custom && \
  git -C package/custom submodule update --remote
