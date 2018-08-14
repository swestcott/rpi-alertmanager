FROM resin/armhf-alpine:3.7

LABEL maintainer="swestcott@gmail.com"

ENV ALERTMANAGER_VERSION 0.15.2

RUN ["cross-build-start"]

RUN apk --update upgrade \
    && apk add ca-certificates \
    && rm -r /var/cache/apk/*

ADD https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz /tmp/
ADD https://raw.githubusercontent.com/prometheus/alertmanager/master/examples/ha/alertmanager.yml /tmp/config.yml
ADD https://raw.githubusercontent.com/prometheus/alertmanager/master/template/default.tmpl /tmp/default.tmpl
#COPY alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz /tmp/

RUN cd /tmp \
	&& tar -zxvf /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz \
	&& mkdir -p /etc/alertmanager/template \
	&& cp /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/alertmanager /bin/alertmanager \
	&& cp /tmp/config.yml /etc/alertmanager/config.yml \
	&& cp /tmp/default.tmpl /etc/alertmanager/template/default.tmpl \
	&& chmod -R a+r /etc/alertmanager/ \
	&& rm /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz \
	&& rm -r /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/

RUN ["cross-build-end"]

EXPOSE 9093

VOLUME [ "/alertmanager" ]

WORKDIR /alertmanager

ENTRYPOINT [ "/bin/alertmanager" ]

USER nobody:nobody

CMD [ "--config.file=/etc/alertmanager/config.yml", \
    "--storage.path=/alertmanager" ]
