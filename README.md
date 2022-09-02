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


`config.yaml` example for tproxy and fake-ip:
```
tproxy-port: 12345
mode: rule
ipv6: false
log-level: warning
allow-lan: false
external-controller: 0.0.0.0:9090
external-ui: yacd
secret: "secret"

dns:
  enable: true
  listen: 127.0.0.1:53
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  fake-ip-filter:
    - 'dns.msftncsi.com'
  nameserver:
    - https://1.12.12.12/dns-query
    - https://120.53.53.53/dns-query
    - https://223.5.5.5/dns-query
    - https://223.6.6.6/dns-query
    

proxies:


proxy-groups:
  - 
    name: ✈️ PROXY
    type: select
    proxies: 
      - DIRECT
  -
    name: 🇨🇳 CN
    type: select
    proxies:
      - DIRECT


rule-providers:
  ad-keyword:
    type: http
    behavior: classical
    url: "https://cdn.jsdelivr.net/gh/Hackl0us/SS-Rule-Snippet@master/Rulesets/Clash/Basic/common-ad-keyword.yaml"
    path: ./ruleset/common-ad-keyword.yaml
    interval: 3600

  foreign:
    type: http
    behavior: classical
    url: "https://cdn.jsdelivr.net/gh/Hackl0us/SS-Rule-Snippet@master/Rulesets/Clash/Basic/foreign.yaml"
    path: ./ruleset/foreign.yaml
    interval: 3600
    
  apple-proxy:
    type: http
    behavior: classical
    url: "https://cdn.jsdelivr.net/gh/Hackl0us/SS-Rule-Snippet@master/Rulesets/Clash/Basic/Apple-proxy.yaml"
    path: ./ruleset/Apple-proxy.yaml
    interval: 3600

  apple-direct:
    type: http
    behavior: classical
    url: "https://cdn.jsdelivr.net/gh/Hackl0us/SS-Rule-Snippet@master/Rulesets/Clash/Basic/Apple-direct.yaml"
    path: ./ruleset/Apple-direct.yaml
    interval: 3600

  cn:
    type: http
    behavior: classical
    url: "https://cdn.jsdelivr.net/gh/Hackl0us/SS-Rule-Snippet@master/Rulesets/Clash/Basic/CN.yaml"
    path: ./ruleset/CN.yaml
    interval: 3600

  lan:
    type: http
    behavior: classical
    url: "https://cdn.jsdelivr.net/gh/Hackl0us/SS-Rule-Snippet@master/Rulesets/Clash/Basic/LAN.yaml"
    path: ./ruleset/LAN.yaml
    interval: 3600

rules:
  - RULE-SET,ad-keyword,REJECT
  - RULE-SET,foreign,✈️ PROXY
  - RULE-SET,apple-proxy,✈️ PROXY
  - RULE-SET,apple-direct,🇨🇳 CN
  - RULE-SET,cn,🇨🇳 CN
  - GEOIP,CN,🇨🇳 CN
  - RULE-SET,lan,DIRECT
  - MATCH,✈️ PROXY
```

Special Thanks
- <https://xtls.github.io/document/level-2/iptables_gid>
- <https://github.com/chandelures/openwrt-clash>
- <https://mritd.com/2022/02/06/clash-tproxy>


