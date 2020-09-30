FROM bcit/alpine:3.10
LABEL maintainer="chriswood@gmail.com,jesse@weisner.ca"
LABEL alpine_version="3.10"
LABEL nginx_version="1.16.1"
LABEL nginx_njs_version="0.3.5"
LABEL nginx_apk_release="1"
LABEL build_id="1601507015"

ENV RUNUSER nginx
ENV HOME /var/cache/nginx

RUN printf "%s%s%s\n" \
        "https://nginx.org/packages/alpine/v" \
        "3.10" \
        "/main" \
    | tee -a /etc/apk/repositories \
 && wget -O /etc/apk/keys/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
 && apk add --no-cache \
    nginx=1.16.1-r1 \
    nginx-module-geoip=1.16.1-r1 \
    nginx-module-image-filter=1.16.1-r1 \
    nginx-module-xslt=1.16.1-r1 \
    nginx-module-njs=1.16.1.0.3.5-r1

RUN mkdir /application /config \
 && chown nginx:root /var/cache/nginx /var/run /var/log/nginx /run \
 && chmod 770 /var/cache/nginx \
 && chmod 775 /var/run /run /var/log/nginx /application \
 && ln -sf /usr/share/nginx/html/index.html /application/index.html \
 #required for 50-copy-nginx-config.sh to copy config files
 && chmod 775 -R /etc/nginx/ \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

COPY 50-copy-config.sh /docker-entrypoint.d/
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

RUN touch /usr/share/nginx/html/ping

USER nginx
WORKDIR /application

EXPOSE 8080
ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
