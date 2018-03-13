FROM hypriot/rpi-alpine:3.6

LABEL maintainer="swestcott@gmail.com"

ENV ALERTMANAGER_VERSION 0.14.0

RUN sed -i -e 's/http/https/g' /etc/apk/repositories \
	&& apk upgrade --no-cache \
	&& apk add --no-cache ca-certificates

ADD https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz /tmp/
ADD https://raw.githubusercontent.com/prometheus/alertmanager/master/template/default.tmpl /tmp/default.tmpl
#COPY alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz /tmp/

RUN cd /tmp \
	&& tar -zxvf /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz \
	&& mkdir -p /etc/alertmanager/template \
	&& cp /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/alertmanager /bin/alertmanager \
	&& cp /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/simple.yml /etc/alertmanager/config.yml \
	&& cp /tmp/default.tmpl /etc/alertmanager/template/default.tmpl \
	&& chmod a+r /etc/alertmanager/template/default.tmpl \
	&& rm /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz \
	&& rm -r /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/

EXPOSE 9093

VOLUME [ "/alertmanager" ]

WORKDIR /alertmanager

ENTRYPOINT [ "/bin/alertmanager" ]

USER nobody:nogroup

CMD [ "-config.file=/etc/alertmanager/config.yml", \
    "-storage.path=/alertmanager" ]
