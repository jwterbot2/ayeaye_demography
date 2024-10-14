#!/bin/bash
#SBATCH -N 1            # number of nodes
#SBATCH -n 1            # number of "tasks" (default: 1 core per task)
#SBATCH -p lightwork
#SBATCH -q public
#SBATCH -t 0-10:00:00   # time in d-hh:mm:ss
#SBATCH --mem=20000mb
#SBATCH -o [/PATH/TO/DEBUG/OUTPUT/DIRECTORY]/ayeaye_msmc2InfilePrep_full-nosil-ph17slurm.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e [/PATH/TO/DEBUG/OUTPUT/DIRECTORY]/ayeaye_msmc2InfilePrep_full-nosil-ph17.slurm.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --mail-user=john.terbot.jwt2@gmail.com # Mail-to address
#SBATCH --job-name=ayeaye_msmc2InfilePrep_full-nosil-ph17

#turn on debugging output
set -x;
echo "here we go"

echo "Starting Full, No Silence"
perl ayeaye-vcf2multihetsep-v0.04.pl "[/PATH/TO/INPUT/VCF]/ayeaye.scaffold_all.allSNPs.vcf" -out "[/PATH/TO/OUTPUT/DIRECTORY]/ayeaye.*.full.no-sil.ph17.msmc2.txt" -call "[/PATH/TO/CALL/MASKS]/ayeaye.*.callable.pos.txt" --fileType=pos -use "[/PATH/TO/USE/MASKS]/ayeaye.*.gcr.bed" --fileType=bed --invert -minPh 17