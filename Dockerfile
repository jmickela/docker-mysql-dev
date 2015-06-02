# Mysql Docker Container
FROM ubuntu:14.04
MAINTAINER Jason Mickela <jason@rootid.in>

VOLUME /var/lib/mysql

RUN apt-get update

RUN apt-get -y install mysql-server
RUN apt-get -y install nginx
RUN apt-get -y install php5-fpm php5-mysql
RUN apt-get -y install phpmyadmin

ADD nginx.conf /etc/nginx/nginx.conf
ADD php.ini /etc/php5/fpm/php.ini

RUN ln -s /usr/share/phpmyadmin /usr/share/nginx/html
RUN php5enmod mcrypt
ADD mysqlpassword /root/mysqlpassword
RUN debconf-set-selections /root/mysqlpassword

RUN sed -Ei "s/^(bind-address|log)/#&/" /etc/mysql/my.cnf

EXPOSE 3306
EXPOSE 80

COPY mysql_setup.sh /mysql_setup.sh
RUN chmod +x /mysql_setup.sh


CMD /mysql_setup.sh