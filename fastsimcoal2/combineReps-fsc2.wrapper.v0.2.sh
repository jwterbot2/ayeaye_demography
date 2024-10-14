#!/bin/bash

modelList=$1;

while IFS= read -r line
do
	bash combineReps-fsc2.v0.2.sh $line 250
done <$1
