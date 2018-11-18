#!/bin/bash

if [ -n "$*" ]
then
    echo "$*" >&2
    exit 0
else
