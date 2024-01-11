FROM ubuntu:22.04 as aerobike_dev
LABEL maintainer="Rostislav Velichko <rostislav.vel@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt update -qq > /dev/null && \
    apt install  -qq -y \
	apt-utils \
	tzdata \
	locales \
	pip \
 	pkg-config \
	cmake \
	g++ \
	git \
	curl \
	libcurl4-openssl-dev \
	libmicrohttpd-dev \
	libmongo-client-dev \
	libgtest-dev \
	libwebsockets-dev \
	openssh-server \
	sudo \
	rsync \
	> /dev/null

RUN sed -i '/ru_RU.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=ru_RU.UTF-8
ENV LC_ALL=ru_RU.UTF-8
ENV LANGUAGE=ru_RU:en

# gtest install
RUN cd /usr/src/gtest && cmake CMakeLists.txt && make && cp lib/*.a /usr/lib

# emsdk install
RUN git clone https://github.com/emscripten-core/emsdk.git \
 && cd /emsdk \
 && ls -lha \
 && git pull \
 && ./emsdk install latest \
 && ./emsdk activate latest
 
ARG WD=/emsdk
WORKDIR ${WD}
ENV PATH="${WD}:${WD}/upstream/emscripten:$PATH" 
ENV EMSDK="${WD}"
ENV EMSDK_NODE="${WD}/node/$(ls)/bin/node" 

# quasar install
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt install -y nodejs
RUN npm i -g vue

# Настройка ssh доступа для отладчика gdb.
RUN useradd -rm -d /home/sshuser -s /bin/bash -g root -G sudo -u 1000 sshuser 
RUN echo 'sshuser:sshuser' | chpasswd
RUN mkdir -p /home/sshuser/.ssh

WORKDIR /Aerobike