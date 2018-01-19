FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf
COPY fastcgi.conf /etc/nginx/fastcgi.conf

RUN chmod 1777 /var/cache/nginx
RUN chmod 1777 /var/run

USER nginx

EXPOSE 8080

WORKDIR /application

CMD ["nginx", "-g", "daemon off;"]
