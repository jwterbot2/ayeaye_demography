//Number of population samples (demes)
2
//Population effective sizes (number of genomes)
NCURNORTH$ sfspool 0
NCUROTHER$ sfspool 1
//Sample sizes - samples age - inbreeding coefficient
8
26
//Growth rates
EXPANDR$
EXPANDR$
//Number of migration matrices
1
//migration matrix
0.000 MIG$
MIG$ 0.000
//historical event: time, source, sink, migrants, new deme size, new growth rate, migration matrix index
4 historical event
GROWSTRT$ 0 0 0 1 0 0 nomig
GROWSTRT$ 1 1 0 1 0 0 nomig
BOTSTRT$ 0 1 1 NANC$ 0 0 nomig absoluteResize //Both subpopulations are merged in deme1 (others)
BOTSTRT$ 0 0 0 0 0 0 //North population is killed
//Number of independent loci (chromosomes)
1 0
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block: data type, num loci, rec. rate and mut rate + optional parameters
FREQ 1 1e-8 1.52e-8 OUTEXP
