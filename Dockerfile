FROM nginx:alpine

## START addition of DE from bcit/alpine
ENV RUNUSER none
ENV HOME /

RUN apk add --no-cache \
        tini

# Add docker-entrypoint script base
ENV DE_VERSION v1.1
ADD https://github.com/itsbcit/docker-entrypoint/releases/download/${DE_VERSION}/docker-entrypoint.tar.gz /docker-entrypoint.tar.gz
RUN tar zxvf docker-entrypoint.tar.gz && rm -f docker-entrypoint.tar.gz
RUN chmod -R 555 /docker-entrypoint.*


# Allow resolve-userid.sh script to run
RUN chmod 664 /etc/passwd /etc/group

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
## END addition of DE from bcit/alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf
COPY fastcgi.conf /etc/nginx/fastcgi.conf

RUN chown nginx:root /var/cache/nginx /var/run /var/log/nginx /run \
    && chmod 770 /var/cache/nginx \
    && chmod 775 /var/run /run /var/log/nginx

EXPOSE 8080

USER nginx
WORKDIR /application

CMD ["nginx", "-g", "daemon off;"]



#COPY nginx.conf /etc/nginx/nginx.conf
#COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf