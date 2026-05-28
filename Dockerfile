FROM docker.io/itzcrazykns1337/vane:v1.12.2

USER root

RUN apt-get update \
  && apt-get install -y --no-install-recommends nginx apache2-utils \
  && rm -rf /var/lib/apt/lists/*

COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /usr/local/bin/render-start

RUN chmod +x /usr/local/bin/render-start

EXPOSE 10000

CMD ["/usr/local/bin/render-start"]
