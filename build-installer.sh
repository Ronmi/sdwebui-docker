#!/usr/bin/bash

cp installer_tmpl.sh installer.sh

echo -n 'echo "' >> installer.sh
tar czf - build docker-compose.tmpl.yml rebuild.sh .rmi-work/.gitignore .rmi-work/conf.zsh | base64 -w 0 >> installer.sh
echo '" | base64 -d | tar zxvf -' >> installer.sh

echo 'mv docker-compose.tmpl.yml docker-compose.yml' >> installer.sh
echo 'sed -i "s/#UID#/$(id -u)/" docker-compose.yml' >> installer.sh
echo 'sed -i "s/#GID#/$(id -g)/" docker-compose.yml' >> installer.sh

echo 'echo "installation completed"' >> installer.sh
echo 'echo' >> installer.sh
echo 'echo' >> installer.sh

echo -n 'echo "' >> installer.sh
cat usage.txt | gzip | base64 -w 0 >> installer.sh
echo '" | base64 -d | gunzip' >> installer.sh
