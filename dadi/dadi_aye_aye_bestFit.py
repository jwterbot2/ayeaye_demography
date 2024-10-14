import multiprocessing
import dadi
import pandas as pd
import numpy as np
import random
import argparse
from itertools import product
import numpy
#Example usage:

#python3 dadi_sps.py -start 1 -inFile test.fs -outFile results.txt

#for i in $(seq 1 100); do python3 dadi_two_epoch.py -Na_lb -2 -Na_ub 2 -t_lb -2 -t_ub 3 -nu_reps 15 -t_reps 8 \
#-inFile dadi_inputFiles/sfs_files/demog_only/stationary/rr_fixed_mu_fixed/1Mb_rep"$i".fs \
#-outFile dadi_inputFiles/sfs_files/demog_only/stationary/rr_fixed_mu_fixed/results/"$i".txt; done

#Parse arguments
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
parser.add_argument('-inFile', dest = 'inFile', action='store', nargs = 1, type = str, help = 'path to input file')
parser.add_argument('-outFile', dest = 'outFile', action='store', nargs = 1, type = str, help = 'path to output file')

#read input parameters
args = parser.parse_args()
inFile = args.inFile[0]
outFile = args.outFile[0]


from dadi import Numerics, PhiManip, Integration, Spectrum

def bottleneck_split_sizeChange(params, ns, pts):
    """
    params = (nu1b,nu2b,Ts,Tg,nu1f,nu2f)
    ns = (n1,n2)

    Asymmetric split via bottleneck at time Ts, followed by exponential growth/decline at time Ts.

    nu1b: Ratio of population size in pop1 to ancient population size following split
    nu2b: Ratio of population size in pop2 to ancient population size following split
    Ts: Time in the past at which population split happened (in units of 2*Na generations)
    Tg: Time in the past at which growth/decline began (in units of 2*Na generations)
    nu1f: Ratio of population size in pop1 to ancient population size at time of sampling (ie after growth/decline)
    nu2f: Ratio of population size in pop2 to ancient population size at time of sampling (ie after growth/decline)
    n1,n2: Sample sizes of resulting Spectrum
    pts: Number of grid points to use in integration.
    """
    nu1b, nu2b, Ts, Tg, nu1f, nu2f = params
    
    xx = Numerics.default_grid(pts)
    phi = PhiManip.phi_1D(xx)
    
    phi = PhiManip.phi_1D_to_2D(xx, phi)
    phi = Integration.two_pops(phi, xx, Ts, nu1b, nu2b, m12 = 0, m21 = 0)
    
    nu1_func = lambda t: nu1b*numpy.exp(numpy.log(nu1f/nu1b) * t/Tg)
    nu2_func = lambda t: nu2b*numpy.exp(numpy.log(nu2f/nu2b) * t/Tg)
    #nu1_func = lambda t: nu1b * (nu1f/nu1b)**(t/Tg)
    #nu2_func = lambda t: nu2b * (nu2f/nu2b)**(t/Tg)
    
    phi = Integration.two_pops(phi, xx, Tg, nu1_func, nu2_func, m12 = 0, m21 = 0)
    fs = Spectrum.from_phi(phi, ns, (xx, xx))
    
    return fs



fs = dadi.Spectrum.from_file(inFile)
ns = np.array([8,26])
pts_l = [54, 74, 94]

p0 = [0.1, 0.1, 0.05, 0.005, 0.1, 0.1]
lp = [0.01, 0.01, 0.01, 0.001, 0.01, 0.01]
up = [0.5, 0.5, 0.1, 0.01, 0.5, 0.5]
p0 = dadi.Misc.perturb_params(p0, fold=2, upper_bound=up, lower_bound=lp)

func = bottleneck_split_sizeChange
#
# Make the extrapolating version of our demographic model function.
func_ex = dadi.Numerics.make_extrap_log_func(func)
popt = dadi.Inference.optimize(p0, fs, func_ex, pts_l, lower_bound=lp,
upper_bound=up, verbose=False, full_output=True, maxiter=300)

#Calculate the best-fit model AFS.
model = func_ex(popt[0], np.array([8,26]), pts_l)
# Likelihood of the data given the model AFS.
ll_model = dadi.Inference.ll_multinom(model, fs)
theta = dadi.Inference.optimal_sfs_scaling(model, fs)

with open(outFile, "a") as f:
	f.write(str(p0[0]) + "\t" + str(p0[1]) + "\t" + str(p0[2]) + "\t" + str(p0[3]) + "\t" + str(p0[4]) + "\t" + str(p0[5]) + "\t" + 
str(popt[0][0]) + "\t" + str(popt[0][1]) + "\t" + str(popt[0][2]) + "\t" + str(popt[0][3]) + "\t" + str(popt[0][4]) + "\t" + 
str(popt[0][5]) + "\t" + str(theta) + "\t" + str(ll_model))

