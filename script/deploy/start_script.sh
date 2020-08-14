#!/bin/bash

if ! type getopt >/dev/null 2>&1 ; then
  echo "Error: command \"getopt\" is not found" >&2
  exit 1
fi

getopt_cmd=`getopt -o h -a -l snmp-yaml-path:,exporter-host:,exporter-port: -n "start.sh" -- "$@"`
if [ $? -ne 0 ] ; then
    exit 1
fi
eval set -- "$getopt_cmd"

snmp_yaml_path="./src/snmp.yml"
exporter_host="127.0.0.1"
exporter_port=9116

print_help() {
    echo "Usage:"
    echo "    start_script.sh [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                 show help"
    echo "      --snmp-yaml-path       the path of snmp.yml (\"./src/snmp.yml\" by default)"
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
        --snmp-yaml-path)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    snmp_yaml_path="$2"
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
            echo "Error: argument \"$1\" is invalid" >&2
            echo ""
            print_help
            exit 1
            ;;
    esac
done

if [ -f exporter.pid ]; then
    echo "The SNMP exporter has already started."
    exit 0
fi

chmod +x ./src/snmp_exporter

./src/snmp_exporter --config.file="$snmp_yaml_path" --web.listen-address="$exporter_host:$exporter_port" &
echo $! > exporter.pid
