FROM alpine:3.14

RUN apk add mariadb mariadb-client

RUN mysql_install_db --user=mysql
EXPOSE 3306

COPY home_you /home/you
COPY etc_custom-mariadb.conf /etc/custom-mariadb.conf

ADD ["boot.sh", "/sbin/"]
ENTRYPOINT ["/bin/sh", "/sbin/boot.sh"]