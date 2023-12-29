# raskinminsk_infra
raskinminsk Infra repository

bastion_IP = 178.154.202.169
someinternalhost_IP = 10.128.0.13

# Все требуемые файлы конфигурации находятся в директории VPN.

# Подключение к VM "someinternakhost" с локального компа в одну строку:
ssh -i ~/.ssh/appuser -A -J appuser@178.154.202.169 appuser@10.128.0.13

# Оптимизируем подключение к серверам через шлюз с кэшированием приватного ключа:
# 1 Добавляем в файл ~/.bashrc две строки:
 eval $(ssh-agent -s)
 ssh-add ~/.ssh/appuser
# 2 Создадим файл конфигурации ssh:
 touch ~/.ssh/config
 nano ~/.ssh/config
# 3 Добавим в ~.ssh/config параметры серверов и методов подключения к ним:
 Host bastion
     Hostname 178.154.202.169
     user appuser
     ForwardAgent yes

 Host appuser
     Hostname 10.128.0.13
     user appuser
     ForwardAgent yes

# Настройка сервера VPN Pritunl на VM "bastion".
# Проводилось согласно описанию в ДЗ, за исключением установки "MongoDB":
 wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
 echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Настройка клиента "openvpn" на локальной машине
# 1 На локальной машине:
 sudo apt install openvpn

# 2 Загружен profile файл пользователя "test.tar" - раздел "Users and Organizations" Pritunl web-page на VM "bastion"
 tar xvf test.tar
 sudo mv test_test_bastionvpn.ovpn /etc/openvpn/client.conf
 sudo chown root:root /etc/openvpn/client.conf

# 3 Для автоматического подхвата параметров openvpn пользователя и PIN клиента:
 sudo nano /etc/openvpn/auth.txt
# Добавлены значения user and PIN в/etc/openvpn/auth.txt :
 test
 6214157507237678334670591556762

# 5 Запуск openvpn клиента с указанием файла конфигурации:
 sudo openvpn --client --config /etc/openvpn/client.conf &
 sudo systemctl enable openvpn@client.service
 sudo service openvpn@client start

# 6 Проверка работы openvpn клиента на локальной машине:
# Контроль внешнего IP, в случае успеха он должен быть 178.154.202.169, в моем случае:
 curl ifconfig.me
  178.154.202.169raskin@ubuntu22:~$
# Контроль наличия туннеля VPN "tun0" с адресом из подсети VPN:
 ip a
 tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    link/none
    inet 192.168.236.2/24 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::ff7f:ebe6:267f:f122/64 scope link stable-privacy
       valid_lft forever preferred_lft forever
# Прямое подключение к удаленному серверу "someinternalhost":
 ssh someinternalhost
# Конроль логов на Pritunl сервере VM "bastion"
