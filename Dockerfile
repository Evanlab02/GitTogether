FROM python:3.12.4-alpine3.20 AS docs

COPY ./docs/requirements.txt /build/install/
WORKDIR /build/install

RUN pip install -r requirements.txt

COPY ./docs /build/docs/
WORKDIR /build/docs

RUN mkdocs build

FROM caddy:2.8.4-alpine

COPY --from=docs /build/docs/site/ /var/www/html/docs/
COPY web/Caddyfile /etc/caddy/Caddyfile