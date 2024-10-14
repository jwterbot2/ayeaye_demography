#!/bin/bash

echo "here we go"

#turn on debugging output
set -x;

#Get Operating Parameters
modelName=$1;
rep=$2;

# untar software
tar -xzvf ayeaye.fsc2.OSG-v0.5.tar.gz

# add unzipped folder to path
export PATH=$_CONDOR_SCRATCH_DIR/ayeaye.fsc2.OSG-v0.5:$PATH
# enter the unzipped folder
cd ayeaye.fsc2.OSG-v0.5

#copy the model to the current folder with rep number
cp ./models/$modelName.est $modelName.rep$rep.est
cp ./models/$modelName.tpl $modelName.rep$rep.tpl


# possible debugging output to print the model input files
#cat $modelName.est
#cat $modelName.tpl

cp ayeaye.fsc2_MSFS.obs $modelName.rep$rep"_MSFS.obs"

echo "file prep ready"

# production run of fsc2
fsc28 -t $modelName.rep$rep.tpl -n 150000 -u -m -e $modelName.rep$rep.est -M -L 50 -y 10

# debugging run of fsc2
#fsc28 -t $modelName.rep$rep.tpl -n 3 -u -m -e $modelName.rep$rep.est -M -L 5 -y 3
echo "fastsimcoal2 completed, begin cleanup"

# move all results files into dir on top folder and tar it
mkdir ../$modelName.rep$rep.out
mv $modelName.rep$rep/* ../$modelName.rep$rep.out
mv seed.txt ../$modelName.rep$rep.out
cd ..
tar -czf $modelName.rep$rep.out.tar.gz $modelName.rep$rep.out/

#clean up
rm -r $modelName.rep$rep.out
rm -r ayeaye.fsc2.OSG-v0.5

echo "Finished successfully?"