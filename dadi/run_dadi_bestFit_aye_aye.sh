#!/bin/bash

# have job exit if any command returns with non-zero exit status (aka failure)
set -e

# replace env-name on the right hand side of this line with the name of your conda environment
ENVNAME=dadienv2

# if you need the environment directory to be named something other than the environment name, change this line
ENVDIR=$ENVNAME

# these lines handle setting up the environment; you shouldn't have to modify them
export PATH
mkdir $ENVDIR
tar -xzf $ENVNAME.tar.gz -C $ENVDIR
. $ENVDIR/bin/activate

# modify environment variables
export PATH=$_CONDOR_SCRATCH_DIR/build:$PATH

# untar software
#tar -xzf dadi_mff.tar.gz
#cd dadi_sfv


# modify this line to run your desired Python script and any other work you need to do
python3 dadi_aye_aye_bestFit.py \
-inFile pop0-pop1.sfs \
-outFile dadi_$1.txt

cp *.txt .
