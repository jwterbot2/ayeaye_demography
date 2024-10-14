# ayeaye_demography
## github repository for scripts and associated files for [paper citation].


### fastSTRUCTURE

	This folder contains two files. 
	The first file, "ayeaye.vcf2struc.spid", is the PGDSpider input file detailing how the vcf file
 	  should be converted to the input .str format used by STRUCTURE and fastSTRUCTURE.
	The second file, "ayeaye.fastSTRUCTURE.sh", contains commands used to call fastSTRUCTURE on 
 	  this data for 1 to 5 demes.

### MSMC2
	This folder contains three files.
	The first file, "vcf2mulithetsep-v0.04.pl", is a perl script used to prepare MSMC2 input files 
 	  from a vcf input file of all SNPs and two or three sets of mask files describing which sites
    	  should be included and how. For more information see the next file.
	The second file, "README-vcf2multihetsep.txt", contains further usage details for the 
	  "vcf2multihetsep-vX.XX.pl" script.
	The third file, "ayeaye.infilePrep.full-nosil-ph17.sh", contains an example command used to
 	  prepare a  vcf file for MSMC2 using "vcf2multihetsep-vX.XX.pl".
	The fourth file, "ayeaye.msmc2.full-nosil-ph17.sh", contains an example command used to run 
 	  MSMC2 on the input file prepared with the previous files.

### fastsimcoal2
	This folder contains ten files and two directories.
	The first directory, "Estimation Files", contains the 16 .est and 16 .tpl files detailing the 
 	  models tested and the initial parameter ranges used for use by fastsimcoal2 during 
    	  parameter estimation.
	The second directory, "Parameter Files", contains 5 .par files which detail the putatively 
 	  neutral genome of the ayea-aye and contain the best parameter values for the best four models
	  tested using fastsimcoal2 and approximating the model estimated by MSMC2. These files were 
   	  used by fastsimcoal2 to simulate site frequency spectra during the model confirmation step.
	The first file, "ayeaye.fsc2_MSFS.obs", is the observed site frequency spectra of the aye-aye
 	  in putatively neutral sites across the entire autosomal genome.
	The second file, "ayeaye.fsc2.modelList.csv", is a list of models tested and used by other
 	  scripts.
	The third file, "ayeaye.fsc2.modelList.simEst.csv", is a list of models with simulated SFS and
 	  simulation numbers used by other scripts.
	The fourth file, "ayeaye.fsc2.run.OSG-v0.5.sub", and fifth file, "ayeaye.fsc2.run.OSG-v0.5.sh",
 	  are the submission script used with OSG to manage the replicate runs of fastsimcoal2 during 
    	  initial parameter estimation as called by the shell script.
	The sixth, "combineReps-fsc2.wrapper.v0.2.sh", and seventh file, "combineReps-fsc2.v0.2.sh", 
 	  are simple management scripts used to combine the results of multiple reps of parameter 
    	  estimation of a particular model by fastsimcoal2 into a single file.
       	The eighth file, "ayeaye.fsc2.simulateSFS.sh" is an example call of fastsimcoal2 used to 
	  simulate SFS using a .par file.
	The ninth file, "ayeaye.fsc2.run.OSG-v0.6.simEst.sub", and tenth file, 
 	  "ayeaye.fsc2.run.OSG-v0.6.simEst.sh" are the submission script used with OSG to manage the 
    	  replicate runs of fastsimcoal2 during parameter estimation using the simulated SFS as called
       	  by the shell script.

### dadi

### demesdraw
	This folder contains five .yaml files in the Demes format describing the best model and 
 	  parameters for MSMC2 (approximate best model), fastsimcoal2 (best 3 models), and dadi
    	  (best model).
