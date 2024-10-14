#!/bin/bash
modelName=$1;
maxRep=$2;

for (( rep = 0; rep < $maxRep; rep++ ))
do
	tar -xvzf $modelName".rep"$rep".out.tar.gz" $modelName".rep"$rep".out/"$modelName".rep"$rep".bestlhoods" --strip-components 1;
	
	if [ $rep -eq 0 ]
	then
		echo -n -e "rep\tmodel\t" > $modelName".combined.bestlhoods";
		head -n1 $modelName".rep"$rep".bestlhoods" >> $modelName".combined.bestlhoods";
	fi
	
	echo -n -e "$rep\t$modelName\t" >> $modelName".combined.bestlhoods";
	tail -n1 $modelName".rep"$rep".bestlhoods" >> $modelName".combined.bestlhoods";
	
	rm $modelName".rep"$rep".bestlhoods";
done
