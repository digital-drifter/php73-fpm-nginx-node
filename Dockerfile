FROM richarvey/nginx-php-fpm:latest

ENV NODE_VERSION=11.4.0
ENV YARN_VERSION=1.12.3

ARG USERNAME

ARG GID

ARG UID

RUN apk update && apk add vim zsh git

RUN addgroup -g ${GID} ${USERNAME} && adduser -u ${UID} -G ${USERNAME} -s /bin/zsh -D ${USERNAME} && apk add --no-cache libstdc++ && apk add --no-cache --virtual .build-deps binutils-gold curl g++ gcc gnupg libgcc linux-headers make python && for key in 94AE36675C464D64BAFA68DD7434390BDBE9B9C5 FD3A5288F042B6850C66B31F09FE44734EB7990E 71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 DD8F2338BAE7501E3DD5AC78C273792F7D83545D C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 B9AE9905FFD7803F25714661B63B535A4C206CA9 77984A986EBC2AA786BC0F66B01FBB92821C587A 8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 4ED778F539E3634C779C87C6D7062848A1AB005C A48C2BEE680E841632CD4E44F07496B3EB3C1762 ; do gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; done && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - && tar -xf "node-v$NODE_VERSION.tar.xz" && cd "node-v$NODE_VERSION" && ./configure && make -j$(getconf _NPROCESSORS_ONLN) && make install && apk del .build-deps && cd .. && rm -Rf "node-v$NODE_VERSION" && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar && for key in 6A010C5166006599AA17F08146C2130DFD2497F5 ; do gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; done && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz && mkdir -p /opt && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz && apk del .build-deps-yarn

RUN curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew && chmod +x phpbrew && mv phpbrew /usr/local/bin/phpbrew

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && apk add --update --no-cache --virtual .build-deps-phpbrew alpine-sdk build-base lcov bzip2-dev curl-dev gettext-dev gmp-dev readline-dev libedit-dev libzip-dev

USER ${USERNAME}

RUN cd $HOME && phpbrew init && phpbrew install 7.3 +dba +ipv6 +dom +calendar +wddx +static +inifile +inline +cli +ftp +filter +gcov +zts +json +hash +exif +mbstring +mbregex +libgcc +pdo +posix +embed +sockets +debug +phpdbg +zip +bcmath +fileinfo +ctype +cgi +soap +pcntl +phar +session +tokenizer +opcache +imap +kerberos +xmlrpc +fpm +pcre +mhash +mcrypt +zlib +curl=/usr/bin/curl +readline +editline +gd +intl +icu +openssl +mysql +sqlite +xml +xml_all +gettext +iconv +bz2=/usr/bin/bzip2 +ipc +gmp

USER root

RUN apk del .build-deps-phpbrew

EXPOSE 443 80

WORKDIR "/var/www"

CMD ["/start.sh"]
