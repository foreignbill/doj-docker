FROM ubuntu:18.04

RUN apt-get update \
	&& apt-get install curl -y \
	&& apt-get install gnupg2 -y \
	&& curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& curl -sL https://deb.nodesource.com/setup_8.x | bash - \
	&& apt install yarn nodejs -y \
	&& apt install software-properties-common -y \
	&& apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
	&& add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.3/ubuntu bionic main' \
	&& add-apt-repository ppa:chris-lea/redis-server \
	&& apt update \
	&& apt install python-pip -y \
	&& pip install Pygments -i https://pypi.tuna.tsinghua.edu.cn/simple\
	&& apt install p7zip-full -y \
	&& apt install clang-format -y \
	&& apt install graphicsmagick -y

RUN apt install build-essential libboost-all-dev -y

RUN apt install rabbitmq-server -y

RUN mkdir -p /opt/doj

ADD judge /opt/doj/judge

RUN cd /opt/doj/judge \
	&& yarn

RUN cd /opt/doj/judge \
	&& yarn run build

ADD sandbox /opt/doj/sandbox

ADD DOJ /opt/doj/web

RUN cd /opt/doj/web \
	&& yarn

RUN echo 'Asia/Shanghai' >/etc/timezone

CMD ["/bin/bash"]