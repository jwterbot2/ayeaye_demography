#!/bin/bash
#SBATCH -c 7
#SBATCH -N 1            # number of nodes
#SBATCH -n 1            # number of "tasks" (default: 1 core per task)
#SBATCH -p general
#SBATCH -q public
#SBATCH -t 7-00:00:00   # time in d-hh:mm:ss
#SBATCH --mem=400000mb
#SBATCH -o [/PATH/TO/DEBUG/OUTPUT/DIRECTORY]/ayeaye_msmc2-full-nosil-ph17.slurm.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e [/PATH/TO/DEBUG/OUTPUT/DIRECTORY]s/ayeaye_msmc2-full-nosil-ph17.slurm.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --mail-user=john.terbot.jwt2@gmail.com # Mail-to address
#SBATCH --job-name=ayeaye_msmc2-full-nosil-ph17

#turn on debugging output
set -x;
echo "here we go"
msmc2 -t 7 -I 0-16,0-17,0-18,0-19,0-20,0-21,0-22,0-23,1-16,1-17,1-18,1-19,1-20,1-21,1-22,1-23,2-16,2-17,2-18,2-19,2-20,2-21,2-22,2-23,3-16,3-17,3-18,3-19,3-20,3-21,3-22,3-23,4-16,4-17,4-18,4-19,4-20,4-21,4-22,4-23,5-16,5-17,5-18,5-19,5-20,5-21,5-22,5-23,6-16,6-17,6-18,6-19,6-20,6-21,6-22,6-23,7-16,7-17,7-18,7-19,7-20,7-21,7-22,7-23,8-16,8-17,8-18,8-19,8-20,8-21,8-22,8-23,9-16,9-17,9-18,9-19,9-20,9-21,9-22,9-23,10-16,10-17,10-18,10-19,10-20,10-21,10-22,10-23,11-16,11-17,11-18,11-19,11-20,11-21,11-22,11-23,12-16,12-17,12-18,12-19,12-20,12-21,12-22,12-23,13-16,13-17,13-18,13-19,13-20,13-21,13-22,13-23,14-16,14-17,14-18,14-19,14-20,14-21,14-22,14-23,15-16,15-17,15-18,15-19,15-20,15-21,15-22,15-23,24-16,24-17,24-18,24-19,24-20,24-21,24-22,24-23,25-16,25-17,25-18,25-19,25-20,25-21,25-22,25-23,26-16,26-17,26-18,26-19,26-20,26-21,26-22,26-23,27-16,27-17,27-18,27-19,27-20,27-21,27-22,27-23,28-16,28-17,28-18,28-19,28-20,28-21,28-22,28-23,29-16,29-17,29-18,29-19,29-20,29-21,29-22,29-23,30-16,30-17,30-18,30-19,30-20,30-21,30-22,30-23,31-16,31-17,31-18,31-19,31-20,31-21,31-22,31-23,32-16,32-17,32-18,32-19,32-20,32-21,32-22,32-23,33-16,33-17,33-18,33-19,33-20,33-21,33-22,33-23 -o [PATH/TO/OUTPUT/DIRECTORY]/ayeaye.full.no-sil.ph17 [PATH/TO/INPUT/FILES/PREPPED/BY/vcf2multihetsep-v0.04.pl]/ayeaye.*.full.no-sil.ph17.msmc2.txt
echo "did it work?"