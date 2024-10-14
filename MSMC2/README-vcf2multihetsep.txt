## README for vcf2multihetsep-vXXXX.pl

This is a perl script which helps to convert a vcf file into the input format used by MSMC2.
It assumes the sampled genomes are all diploid with phased sites marked by "|" and unphased
sites marked with "/". All scaffolds should be contained within the vcf; however, mask files
should be divided by scaffold into their own files. Mask sets should be given in the command
line with an asterisk "*" where the scaffold name is in the mask files.

The following are required input arguments:
	 1. [no flag] The input vcf containing all SNPs (or all sequenced sites) in the genome of interest.
	 2. [-use flag] A set of mask files detailing the location of sites within your region of interests (e.g., putatively neutral sites).
	    Only variable sites (meeting minimum phasing requirements) within the "use mask" will be included in the output file(s).
	 3. [-call flag] A set of mask files detailing the location of all called sites (i.e., sites which passed quality and depth filtering).
	    All sites that are not variant within the input vcf and are within the "call mask" file(s) are counted as intervening invariant sites.
	 4. [-out flag] The path and file template for the output files generated (one per chromosome/scaffold).

There are also the following optional arguments:
	 5. [-sil flag] A set of mask files detailing the location of sites that should not be included as variant or invariant sites.
	    If the silence mask(s) is used, then invariant sites within the call mask and the [sil]encing mask are not counted as intervening invariant sites.
	 6. [-minPhased flag] An integer number of the minimum number of individuals for a variant site that must be phased or homozygous to be included as a variant site in the output.
	    If a site is variant and does not meet this requirement, then it is not included in the output file, but it will not be counted as an intervening invariant site.
	 7. [-help] Prints the current help output and terminates the script.
	 8. [-debug] Turns on debugging output.

Finally, each mask argument can be followed by the following double-flag arguments which impact how they are interpreted by the script:
	 9. [--invert] Sites within the mask file are considered to be outside of the mask's region and vice-versa.
	10. [--fileType=[bed/bin/pos]] Details the format of the mask file(s) as either a bed file (NO HEADER LINE), a binary text file (string of 1s and 0s for inclusion/exclusion), or a positions text file (list of chromosome/scaffold positions to include, one per line).