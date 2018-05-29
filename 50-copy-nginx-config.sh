
config_path=/config
nginx_conf_path=/etc/nginx
nginx_site_conf_file=default.conf

if [ -d $config_path ]; then
    for f in $config_path/*; do
        if [ -f $f ]; then
            cp -f $f $nginx_conf_path/
        fi
    done
    if [ -e $nginx_conf_path/$nginx_site_conf_file ]; then
        mv $nginx_conf_path/$nginx_site_conf_file $nginx_conf_path/conf.d/
    fi
fi