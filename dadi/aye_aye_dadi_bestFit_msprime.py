import sys
import pandas as pd
import math
import os
import numpy as np
import msprime
import tskit
import libsequence
import allel
import argparse


#Example input
#python aye_aye_null_msprime.py -region 1 -seq_len 50000 -num_replicates 100 \
#-outPath "/home/vivak/"

#parsing user given constants
parser = argparse.ArgumentParser(description='Information about length of region and sample size')
parser.add_argument('-region', dest = 'region', action='store', nargs = 1, type = int, help = 'Region')
parser.add_argument('-num_replicates', dest = 'num_replicates', action='store', nargs = 1, type = int, help = 'Number of replicates')
parser.add_argument('-outPath', dest = 'outPath', action='store', nargs = 1, type = str, help = 'path to output files (suffixes will be added)')

args = parser.parse_args()
region = args.region[0]
num_replicates = args.num_replicates[0]
outPath = args.outPath[0]


chr_lens = { 1:18602764, 2:16060938, 3:17214299, 4:14784439, 5:12151006, 6:12101961, 7:8717938, 8:9958554, 10:6331343, 11:2950556, 12:2046229, 13:1970739, 14:1919907, 15:1563188 }


N = 11500
t_bot = (N*2) * 0.0549174625689796
N_north_bot =  N*0.355403666221184
N_other_bot =  N*0.137021865854324

t_decline = (N*2) * 0.00172136143868719
N_north_current = N * 0.0704885026776735
N_other_current = N * 0.0584577419749795

r_north = (N_north_current/N_north_bot)**(1/t_decline)-1.0008235
r_other = (N_other_current/N_other_bot)**(1/t_decline)-1.0002291


def aye_aye_demog(seq_len, num_replicates):
    demography = msprime.Demography()
    demography.add_population(
        name="nonNorth",
        description="Other Aye-Aye population",
        initial_size=N_other_current,
        growth_rate=r_other,
    )

    demography.add_population(
        name="North",
        description="North Aye-Aye population",
        initial_size=N_north_current,
        growth_rate=r_north,
    )

    demography.add_population(
        name="Ancestral",
        description="Ancestral Aye-Aye population",
        initial_size=N,
        growth_rate=0,
    )

    #Add events
    demography.add_population_parameters_change(time=t_decline, growth_rate=0, population="nonNorth")
    demography.add_population_parameters_change(time=t_decline, growth_rate=0, population="North")
    demography.add_population_split(time=t_bot, derived=["North", "nonNorth"], ancestral="Ancestral")
    demography.sort_events()

    ancestry_reps = msprime.sim_ancestry(
        {"North": 4, "nonNorth": 13}, 
        demography=demography, 
        sequence_length = seq_len,
        recombination_rate = 1e-8,
        num_replicates=num_replicates)

    for ts in ancestry_reps:
        mutated_ts = msprime.sim_mutations(ts, rate=1.52e-8)
        yield mutated_ts


ts_list = []
for replicate_index, ts in enumerate(aye_aye_demog(chr_lens[region], num_replicates)):
    ts_list.append(ts)


for rep, ts in enumerate(ts_list):
    #sfs = ts.allele_frequency_spectrum(sample_sets=[[x for x in range(0, 26)], [x for x in range(26, 34)]])
    #np.savetxt(outPath + "/scaffold" + str(region) + "_rep" + str(rep) + ".sfs", sfs)
    #ts.dump(outPath + "/scaffold" + str(region) + "_rep" + str(rep) + ".ts")
    out = open(outPath + "/scaffold" + str(region) + "_rep" + str(rep) + ".vcf", "w")
    tskit.TreeSequence.write_vcf(ts, out)
