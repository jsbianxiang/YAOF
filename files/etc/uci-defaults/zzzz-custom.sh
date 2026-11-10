#!/bin/sh
# 首次开机把 LAN 管理地址改成 192.168.2.1/24，避开光猫的 192.168.1.1。
#
# 放在 /etc/uci-defaults/，由 /etc/init.d/boot 的 uci_apply_defaults() 执行一次，
# 执行成功后脚本自身会被删掉，不会每次开机都跑。
#
# 文件名用 zzzz- 排在最后：将来若有别的包（如 addition-trans-zh 的
# 99-default-settings）也写 network.lan.ipaddr，以这里为准。

# ---- LAN 地址 ----
# 24.10 及更早版本 netmask 默认 255.255.255.0，写成：
#   lan_ip_address="192.168.1.1"
# 25.12 及以后必须用 CIDR 写法：
lan_ip_address="192.168.2.1/24"

# 输出落到专属文件，避免与其他 uci-defaults 脚本共用 /tmp/setup.log 互相截断
exec >/tmp/zzzz-custom.log 2>&1

if [ -n "$lan_ip_address" ]; then
    uci set network.lan.ipaddr="$lan_ip_address"
    uci commit network
fi

# 必须返回 0：uci-defaults 只在退出码为 0 时删除脚本，否则会留在
# /etc/uci-defaults/ 里每次开机重跑，把用户后来改过的地址反复改回去。
exit 0
