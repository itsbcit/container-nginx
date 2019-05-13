FROM nginx:1.15-alpine

## START addition of DE from bcit/alpine
ENV RUNUSER none
ENV HOME /

RUN apk add --no-cache \
        tini

# Add docker-entrypoint script base
ENV DE_VERSION v1.5
ADD https://github.com/itsbcit/docker-entrypoint/releases/download/${DE_VERSION}/docker-entrypoint.tar.gz /docker-entrypoint.tar.gz
RUN tar zxvf docker-entrypoint.tar.gz && rm -f docker-entrypoint.tar.gz
RUN chmod -R 555 /docker-entrypoint.*


# Allow resolve-userid.sh script to run
RUN chmod 664 /etc/passwd /etc/group

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
## END addition of DE from bcit/alpine

RUN chown nginx:root /var/cache/nginx /var/run /var/log/nginx /run \
    && chmod 770 /var/cache/nginx \
    && chmod 775 /var/run /run /var/log/nginx \
    && sed -i "s/user  nginx;/#user  nginx;/" /etc/nginx/nginx.conf \
    && sed -i "s/listen       80;/listen       8080;/" /etc/nginx/conf.d/default.conf \
    #required for 50-copy-nginx-config.sh to copy config files
    && chmod 775 -R /etc/nginx/

COPY 50-copy-nginx-config.sh /docker-entrypoint.d/

RUN touch /usr/share/nginx/html/ping

USER nginx
WORKDIR /application

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
