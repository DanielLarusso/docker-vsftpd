FROM alpine:3.13

ARG FTP_USER_UID=${FTP_USER_UID:-1000}
ARG FTP_USER_NAME=${FTP_USER_NAME:-vsftpd}
ARG FTP_USER_PASSWORD=${FTP_USER_PASSWORD:-changeme}

ARG FTP_PORT=${FTP_PORT:-21}
ARG FTP_PASV_PORT_MIN=${FTP_PASV_PORT_MIN:-21000}
ARG FTP_PASV_PORT_MAX=${FTP_PASV_PORT_MAX:-21010}

RUN apk --no-cache add vsftpd
RUN adduser ${FTP_USER_NAME} --uid ${FTP_USER_UID} --shell /bin/false --home /var/lib/ftp --no-create-home --disabled-password
RUN echo -e "${FTP_USER_PASSWORD}\n${FTP_USER_PASSWORD}" | passwd ${FTP_USER_NAME}
RUN chown -R ${FTP_USER_NAME}:1000 /var/lib/ftp

COPY ./config/vsftpd.conf /etc/vsftpd/vsftpd.conf

EXPOSE ${FTP_PORT}/tcp ${FTP_PASV_PORT_MIN}-${FTP_PASV_PORT_MAX}/tcp

ENTRYPOINT ["/usr/sbin/vsftpd", "-opasv_min_port=${FTP_PASV_PORT_MIN}", "-opasv_max_port=${FTP_PASV_PORT_MAX}", "/etc/vsftpd/vsftpd.conf"]