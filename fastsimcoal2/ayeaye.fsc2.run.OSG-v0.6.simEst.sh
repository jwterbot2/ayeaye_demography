#!/bin/bash

echo "here we go"

#turn on debugging output
set -x;

#Get Operating Parameters
modelName=$1;
valName=$2;
simRep=$3;
rep=$4;

# untar software
tar -xzvf ayeaye.fsc2.OSG-v0.6.simEst.tar.gz

# add unzipped folder to path
export PATH=$_CONDOR_SCRATCH_DIR/ayeaye.fsc2.OSG-v0.6.simEst:$PATH
# enter the unzipped folder
cd ayeaye.fsc2.OSG-v0.6.simEst

#copy the model to the current folder with rep number
cp ./models/$modelName.est $modelName.$valName.simRep$simRep.rep$rep.est
cp ./models/$modelName.tpl $modelName.$valName.simRep$simRep.rep$rep.tpl


# possible debugging output to print the model input files
#cat $modelName.est
#cat $modelName.tpl
cp $valName/$valName"_"$simRep/$valName"_MSFS.obs" $modelName.$valName.simRep$simRep.rep$rep"_MSFS.obs"

echo "file prep ready"

# production run of fsc2
fsc28 -t $modelName.$valName.simRep$simRep.rep$rep.tpl -n 150000 -u -m -e $modelName.$valName.simRep$simRep.rep$rep.est -M -L 50 -y 10

# debugging run of fsc2
#fsc28 -t $modelName.$valName.simRep$simRep.rep$rep.tpl -n 3 -u -m -e $modelName.$valName.simRep$simRep.rep$rep.est -M -L 5 -y 3
echo "fastsimcoal2 completed, begin cleanup"

# move all results files into dir on top folder and tar it
mkdir ../$modelName.$valName.simRep$simRep.rep$rep.out
mv $modelName.$valName.simRep$simRep.rep$rep/* ../$modelName.$valName.simRep$simRep.rep$rep.out
mv seed.txt ../$modelName.$valName.simRep$simRep.rep$rep.out/seed.txt
cd ..
tar -czf $modelName.$valName.simRep$simRep.rep$rep.out.tar.gz $modelName.$valName.simRep$simRep.rep$rep.out/

#clean up
rm -r $modelName.$valName.simRep$simRep.rep$rep.out
rm -r ayeaye.fsc2.OSG-v0.6.simEst

echo "Finished successfully?"