FROM shurshun/alpine-moscow

LABEL maintainer "4lifenet@gmail.com"

ENV PDNS_VERSION=4.0.3 \
	PDNS_MODULES="remote lua gsqlite3"

RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		g++ \
		libtool \
		boost-dev \
		wget \
		make \
		lua-dev \
		sqlite-dev \
	&& apk add --no-cache libstdc++ lua sqlite openssl-dev \
	&& wget https://downloads.powerdns.com/releases/pdns-"$PDNS_VERSION".tar.bz2 \
	&& tar jxf pdns-"$PDNS_VERSION".tar.bz2 \
	&& cd pdns-"$PDNS_VERSION" \
	&& ./configure --with-modules="$PDNS_MODULES" --with-lua \
	&& make \
	&& make install \
	&& cd / \
	&& rm -rf pdns-"$PDNS_VERSION"* \
	&& mkdir -p /etc/pdns \
	&& echo 'include-dir=/etc/pdns' > /usr/local/etc/pdns.conf \
	&& apk del .build-deps \
	&& apk add --no-cache sqlite-libs

COPY conf/ /etc/pdns/

EXPOSE 53/udp

CMD ["/bin/sh"]