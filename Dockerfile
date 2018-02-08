FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf
COPY fastcgi.conf /etc/nginx/fastcgi.conf

RUN chown nginx:root /var/cache/nginx
RUN chmod 770 /var/cache/nginx
RUN chown nginx:root /var/run /run
RUN chmod 775 /var/run /run

USER nginx

EXPOSE 8080

WORKDIR /application

CMD ["nginx", "-g", "daemon off;"]
