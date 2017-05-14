#!/usr/bin/python

from sys import argv, stderr
from subprocess import Popen, DEVNULL


if __name__ == '__main__':
	if len(argv) < 2:
		exit(0)

	try:
		Popen(argv[1:], stdout=DEVNULL, stderr=DEVNULL)

	except OSError as err:
		print(err.strerror, file=stderr)
		exit(err.errno)
