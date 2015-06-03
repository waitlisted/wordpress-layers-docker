FROM ubuntu:latest
MAINTAINER Justin McNally <justin@kohactive.com>
RUN apt-get update # Fri Oct 24 13:09:23 EDT 2014
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client mysql-server apache2 libapache2-mod-php5 pwgen python-setuptools vim-tiny php5-mysql  php5-ldap wget curl
RUN easy_install supervisor
ADD ./scripts/cli.sh /cli.sh
ADD ./scripts/start.sh /start.sh
ADD ./scripts/foreground.sh /etc/apache2/foreground.sh
ADD ./configs/supervisord.conf /etc/supervisord.conf
ADD ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN rm -rf /var/www/
ADD https://wordpress.org/latest.tar.gz /wordpress.tar.gz
RUN tar xvzf /wordpress.tar.gz 
ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /wp-cli.phar
RUN chmod 755 /cli.sh
RUN /cli.sh
RUN mv /wordpress /var/www/
RUN chown -R www-data:www-data /var/www/
RUN find /var/www -type d -exec chmod 775 {} \;
RUN find /var/www -type f -exec chmod 664 {} \;
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN mkdir /var/log/supervisor/
RUN adduser --disabled-password --gecos '' waitlisted
RUN adduser waitlisted www-data

EXPOSE 80
CMD ["/bin/bash", "/start.sh"]
