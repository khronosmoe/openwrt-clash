include $(TOPDIR)/rules.mk

PKG_NAME:=clash-premium
PKG_VERSION:=2022.08.26
PKG_ARCH:=armv8

PKG_SOURCE_URL:=https://github.com/Dreamacro/clash/releases/download/premium
PKG_SOURCE:=clash-linux-$(PKG_ARCH)-$(PKG_VERSION).gz
PKG_HASH:=c38651ac715e8d719481043f378e80a957bff3e068e72d7346403da7538c405d

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SUBMENU:=Clash
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Pre-built Clash premium binary
  URL:=https://github.com/Dreamacro/clash
  DEPENDS:=+iptables-mod-tproxy +iptables-mod-extra +iptables-mod-nat-extra
endef

define Package/$(PKG_NAME)/description
  Pre-built Clash premium binary
endef

define Build/Prepare
	gzip -dc "$(DL_DIR)/$(PKG_SOURCE)" > "$(PKG_BUILD_DIR)/clash-linux-$(PKG_ARCH)"
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/clash-linux-$(PKG_ARCH) $(1)/usr/bin/clash
	
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) $(CURDIR)/files/clash.init $(1)/etc/init.d/clash
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
