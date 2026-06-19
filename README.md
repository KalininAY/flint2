# flint2


1. установить ванильную openwrt 4.9.0
  - https://dl.gl-inet.com/router/mt6000/openwrt24
  - установить через интерфейс gl.inet http://192.168.8.1/#/upgrade
  - задать root-пароль, задать wifi: Torr194, Tor35
  - в http://192.168.8.1/#/management-control задать порт ssh
  - opkg update, проверить наличие пакета nft-queue
  - загрузить backup, проверить wireguard-сервер-профили http://192.168.8.1/#/wgserver

2. установить ЗАПРЕТ
  - `wget -O /tmp/Zapret-Manager.sh https://raw.githubusercontent.com/StressOzz/Zapret-Manager/main/Zapret-Manager.sh && sh /tmp/Zapret-Manager.sh`
  - проверить стратегии на телевизоре, ноуте, айфоне
  - может понадобиться создание симлинка (если запрет не запускает и пишет, что нет указанного файла в /opt/zapret/files/fake/)

3. установить ПОДКОП
  - `wget -O /tmp/podkop-install.sh https://raw.githubusercontent.com/itdoginfo/podkop/refs/heads/main/install.sh && sh /tmp/podkop-install.sh`
  - сконфигурировать `wget -O /tmp/podkop_setup.sh https://raw.githubusercontent.com/KalininAY/flint2/main/podkop_configuration.sh && sh /tmp/podkop_setup.sh`

4. проверить wireguard-сервер
   - цепочка `телефон-wg-роутер`
   - цепочка `телефон-wg-Я.ВМ-wg-роутер` (каскад через белые списки)



# hotfixes

<details><summary>tcpdump</summary>
  
ошибка
```
root@GL-MT6000:/tmp/tcp_test# tcpdump --version
Error relocating /usr/bin/tcpdump: pcap_open: symbol not found
Error relocating /usr/bin/tcpdump: pcap_findalldevs_ex: symbol not found
```
решение (выполнить)
```
# Проверить libpcap из репо OpenWrt — там должна быть версия с Remote Capture
cd /tmp
wget https://downloads.openwrt.org/releases/24.10.4/packages/aarch64_cortex-a53/base/libpcap1_1.10.5-r2_aarch64_cortex-a53.ipk
mkdir libpcap_test && cd libpcap_test
tar -xzf ../libpcap1_1.10.5-r2_aarch64_cortex-a53.ipk
tar -xzf data.tar.gz
strings ./usr/lib/libpcap.so.1.10.5 | grep pcap_findalldevs_ex

# Заменить libpcap GL.iNet-версию на репозиторную
cp /tmp/libpcap_test/usr/lib/libpcap.so.1.10.5 /usr/lib/libpcap.so.1.10.5

# Убедиться что tcpdump из репо на месте (удалить существующий и скопировать)
rm /usr/bin/tcpdump
cp /tmp/tcp_test/usr/bin/tcpdump /usr/bin/tcpdump
chmod +x /usr/bin/tcpdump

tcpdump --version
```
</details>
