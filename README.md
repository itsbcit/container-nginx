# nginx OpenShift image

## Default Behavior

Running the image without any modifitcation gives default "Welcome to nginx!"

Runs on port 8080

## How to Modify

### Extend the Image

The following directories house configuration files

- `/etc/nginx/`

- `/etc/nginx/conf/`

  so copy your relevent config files there. Example Dockerfile:

```dockerfile
FROM artifactory.repo.addr/openshift-nginx
COPY nginx.conf /etc/nginx/
COPY fastcgi_params /etc/nginx/
COPY default.vh.conf /etc/nginx/conf/default.conf
COPY my_website_code /path/configured/in/default.conf/above
```

### Using OpenShift ConfigMaps/Volumes

The image has a docker-entrypoint script that checks for the existence of /config

The following filenames within /config are looked for to be copied to their proper configuration locations for nginx

| **filename in /config** | **destination**                |
| ----------------------- | ------------------------------ |
| `nginx.conf`            | `/etc/nginx/nginx.conf`        |
| `fastcgi.conf`          | `/etc/nginx/fastcgi.conf`      |
| `fastcgi_params`        | `/etc/nginx/fastcgi_params`    |
| `default.conf`          | `/etc/nginx/conf/default.conf` |

Only `default.conf` is required.

The above files can be added as key/value (filename/contents) as a ConfigMap within Openshift and mounted to `/config`.

You will then need to create a PVC/Volume within OpenShift to match the website configuration directory in `default.conf`.

1. Create ConfigMap in OpenShift with the contents required.

2. Create PVC in OpenShift

3. Add Config file under Deployment > Configuration > Volumes to /config

4. Add the your volume to the same area to `/where/ever/your/nginx/conf/application/points` (maybe `/applcation/www`)

5. Redeploy Pod

6. Rsync code to `/where/ever/your/nginx/conf/application/points`
