config_path=${NGINX_CONFIG_PATH:-/config}

if [ -d $config_path ]; then
    for f in $(find ${config_path} -name '*.conf' -type f);do
        case "$f" in
            "${config_path}/default.conf")
                cp $config_path/default.conf /etc/nginx/conf.d/default.conf
                ;;
            *)
                cp $f /etc/nginx/
                ;;
        esac
    done
fi
