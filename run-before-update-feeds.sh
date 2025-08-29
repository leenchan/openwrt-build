#!/bin/sh

git clone https://github.com/gdy666/luci-app-lucky.git package/lucky
git clone https://github.com/sbwml/luci-app-openlist2 package/openlist2
git clone --recurse-submodules https://github.com/leenchan/openwrt-package-custom.git package/custom && \
	git -C package/custom submodule update --remote
# Fix compile quickfile for aarch64
[ -f ./package/custom/quickfile/quickfile/Makefile ] && sed -Ei "s|.*ARCH_PACKAGES.*|ifeq (\$(ARCH),aarch64)\n	\$(INSTALL_BIN) \$(PKG_BUILD_DIR)/quickfile-aarch64_generic \$(1)/usr/bin/quickfile\nelse\n	\$(INSTALL_BIN) \$(PKG_BUILD_DIR)/quickfile-\$(TARGET_ARCH) \$(1)/usr/bin/quickfile\nendif|g" ./package/custom/quickfile/quickfile/Makefile
