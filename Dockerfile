FROM nginx:alpine

COPY nginx-default.conf /etc/nginx/conf.d/default.conf
COPY fastcgi.conf /etc/nginx/fastcgi.conf

USER root

EXPOSE 8080

WORKDIR /application

CMD ["nginx", "-g", "daemon off;"]
