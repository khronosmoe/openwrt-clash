To make things simple, here you must need a router or firewall as the main gateway. And in this tutorial I will show you steps to make an openwrt device work as transparent proxy gateway by using clash to handle both domestic and global traffic as long as all dns queries.

Manual steps are as follows:

1. Turn off firewall and dnsmasq
2. Delete WAN interface and bridge all LAN ports
3. Download clash-premium binary and optional yacd dashboard
4. Bring your own `config.yaml` and create user `clash` (uid=0 & gid != 0)
5. Make iptables rules persistent


This repository will simplify steps mentioned above but you have to do the following:

1. Deselect firewall by editing `openwrt/feeds/luci/collections/luci/Makefile`
```
 	+uhttpd +uhttpd-mod-ubus +luci-mod-admin-full +luci-theme-bootstrap \
-	+luci-app-firewall +luci-app-opkg +luci-proto-ppp +libiwinfo-lua +IPV6:luci-proto-ipv6 \
+	+luci-app-opkg +libiwinfo-lua \
```
2. Create user `clash` by editing  `/openwrt/package/base-files/files/etc/passwd`
```
 nobody:*:65534:65534:nobody:/var:/bin/false
+clash:x:0:22333:clash:/var/run/clash:/bin/false
```
3. Deselect dnsmasq ppp wireless ipv6 stuff
4. Select clash-premium and compile
5. Delete WAN interface and bridge all LAN ports after sysupgrading
6. Bring your own `config.yaml` and run `/etc/init.d/clash restart`

You are ready to go

Special Thanks
- <https://xtls.github.io/document/level-2/iptables_gid.html>
- <https://github.com/chandelures/openwrt-clash>
- <https://mritd.com/2022/02/06/clash-tproxy>


