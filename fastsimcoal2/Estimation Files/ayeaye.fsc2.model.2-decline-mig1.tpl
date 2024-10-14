//Number of population samples (demes)
2
//Population effective sizes (number of genomes)
NCURNORTH$ sfspool 0
NCUROTHER$ sfspool 1
//Sample sizes - samples age - inbreeding coefficient
8
26
//Growth rates
DECLRATE$
DECLRATE$
//Number of migration matrices
1
//migration matrix
0.000 MIG$
MIG$ 0.000
//historical event: time, source, sink, migrants, new deme size, new growth rate, migration matrix index
2 historical event
DECLEND$ 0 1 1 NANC$ 0 0 nomig absoluteResize //Both subpopulations are merged in deme1 (others)
DECLEND$ 0 0 0 0 0 0 //North population is killed
//Number of independent loci (chromosomes)
1 0
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block: data type, num loci, rec. rate and mut rate + optional parameters
FREQ 1 1e-8 1.52e-8 OUTEXP
