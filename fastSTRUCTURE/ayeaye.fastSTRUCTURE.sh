#!/bin/bash
#SBATCH -N 1            # number of nodes
#SBATCH -n 1            # number of "tasks" (default: 1 core per task)
#SBATCH -p general
#SBATCH -q public
#SBATCH -t 3-00:00:00   # time in d-hh:mm:ss
#SBATCH --mem=20000mb
#SBATCH -o [HOME/DIRECTORY]/slurms/ayeaye_STRUCTURE_240529.slurm.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e [HOME/DIRECTORY]/slurms/ayeaye_STRUCTURE_240529.slurm.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --mail-user=j[EMAIL] # Mail-to address
#SBATCH --job-name=ayeaye_STRUCTURE240529

#turn on debugging output
set -x;
echo "here we go"

echo "Starting K=1"
fastStructure -K 1 --input=[PATH/TO/STRUCTURE/INPUT/FILE]/ayeaye.scaffold_all.unlinked --output=[PATH/TO/STRUCTURE/OUTPUT/DIRECTORY]/ayeaye.scaffold_all.STRUCTURE_output_simple --full --seed=100 --format=str

echo "K=1 done, Starting K=2"
fastStructure -K 2 --input=[PATH/TO/STRUCTURE/INPUT/FILE]/STRUCTURE_240529/ayeayeffold_all.unlinked --output=[PATH/TO/STRUCTURE/OUTPUT/DIRECTORY]/ayeaye.scaffold_all.STRUCTURE_output_simple --full --seed=100 --format=str

echo "K=2 done, Starting K=3"
fastStructure -K 3 --input=[PATH/TO/STRUCTURE/INPUT/FILE]/STRUCTURE_240529/ayeaye.scaffold_all.unlinked --output=[PATH/TO/STRUCTURE/OUTPUT/DIRECTORY]/ayeaye.scaffold_all.STRUCTURE_output_simple --full --seed=100 --format=str

echo "K=3 done, Starting K=4"
fastStructure -K 4 --input=[PATH/TO/STRUCTURE/INPUT/FILE]/STRUCTURE_240529/ayeaye.scaffold_all.unlinked --output=[PATH/TO/STRUCTURE/OUTPUT/DIRECTORY]/ayeaye.scaffold_all.STRUCTURE_output_simple --full --seed=100 --format=str

echo "K=4 done, Starting K=5"
fastStructure -K 5 --input=[PATH/TO/STRUCTURE/INPUT/FILE]/STRUCTURE_240529/ayeaye.scaffold_all.unlinked --output=[PATH/TO/STRUCTURE/OUTPUT/DIRECTORY]/ayeaye.scaffold_all.STRUCTURE_output_simple --full --seed=100 --format=str

echo "did it work?"