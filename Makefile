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

define Package/clash-web-yacd
  $(call Package/$(PKG_NAME))
  TITLE:=Yet Another Clash Dashboard
  DEPENDS:=$(PKG_NAME)
endef


define Package/$(PKG_NAME)/description
  Pre-built Clash premium binary
endef

define Package/clash-web-yacd/description
  Yet Another Clash Dashboard
endef


WEB_YACD_VER=v0.3.6
define Download/web-yacd
  FILE:=yacd.tar.xz
  URL:=https://github.com/haishanh/yacd/releases/download/$(WEB_YACD_VER)
  URL_FILE:=yacd.tar.xz
  HASH:=608c7e21c1ee6cfee6268c5a3951a4c21dc407eea67049058cec299c0b11e2fb
endef
$(eval $(call Download,web-yacd))


define Build/Prepare
	gzip -dc "$(DL_DIR)/$(PKG_SOURCE)" > "$(PKG_BUILD_DIR)/clash-linux-$(PKG_ARCH)"
	tar -C "$(PKG_BUILD_DIR)" -Jxvf "$(DL_DIR)/yacd.tar.xz"	
endef

define Build/Compile
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/clash-linux-$(PKG_ARCH) $(1)/usr/bin/clash
	
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) $(CURDIR)/files/clash.init $(1)/etc/init.d/clash
endef

define Package/clash-web-yacd/install
	$(INSTALL_DIR) $(1)/etc/clash/yacd
	$(CP) \
		$(PKG_BUILD_DIR)/public/assets \
		$(PKG_BUILD_DIR)/public/index.html \
		$(PKG_BUILD_DIR)/public/yacd-128.png \
		$(PKG_BUILD_DIR)/public/yacd-64.png \
		$(PKG_BUILD_DIR)/public/yacd.ico \
		$(1)/etc/clash/yacd
endef


$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,clash-web-yacd))
