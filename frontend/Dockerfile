FROM node:14-alpine as build-deps
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY .env* ./
COPY src/ ./src/
COPY public/ ./public/
RUN npm run build

RUN apk add \
  --no-cache \
  git \
  autoconf \
  automake \
  libtool \
  build-base \
  && cd /usr/src \
  && git clone https://github.com/stedolan/jq.git

WORKDIR /usr/src/jq

RUN git submodule update --init \
  && autoreconf -fi \
  && ./configure --disable-docs --disable-maintainer-mode --with-oniguruma \
  && make -j8 LDFLAGS=-all-static \
  && strip jq


FROM busybox:musl

COPY .docker/*.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*.sh \
  && adduser -D static \
  && echo "E404:/home/static/index.html" > /home/static/httpd.conf

USER static
COPY --from=build-deps /usr/src/jq/jq /bin/

ENV PUBLIC_HTML=/home/static/
COPY --from=build-deps /usr/src/app/build /home/static
EXPOSE 80

CMD ["run-parts", "/docker-entrypoint.d/"]
