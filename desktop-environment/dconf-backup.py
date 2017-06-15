#!/usr/bin/env python
from subprocess import Popen, PIPE
from pathlib import Path
import os
import sys
import yaml
import argparse

parser = argparse.ArgumentParser(description='Backup settings from dconf.')
parser.add_argument('configs', metavar='CONFIG_FILE', nargs='+',
                    help='YAML configuration files containing a list of (name, dconf-dir) pairs to be backed up')
parser.add_argument('--config-root', metavar='DIR', default=None,
                    help="Directory where the INI files will be written. By default, dir/config where dir is this script's directory.")
args = parser.parse_args()


for config_path in args.configs:
    with open(config_path) as f:
        config = yaml.load(f)

    if 'config-root' not in config:
        print('Configuration file', config_path, 'contains no config-root')
        continue

    config_root = Path(config_path).parent / Path(config['config-root'])
    config_root = config_root.resolve()
    if not config_root.is_dir():
        print('The config-root from', config_path, 'is not a directory')
        continue

    for name, path in config['dconf-dirs']:
        print('Saving config for ', name, '...', sep='', end=' ', flush=True)
        ini_file = config_root / (name + '.ini')
        if not ini_file.exists():
            with ini_file.open(mode='w') as f: f.write('\n')

        inisort = Popen(['inisort', ini_file, '-o', ini_file], stdin=PIPE)
        dconf = Popen(['dconf', 'dump', path], stdout=inisort.stdin)

        dconf.wait()
        if dconf.returncode != 0: sys.exit(dconf.returncode)
        inisort.stdin.close()
        inisort.wait()
        if inisort.returncode != 0: sys.exit(inisort.returncode)
        print('done')
