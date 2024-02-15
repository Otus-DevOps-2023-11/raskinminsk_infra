# raskinminsk_infra
raskinminsk Infra repository

bastion_IP = 178.154.202.169
someinternalhost_IP = 10.128.0.13

# Все требуемые файлы конфигурации находятся в директории VPN.

# Подключение к VM "someinternalhost" с локального компа в одну строку:
#    ssh -i ~/.ssh/appuser -A -J appuser@178.154.202.169 appuser@10.128.0.13

# Оптимизируем подключение к серверам внутренней сети через bastion-шлюз с кэшированием приватного ключа
# Копии данных файлов лежат в директории VPN данной ветки

# 1 Добавляем в файл ~/.bashrc две строки:
#    eval $(ssh-agent -s)
#    ssh-add ~/.ssh/appuser

# 2 Создадим файл конфигурации ssh ~/.ssh/config

# 3 Добавим в этот config файл параметры серверов и методов подключения к ним:
# Host bastion
#     Hostname 178.154.202.169
#     user appuser
#     ForwardAgent yes
# Host appuser
#     Hostname 10.128.0.13
#     user appuser
#     ForwardAgent yes

# Настройка сервера VPN Pritunl на VM "bastion", копии этих файлов находятся в директории VPN данной ветки

# На VM bastion настройка согласно описанию в ДЗ, за исключением установки "MongoDB":
#    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
#    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Настройка клиента "openvpn" на локальной машине

# 1 На локальной машине:
#    sudo apt install openvpn

# 2 Загружаем profile-файл пользователя "test.tar" - из раздела "Users and Organizations" web-page сервера Pritunl на VM "bastion"
#    tar xvf test.tar
#    sudo mv test_test_bastionvpn.ovpn /etc/openvpn/client.conf
#    sudo chown root:root /etc/openvpn/client.conf

# 3 Для автоматического подхвата параметров openvpn пользователя и PIN при загрузке операционной системы:
#    sudo nano /etc/openvpn/auth.txt

# 4 Добавлены значения user и PIN в файл /etc/openvpn/auth.txt согласно условиям ДЗ:
#    test
#    6214157507237678334670591556762

# 5 Запуск openvpn-клиента с указанием файла конфигурации:
#    sudo openvpn --client --config /etc/openvpn/client.conf &
#    sudo systemctl enable openvpn@client.service
#    sudo service openvpn@client start

# 6 Проверка работы openvpn-клиента на локальной машине:

# Контроль внешнего IP, в случае успеха он должен быть внешнему IP VM "bastion", в моем случае:
#    curl ifconfig.me
#    178.154.202.169raskin@ubuntu22:~$

# Контроль наличия туннеля VPN "tun0" с адресом из подсети VPN:
#    ip a
#      tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
#      link/none
#      inet 192.168.236.2/24 scope global tun0
#        valid_lft forever preferred_lft forever
#      inet6 fe80::ff7f:ebe6:267f:f122/64 scope link stable-privacy
#        valid_lft forever preferred_lft forever

# Прямое подключение к удаленному серверу "someinternalhost":
#    ssh someinternalhost

# Конроль логов на Pritunl сервере VM "bastion"

# Home work 6, cloud-testapp
testapp_IP = 62.84.126.166
testapp_port = 9292

# yc CLI:
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata-from-file user-data=/home/raskin/raskinminsk_infra/cloud-init.yml \
  --metadata serial-port-enable=1 \


# Home work 7
# При помощи PACKER создан образ "reddit-base-1705228375" и запущена виртуальная машина
# После деплоя приложения reddit проверка в браузере -  http://84.252.130.103:9292

# Home work 8
# Установлен terraform версии 1.7.0, загружен провайдер Yandex Cloud, на базе образа из ДЗ 7
# запущен инстанс ВМ с последующей установкой puma.unut и деплоя приложения monolith
# Проверка в браузере - http://158.160.127.159:9292/

# Home work 9
# 1 Определены ресурсы сети и подсети в конфигурационном файле main.tf
# на основе ресурсов сети и подсети в нашей VM назначен интерфейс с внешним IP.
# 2 Созданы два новых образа "reddit-db", содержащий MongoDB, "reddit-app" с установленным Ruby,
# которые в дальнейшем были использованы для разделения конфигурации одной VM на две VM, использующие
# модульную конфигурацию.
# 3 Создана инфраструктура для двух окружений (stage и prod), переиспользующие созданные модули
# 4 Задание со "*" - для сервисного аккаунта создан статический ключ доступа к бакету, чтобы
# не показывать в явном виде идентификатор ключа и секретный ключ в настройках инфраструктуры.
# Для блокировки одновременного применения конфигураций создана настройка бекенда "backend.tf"
# для stage и prod с выносом state-файла в удаленный Yandex Object Storage.

# Home work 10
# Установлен Ansible, ознакомлен с базовыми функциями и настойкой конфигурационных файлов.
# Выполнены различные модули на инфраструктуре подготовленной в прошлых ДЗ.
# Написан скрипт, генерирующий JSON файл для inventory Ansible.
# В файле ansible.cfg сделаны настройки для работы с JSON-inventory.
