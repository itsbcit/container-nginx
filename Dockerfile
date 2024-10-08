FROM bcit.io/library/alpine:3.20-latest

LABEL maintainer="chriswood@gmail.com,jesse@weisner.ca"
LABEL build_id="1726246919"
LABEL nginx_version="1.26.0"

ENV RUNUSER nginx
ENV HOME /var/cache/nginx

RUN printf "%s%s%s\n" \
        "https://nginx.org/packages/alpine/" \
        "v3.20" \
        "/main" \
    | tee -a /etc/apk/repositories \
 && wget -O /etc/apk/keys/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
 && apk add --no-cache \
    nginx=1.26.2-r0 \
    nginx-mod-http-geoip2=1.26.2-r0 \
    nginx-mod-stream-geoip2=1.26.2-r0 \
    nginx-mod-http-image-filter=1.26.2-r0 \
    nginx-mod-http-xslt-filter=1.26.2-r0 \
    nginx-mod-http-js=1.26.2-r0 \
    nginx-mod-stream-js=1.26.2-r0

RUN mkdir /application /config \
    && chown nginx:root /var/lib/nginx /var/run /var/log/nginx /run \
    && chmod 1777 /var/lib/nginx/tmp \
    && chmod 775 /var/run /run /var/log/nginx /application \
    && ln -sf /var/lib/nginx/html/index.html /application/index.html \
    && chown nginx:root -R /etc/nginx \
    && find /etc/nginx -type d -exec chmod 775 \{\} \; \
    && find /etc/nginx -type f -exec chmod 664 \{\} \; \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY files/50-copy-config.sh /docker-entrypoint.d/
COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/default.conf /etc/nginx/http.d/default.conf
COPY files/http.d-log_format.conf /etc/nginx/http.d/log_format.conf
COPY files/conf.d-stream.conf /etc/nginx/conf.d/stream.conf

RUN chown -R nginx:root /etc/nginx \
 && chmod 0664 /etc/nginx/nginx.conf \
               /etc/nginx/http.d/* \
               /etc/nginx/conf.d/* \
               /etc/nginx/modules/* \
 && touch /var/lib/nginx/html/ping

USER nginx
WORKDIR /application

EXPOSE 8080
ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
