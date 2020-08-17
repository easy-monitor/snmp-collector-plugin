#!/bin/bash

if [ ! -f exporter.pid ]; then
    echo "The SNMP exporter is not started."
    exit 0
fi

kill -9 $(cat exporter.pid)

rm -rf exporter.pid
