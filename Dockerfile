FROM hypriot/rpi-alpine:3.6

LABEL maintainer="swestcott@gmail.com"

ENV ALERTMANAGER_VERSION 0.14.0

RUN sed -i -e 's/http/https/g' /etc/apk/repositories \
	&& apk upgrade --no-cache \
	&& apk add --no-cache ca-certificates

ADD https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz /tmp/
#COPY alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz /tmp/

RUN cd /tmp \
	&& tar -zxvf /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz \
	&& mkdir /etc/alertmanager \
	&& cp /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/alertmanager /bin/alertmanager \
	&& cp /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/simple.yml /etc/alertmanager/config.yml \
	&& rm /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz \
	&& rm -r /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/

ADD https://raw.githubusercontent.com/prometheus/alertmanager/master/template/default.tmpl /etc/alertmanager/template/default.tmpl

EXPOSE 9093

VOLUME [ "/alertmanager" ]

WORKDIR /alertmanager

ENTRYPOINT [ "/bin/alertmanager" ]

USER nobody:nogroup

CMD [ "-config.file=/etc/alertmanager/config.yml", \
    "-storage.path=/alertmanager" ]
