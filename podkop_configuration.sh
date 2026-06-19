#!/bin/sh
# =============================================================================
# podkop_setup.sh — настройка podkop на основе бэкапа
# Применяет все UCI-настройки и вспомогательные файлы
# Вставить в терминал роутера (ash/sh)
# =============================================================================

set -e

echo "════════════════════════════════════════════════════"
echo "  podkop setup — применение настроек из бэкапа"
echo "════════════════════════════════════════════════════"

# ─────────────────────────────────────────────────────────────────────────────
# 1. UCI: settings (глобальные настройки podkop)
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "► [1/5] Применяем секцию 'settings'..."

uci set podkop.settings=settings
uci set podkop.settings.dns_type='doh'
uci set podkop.settings.dns_server='8.8.8.8'
uci set podkop.settings.bootstrap_dns_server='77.88.8.8'
uci set podkop.settings.dns_rewrite_ttl='60'
uci set podkop.settings.enable_output_network_interface='0'
uci set podkop.settings.enable_badwan_interface_monitoring='1'
uci set podkop.settings.enable_yacd='0'
uci set podkop.settings.disable_quic='0'
uci set podkop.settings.update_interval='1d'
uci set podkop.settings.download_lists_via_proxy='0'
uci set podkop.settings.dont_touch_dhcp='0'
uci set podkop.settings.config_path='/etc/sing-box/config.json'
uci set podkop.settings.cache_path='/tmp/sing-box/cache.db'
uci set podkop.settings.log_level='warn'
uci set podkop.settings.exclude_ntp='0'
uci set podkop.settings.shutdown_correctly='0'
uci set podkop.settings.badwan_reload_delay='2000'

# source_network_interfaces (list)
uci -q delete podkop.settings.source_network_interfaces 2>/dev/null || true
uci add_list podkop.settings.source_network_interfaces='br-lan'
uci add_list podkop.settings.source_network_interfaces='wgserver'

echo "  [OK] settings применён"

# ─────────────────────────────────────────────────────────────────────────────
# 2. UCI: section 'main' (основная секция маршрутизации)
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "► [2/5] Применяем секцию 'main'..."

uci set podkop.main=section
uci set podkop.main.connection_type='proxy'
uci set podkop.main.proxy_config_type='url'
uci set podkop.main.enable_udp_over_tcp='0'
uci set podkop.main.proxy_string='vless://2e7f55fc-9149-4e0d-9c07-bcca966f8e2f@87.58.213.14:443/?security=reality&type=tcp&flow=xtls-rprx-vision&fp=chrome&sid=a1b2c3d495f6a7b8&pbk=H7CmDypn-fmAkuN6r_gsYxh5X1_5APwwFeflS5se4nA&sni=tokmanni.fi#6fi,vless://2e7f55fc-9149-4e0d-9c07-bcca966f8e2f@194.104.9.80:443?security=reality&type=tcp&flow=xtls-rprx-vision&fp=chrome&sid=a1b2c3d495f6a7b8&pbk=H7CmDypn-fmAkuN6r_gsYxh5X1_5APwwFeflS5se4nA&sni=www.easyexpat.com#6'
uci set podkop.main.user_domain_list_type='disabled'
uci set podkop.main.user_subnet_list_type='text'
uci set podkop.main.mixed_proxy_enabled='0'

# community_lists (list)
uci -q delete podkop.main.community_lists 2>/dev/null || true
uci add_list podkop.main.community_lists='geoblock'
uci add_list podkop.main.community_lists='block'
uci add_list podkop.main.community_lists='porn'
uci add_list podkop.main.community_lists='news'
uci add_list podkop.main.community_lists='anime'
uci add_list podkop.main.community_lists='discord'
uci add_list podkop.main.community_lists='meta'
uci add_list podkop.main.community_lists='twitter'
uci add_list podkop.main.community_lists='hdrezka'
uci add_list podkop.main.community_lists='tiktok'
uci add_list podkop.main.community_lists='telegram'
uci add_list podkop.main.community_lists='cloudflare'
uci add_list podkop.main.community_lists='google_play'
uci add_list podkop.main.community_lists='hodca'
uci add_list podkop.main.community_lists='digitalocean'

# user_subnets_text (многострочный список IP — записываем как option)
uci set podkop.main.user_subnets_text='//merge dragons
213.248.110.82
3.164.206.111
91.214.189.177
108.156.22.117
52.33.45.150
34.253.77.208
1.1.1.1
34.102.162.219
37.27.135.61
108.157.229.63
34.149.76.49
15.204.79.19
108.156.22.41
157.240.205.1
151.101.3.52
18.200.125.170
142.251.38.66
34.107.159.209
108.157.224.182
18.200.59.133
34.54.122.72
3.174.113.89
34.250.141.99
99.83.213.107
2.21.240.203
108.132.62.172
108.157.229.22
65.9.46.30
23.73.4.219
65.9.62.113
3.164.68.67
34.117.147.68
44.215.223.155
108.156.22.75
3.164.68.11
104.18.2.182
34.111.80.193
3.225.247.54
34.110.179.88
151.101.3.6
108.157.232.150
100.23.17.84
35.190.88.7
151.101.131.52
35.190.115.187
52.48.15.151
34.160.81.0
104.16.160.145
23.73.2.157
135.148.101.214'

echo "  [OK] main применён"

# ─────────────────────────────────────────────────────────────────────────────
# 3. UCI commit
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "► [3/5] UCI commit..."

uci commit podkop
echo "  [OK] podkop committed"

# sing-box UCI (отдельный конфиг)
uci set sing-box.main=sing-box
uci set sing-box.main.enabled='1'
uci set sing-box.main.user='root'
uci set sing-box.main.conffile='/etc/sing-box/config.json'
uci set sing-box.main.workdir='/usr/share/sing-box'
uci commit sing-box
echo "  [OK] sing-box committed"

# ─────────────────────────────────────────────────────────────────────────────
# 4. Вспомогательные файлы
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "► [4/5] Вспомогательные файлы..."

# 4a. NFTables chain для wgserver
mkdir -p /etc/nftables.d
cat > /etc/nftables.d/90-wgserver-podkop.nft << 'NFT'
chain wgserver_podkop {
    type filter hook prerouting priority mangle - 10; policy accept;

    iifname != "wgserver" return
    fib daddr type { local, broadcast, multicast } return
    ip daddr { 0.0.0.0/8, 10.0.0.0/8, 10.1.0.0/24, 10.1.0.1/24, 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.168.0.0/16, 192.168.8.0/24, 224.0.0.0/4, 240.0.0.0/4 } return
    meta mark 0x520 return

    meta l4proto { tcp, udp } tproxy ip to 127.0.0.1:1602 meta mark set 0x520 accept
}
NFT
echo "  [OK] /etc/nftables.d/90-wgserver-podkop.nft"

# 4b. Hotplug-скрипт для wgserver
mkdir -p /etc/hotplug.d/iface
cat > /etc/hotplug.d/iface/95-wgserver-podkop << 'HOTPLUG'
#!/bin/sh
[ "${ACTION}" = "ifup" ] || [ "${ACTION}" = "ifupdate" ] || exit 0

case "${INTERFACE}:${DEVICE}" in
    wgserver:wgserver|wgserver:*|*:wgserver) ;;
    *) exit 0 ;;
esac

ip rule del fwmark 0x520/0x520 table 520 2>/dev/null || true
ip rule add fwmark 0x520/0x520 table 520 2>/dev/null || true
ip route replace local 0.0.0.0/0 dev lo table 520
HOTPLUG
chmod +x /etc/hotplug.d/iface/95-wgserver-podkop
echo "  [OK] /etc/hotplug.d/iface/95-wgserver-podkop"

# ─────────────────────────────────────────────────────────────────────────────
# 5. Проверка и перезапуск
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "► [5/5] Итоговые настройки podkop:"
echo "────────────────────────────────────"
uci show podkop
echo ""
echo "════════════════════════════════════════════════════"
printf "[?] Перезапустить sing-box и podkop? (y/N): "
read RESTART
if [ "$RESTART" = "y" ] || [ "$RESTART" = "Y" ]; then
    echo "  Перезапускаем sing-box..."
    /etc/init.d/sing-box restart && echo "  [OK] sing-box" || echo "  [ERR] sing-box"
    sleep 2
    echo "  Перезапускаем podkop..."
    /etc/init.d/podkop restart && echo "  [OK] podkop" || echo "  [ERR] podkop"
else
    echo ""
    echo "  Запустить вручную:"
    echo "    /etc/init.d/sing-box restart && /etc/init.d/podkop restart"
fi
echo ""
echo "  [DONE] Настройка завершена"
echo "════════════════════════════════════════════════════"
