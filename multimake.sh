#!/bin/bash

for target in "$@"; do
    ./make.sh "$target" &
done
wait
