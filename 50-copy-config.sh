config_path=${CONFIG_PATH:-/config}
dest_path=${HTTPD_CONFIG_PATH:-/etc/nginx}

destfilename() {
    sourcefile=$1
    prefix=$2

    echo $(echo $(basename $sourcefile) | sed "s/^$prefix-//")
}

if [ -d $config_path ]; then
    for f in $(find ${config_path} -maxdepth 1 -type f -name "*.conf");do
        case $(basename $f) in
            default.conf)
                cp -v $config_path/default.conf ${dest_path}/conf.d/default.conf
                ;;
            conf.d-*.conf)
                cp -v $f $dest_path/conf.d/$(destfilename $f "conf.d")
                ;;
            *)
                cp -v $f ${dest_path}/
                ;;
        esac
    done
fi
