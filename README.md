# Docker Wordpress with Centos7 Openlitespeed MariaDB10.2 ProFTPD PHP7.2

This Docker will run

- Centos 7
- Wordpress
- Openlitespedd
- MariaDB10.2
- ProFTPD
- PHP 7.2

you can access litespeed admin in http://yourhostname:7080, set password with command

```/usr/local/lsws/admin/misc/admpass.sh```

Document root in:
```
/home/defdomain/html/
```
## Build docker image
```
git clone https://github.com/bvisible/openlitespeed-mariadb-php72-wordpress.git
cd openlitespeed-mariadb-php72-wordpress
docker build --rm=true --no-cache=true -t openlitespeed-mariadb-php72-wordpress .
```
Run docker image
```
docker run openlitespeed-mariadb-php72-wordpress
```
## Hub Docker

Can found in https://hub.docker.com/r/bvisible/centos-openlitespeed-wp/

or pull
```
docker pull bvisible/centos-openlitespeed-wp/
```

thanks to tujuhion : https://github.com/tujuhion/docker-centos-openlitespeed-wordpress