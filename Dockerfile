FROM alpine:3.13

RUN apk --no-cache add vsftpd

COPY ./config/vsftpd.conf /etc/vsftpd/vsftpd.conf

EXPOSE 21 21000-21010

ENTRYPOINT ["rc-service", "vsftpd", "start"]