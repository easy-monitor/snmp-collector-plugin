#!/bin/bash

kill -9 $(cat exporter.pid)

rm -rf exporter.pid
