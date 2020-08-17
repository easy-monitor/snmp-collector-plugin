#!/usr/local/easyops/python/bin/python
# -*- coding: UTF-8 -*-

import os
import subprocess


def run_command(command, env={}, shell=False, close_fds=True):
    process = subprocess.Popen(
        command,
        env=env,
        shell=shell,
        close_fds=close_fds
    )

    return process.returncode


if __name__ == '__main__':
    argument_map = {
        '--snmp-yaml-path': 'snmp_yaml_path',
        '--exporter-host': 'exporter_host',
        '--exporter-port': 'exporter_port'
    }
    
    arguments = []
    for argument, env in argument_map.iteritems():
        env_value = os.environ.get('EASYOPS_COLLECTOR_' + env)
        if env_value is not None:
            arguments.append('{} {}'.format(argument, env_value))
    
    command = 'sh ./deploy/start_script.sh {}'.format(' '.join(arguments))
    run_command(command, shell=True)
