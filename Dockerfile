FROM alpine:3.14

RUN apk add mariadb mariadb-client bash mc

RUN mysql_install_db --user=mysql
EXPOSE 3306

COPY home/you /home/you

ADD ["sbin/boot.sh", "/sbin/"]
ENTRYPOINT ["/bin/sh", "/sbin/boot.sh"]
