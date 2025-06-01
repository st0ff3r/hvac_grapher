#
# uIota Dockerfile
#
# The resulting image will contain everything needed to build uIota FW.
#
# Setup: (only needed once per Dockerfile change)
# 1. install docker, add yourself to docker group, enable docker, relogin
# 2. # docker build -t uiota-build .
#
# Usage:
# 3. cd to MeterLoggerWeb root
# 4. # docker run -t -i -p 8080:80 meterloggerweb:latest


FROM debian:bookworm

MAINTAINER Kristoffer Ek <stoffer@skulp.net>

RUN "echo" "deb http://http.us.debian.org/debian bookworm non-free" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
	aptitude \
	apt-utils \
	autoconf \
	automake \
	aptitude \
	bash \
	cpp \
	gcc \
	libc-dev-bin \
	libc6-dev \
	git \
	inetutils-telnet \
	joe \
	make \
	linux-libc-dev \
	mime-support \
	sed \
	texinfo \
	sudo \
	screen \
	rsync \
	wget \
	python3 \
	python3-venv \
	python3-pip \
	procps \
	kpartx \
	gnuplot \
	cmake \
	libdbi-perl \
	libdbd-mysql-perl

RUN adduser --disabled-password --gecos "" debian && usermod -a -G dialout debian
RUN usermod -a -G sudo debian
RUN perl -pi.orig -e 's/(\%sudo\s+ALL\s*=\s*)\(ALL:ALL\)\s+ALL/$1\(ALL\) NOPASSWD: ALL/' /etc/sudoers
RUN git clone https://github.com/sourceperl/mbtget.git; \
	cd mbtget; perl Makefile.PL; make; sudo make install

COPY co2.gp /co2.gp
COPY temp.gp /temp.gp
COPY heat_cooling.gp /heat_cooling.gp
COPY read_data.sh /read_data.sh
COPY save_in_db.pl /save_in_db.pl
COPY export_db.pl /export_db.pl
COPY docker-entrypoint.sh /docker-entrypoint.sh

USER debian

CMD /docker-entrypoint.sh

