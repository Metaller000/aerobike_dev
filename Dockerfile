FROM ubuntu:22.04 as aerobike_dev
LABEL maintainer="Rostislav Velichko <rostislav.vel@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt update 
RUN apt install -y \
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
	rsync \ 
	bash-completion \
	net-tools \
	language-pack-ru

ENV LANGUAGE ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8
RUN locale-gen ru_RU.UTF-8 && dpkg-reconfigure locales
ENV TERM=xterm-256color
RUN echo "PS1='\e[92m\u\e[0m@\e[94m\h\e[0m:\e[35m\w\e[0m# '" >> /root/.bashrc
RUN echo "if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi" >> /root/.bashrc
	
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
RUN npm i -g @vue/cli

# Настройка vscode web.
RUN curl -fOL https://github.com/coder/code-server/releases/download/v4.91.1/code-server_4.91.1_amd64.deb \ 
 && dpkg -i code-server_4.91.1_amd64.deb \
 && rm code-server_4.91.1_amd64.deb \
 && code-server --install-extension ms-ceintl.vscode-language-pack-ru

RUN echo "bind-addr: 0.0.0.0:666" > /root/.config/code-server/config.yaml \
 && echo "cert: false" >> /root/.config/code-server/config.yaml \
 && echo '{ "workbench.colorTheme": "Default Dark Modern" }' > /root/.local/share/code-server/User/settings.json

WORKDIR /Aerobike

ENTRYPOINT code-server --disable-workspace-trust --auth none --locale ru --open /Aerobike