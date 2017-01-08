FROM debian:jessie

# backports is only used for liberasurecode-dev
RUN set -x \
	&& echo "deb http://deb.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential \
		ca-certificates \
		curl \
		git \
		liberasurecode-dev \
		libffi-dev \
		libldap2-dev \
		libmysqlclient-dev \
		libnss3-dev \
		libpq-dev \
		libsasl2-dev \
		libssl-dev \
		libxml2-dev \
		libxslt1-dev \
		libvirt-dev \
		libyaml-dev \
		libz-dev \
		pkg-config \
		python \
		python-dev \
	&& curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
	&& python get-pip.py \
	&& rm get-pip.py \
	&& curl https://git.openstack.org/cgit/openstack/requirements/plain/global-requirements.txt > /tmp/global-requirements.txt \
	&& curl https://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt > /tmp/upper-constraints.txt \
    # There is a bug with python-nss, this is a workaround
	&& sed -i '/dogtag-pki/d' /tmp/global-requirements.txt \
	&& pip download -d /tmp -c /tmp/upper-constraints.txt python-nss \
	&& mkdir /tmp/python-nss \
	&& tar xvf python-nss-*.tar.bz2 -C /tmp/python-nss --strip-components=1 \
	&& sed -i "s/if arg in ('-d', '--debug'):/if arg == '--debug':/g" /tmp/python-nss/setup.py \
	&& mkdir /root/packages \
	&& pip wheel -w /root/packages/ $(grep dogtag-pki /tmp/upper-constraints.txt) /tmp/python-nss/ \
    # end bug workaround
	&& pip wheel -w /root/packages/ -r /tmp/global-requirements.txt -c /tmp/upper-constraints.txt \
	&& apt-get purge -y --auto-remove \
		build-essential \
		ca-certificates \
		curl \
		git \
		liberasurecode-dev \
		libffi-dev \
		libldap2-dev \
		libmysqlclient-dev \
		libnss3-dev \
		libpq-dev \
		libsasl2-dev \
		libssl-dev \
		libxml2-dev \
		libxslt1-dev \
		libvirt-dev \
		libyaml-dev \
		libz-dev \
		pkg-config \
		python-dev \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /root/.cache

# Create single layer containing only the files we want
RUN mv /root/packages /packages
