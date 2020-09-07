#!/bin/bash


PACKAGE_NAME=snmp-collector-plugin
PACKAGE_PATH=$(dirname $(dirname "$(cd `dirname $0`; pwd)"))
LOG_DIRECTORY=$PACKAGE_PATH/log
LOG_FILE=$LOG_DIRECTORY/$PACKAGE_NAME.log


if ! type getopt >/dev/null 2>&1 ; then
  message="command \"getopt\" is not found"
  echo "[ERROR] Message: $message" >& 2
  echo "$(date "+%Y-%m-%d %H:%M:%S") [ERROR] Message: $message" > $LOG_FILE
  exit 1
fi

getopt_cmd=`getopt -o h -a -l help:,config-file-path:,exporter-host:,exporter-port: -n "start_script.sh" -- "$@"`
if [ $? -ne 0 ] ; then
    exit 1
fi
eval set -- "$getopt_cmd"


config_file_path="conf/snmp.yml"
exporter_host="127.0.0.1"
exporter_port=9116

print_help() {
    echo "Usage:"
    echo "    start_script.sh [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                 show help"
    echo "      --config-file-path     the path of config file (\"conf/snmp.yml\" by default)"
    echo "      --exporter-host        the listen address of exporter (\"127.0.0.1\" by default)"
    echo "      --exporter-port        the listen port of exporter (9116 by default)"
}

while true
do
    case "$1" in
        -h | --help)
            print_help
            shift 1
            exit 0
            ;;
        --config-file-path)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    config_file_path="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-host)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_host="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-port)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_port="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            message="argument \"$1\" is invalid"
            echo "[ERROR] Message: $message" >& 2
            echo "$(date "+%Y-%m-%d %H:%M:%S") [ERROR] Message: $message" > $LOG_FILE
            print_help
            exit 1
            ;;
    esac
done

mkdir -p $LOG_DIRECTORY

message="start exporter"
echo "[INFO] Message: $message"
echo "$(date "+%Y-%m-%d %H:%M:%S") [INFO] Message: $message" >> $LOG_FILE

cd $PACKAGE_PATH/script
chmod +x src/snmp_exporter
./src/snmp_exporter --config.file=$config_file_path --web.listen-address=$exporter_host:$exporter_port 2>&1 | tee -a $LOG_FILE
