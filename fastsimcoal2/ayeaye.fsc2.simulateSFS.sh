#!/bin/bash

fsc28 -i params/[MODEL].par -n100 -m -s0 --jobs --header --noarloutput -u -k 3000000
find [MODEL]/ -mindepth 2 -exec "cat" {} \; > [MODEL].simSFS.txt