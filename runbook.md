# runbook tested on win11/virtualbox enviroment

# place vagrantfile in infrastructure dir

# open win terminal in this dir

# setup hostmanager plugin

vagrant plugin install vagrant-hostmanager

# start project

run vagrant up

---

# for the first time manually create db/user on db vm

    sudo -i -u postgres psql -c "CREATE DATABASE {{ db_name }};"
    sudo -i -u postgres psql -c "CREATE USER {{ db_user }} WITH ENCRYPTED PASSWORD '{{ db_pass }}';"
    sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE {{ db_name }} TO {{ db_user }};"

# configure jenkins secrets dbname/dbuser/dbpass to init db

# configure jenkins secrets default_flask_adminpass to migrate db

---

# before run pipeline

# put inventory file for ansible into project directory with vagrantfile

# do on web vm

---

sudo systemctl stop flaskbird.service
sudo rm -rf flask
sudo rm /etc/systemd/system/flaskbird.service

---

# steps to run db migrate

1. ssh login to the web.local
2. sudo systemctl stop flaskbird
3. cd flask
4. source flasktest/bin/activate
5. cd birdproject
6. flask db upgrade -d migrations

---

# DEBUG

to debug why service didn't start well

1. install on host some dbview tool
2. ssh login to the web.local
3. sudo systemctl stop flaskbird
4. cd flask
5. source flasktest/bin/activate
6. gunicorn --workers 4 --bind 127.0.0.1:5000 "birdproject:create_app()"
7. debug if there some errors

# alternative way if service is configured Restart=always

1. sudo journalctl -u flaskbird -e
