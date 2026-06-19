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
