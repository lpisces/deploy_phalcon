#! /bin/bash

yum update
yum makecache
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
yum repolist

sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/epel.repo
sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/rpmforge.repo

yum --enablerepo=epel,remi,rpmforge install -y php php-mysql php-devel mysql nginx vim php-fpm php-gd php-curl mysql-server pcre-devel gcc make git 

chkconfig nginx on
chkconfig php-fpm on
chkconfig mysqld on

sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini
sed -i 's/;cgi.fix_pathinfo/cgi.fix_pathinfo/g' /etc/php.ini

sed -i 's/user = apache/user=nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group=nginx/g' /etc/php-fpm.d/www.conf

service nginx restart
service php-fpm restart 
service mysqld restart 

mkdir -p /var/www/app/
cp ./i.php /var/www/app/
mkdir -p /etc/nginx/conf.d/
cp ./nginx_virtual.conf /etc/nginx/conf.d/app.conf
service nginx reload

#install phalcon
rm -rf ~/cphalcon
git clone --depth=1 git://github.com/phalcon/cphalcon.git ~/cphalcon
cd  ~/cphalcon/build
sudo ./install
cd -
cp ./phalcon.ini /etc/php.d/
service php-fpm restart 

rm -rf ~/phalcon-devtools
git clone https://github.com/phalcon/phalcon-devtools.git ~/phalcon-devtools
sh ~/phalcon-devtools/phalcon.sh
rm -rf /usr/bin/phalcon
ln -s ~/phalcon-devtools/phalcon.php /usr/bin/phalcon
chmod ugo+x /usr/bin/phalcon

