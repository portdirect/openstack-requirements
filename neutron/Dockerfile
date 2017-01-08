FROM debian:jessie

ENV VIRTUAL_ENV /virtualenv
ENV PATH "$VIRTUAL_ENV/bin:$PATH"
COPY downloader.sh /
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		dnsmasq \
		dnsmasq-utils \
		iproute2 \
		ipset \
		iptables \
		iputils-arping \
		keepalived \
		openvswitch-switch \
		uuid-runtime \
		curl \
		ca-certificates \
	&& curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
	&& python get-pip.py \
	&& rm get-pip.py \
	&& pip install virtualenv \
    && /downloader.sh \
	&& virtualenv $VIRTUAL_ENV \
	&& hash -r \
	&& pip install --find-links /tmp/packages http://tarballs.openstack.org/neutron/neutron-master.tar.gz \
	&& apt-get purge -y --auto-remove \
		curl \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /root/.cache
