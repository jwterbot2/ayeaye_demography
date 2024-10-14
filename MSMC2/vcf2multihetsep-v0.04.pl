#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $DEBUG = 1;

print "$0\n" if ($DEBUG);
print "@ARGV\n\n" if ($DEBUG);

	
#vcf file of variant sites; assumes all SNPs on a scaffold are in position order and continuous.
my $vcfInfile = "infile.vcf";

#Paramters defining the use mask filter conventions; this is the mask of positions that should be included in the final file if phased
#Expected naming convention of [PREFIX].[SCAFFOLD_NAME].[POSTFIX]
my %useMaskInfo = (template => "", prefix => "", postfix => "", type => "bin", invert => 0);

#Paramters defining the callable invariants mask filter conventions; this is the mask of callable invariant positions in data set
#Expected naming convention of [PREFIX].[SCAFFOLD_NAME].[POSTFIX]
my %callMaskInfo = (template => "", prefix => "", postfix => "", type => "pos", invert => 0);

#Paramters defining the silence mask filter conventions; this is the mask of positions that should not be included as either variants or the invariant count
#Expected naming convention of [PREFIX].[SCAFFOLD_NAME].[POSTFIX]
my %silMaskInfo = (template => "", prefix => "", postfix => "", type => "bed", invert => 0);
my $useSilMask = 1;

my %maskInfo = (use => \%useMaskInfo, call => \%callMaskInfo, sil => \%silMaskInfo);

my %outfileInfo = (template => "*.outfileDemo.msmc2.txt", prefix => "", postfix => "");

my $scafPre = "Scaffold_";
my $minPhased = 6;
my $checkPhased = 1;
my $sampleN = 7;

my $curCLA = "";
my $settingParam = 0;
foreach my $cl_arg (@ARGV)
{
	if (substr($cl_arg,0,1) ne "-" || $settingParam)
	{	
		if ($settingParam)
		{
			print("Setting parameter $curCLA to $cl_arg\n") if ($DEBUG);

			if($curCLA eq "use" || $curCLA eq "call" || $curCLA eq "sil")
			{
				${$maskInfo{$curCLA}}{'template'} = $cl_arg;
			}
			elsif($curCLA eq "checkPhased" || $curCLA eq "chkPh")
			{
				print("$cl_arg\n") if ($DEBUG);
				if($cl_arg != 0 && $cl_arg != 1)
				{
					print("Parameter checkPhased must be set to a boolean value (0 or 1). Exiting.\n") if ($DEBUG);
					die("Parameter checkPhased must be set to a boolean value (0 or 1). Exiting.\n");
				}
				$checkPhased = $cl_arg;
			}
			elsif($curCLA eq "minPhased" || $curCLA eq "minPh")
			{
				if($cl_arg > 0)
				{
					$minPhased = $cl_arg;
				}
				else
				{
					print("minPhased must be an integer 1 or greater. Exiting. \n") if ($DEBUG);
					die("minPhased must be an integer 1 or greater. Exiting. \n");
				}
			}
			elsif($curCLA eq "out")
			{
				$outfileInfo{'template'} = $cl_arg;
			}
			else
			{
				print("The parameter $curCLA is not an option to be changed. Exiting.\n") if ($DEBUG);
				die("The parameter $curCLA is not an option to be changed. Exiting. \n");
			}

			$settingParam = 0;
		}
		elsif (substr($cl_arg, length($cl_arg)-4, 4) ne ".vcf")
		{
			print("Unflagged input must be a .vcf file. Exiting.\n") if ($DEBUG);
			die("Unflagged input must be a .vcf file. Exiting.\n");
		}
		else
		{
			$vcfInfile = $cl_arg;
			$curCLA = "vcfIn";
		}
	}
	elsif (substr($cl_arg,1,1) eq "-")
	{
		if (substr($cl_arg,2,4) eq "help")
		{
			#PRINT HELP AND EXIT
			print("This is the help output. Now exiting.\n");
			exit 1;
		}
		elsif (substr($cl_arg,2,5) eq "debug")
		{
			$DEBUG = 1;
		}
		elsif ($curCLA eq "use" || $curCLA eq "call" || $curCLA eq "sil")
		{
			if (substr($cl_arg,2,length($cl_arg)-5) eq "fileType=")
			{
				my $fileType = substr($cl_arg, length($cl_arg)-3, 3);
				if ($fileType ne "bed" && $fileType ne "bin" && $fileType ne "pos")
				{
					print("Attempted to use an unsupported filetype for $curCLA. Must be 'pos'itions (1 per row), 'bin'ary (1 row with 1 or 0 for all positions), or 'bed'.\n") if ($DEBUG);
					die("Attempted to use an unsupported filetype for $curCLA. Must be 'pos'itions (1 per row), 'bin'ary (1 row with 1 or 0 for all positions), or 'bed'.\n");
				}
				print("Setting the $curCLA\ mask's filetype to $fileType.\n") if ($DEBUG);
				${$maskInfo{$curCLA}}{'type'} = $fileType;
			}
			elsif (substr($cl_arg,2,length($cl_arg)-1) eq "invert")
			{
				print("Inverting the $curCLA mask.\n") if ($DEBUG);
				${$maskInfo{$curCLA}}{'invert'} = 1;
			}
			else
			{
				print("$cl_arg is not a valid mask modifier. Exiting.\n") if ($DEBUG);
				die("$cl_arg is not a valid mask modifier. Exiting.\n");
			}
		}
		else
		{
			print("The parameter $curCLA cannot be modified. Exiting.\n") if ($DEBUG);
			die("The parameter $curCLA cannot be modified. Exiting.\n");
		}

	}
	else
	{
		$curCLA = substr($cl_arg, 1, length($cl_arg)-1);
		$settingParam = 1;
		print("Setting $curCLA to next argument.\n") if ($DEBUG);
	}
}

print("\n") if ($DEBUG);


foreach my $mask (keys(%maskInfo))
{
	my $template =  $maskInfo{$mask}{'template'};
	if (! $template)
	{
		if ($mask eq "use" || $mask eq "call")
		{
			print("The sites to use and callable sites mask file names must be defined. Exiting.") if ($DEBUG);
			die("The sites to use and callable sites mask file names must be defined. Exiting.");
		}
		elsif($mask eq "sil")
		{
			print("No silencing mask defined. All sites in the vcf that have sufficient phasing will be included in the outfiles.\n") if ($DEBUG);
			$useSilMask = 0;
		}
	}
	my $pivotChar = index($template, "*");
	if ($pivotChar < 0)
	{
		print("Location for scaffold names (*) not indicated for $mask mask.\nAssuming template is only postfix.\n") if ($DEBUG);
		$maskInfo{$mask}{'postfix'} = $template;
	}
	else
	{
		$maskInfo{$mask}{'prefix'} = substr($template, 0, $pivotChar);
		$maskInfo{$mask}{'postfix'} = substr($template, $pivotChar + 1, length($template) - $pivotChar - 1);
	}
}
my @masksUse = ("use", "call");
$masksUse[2] = "sil" if ($useSilMask);

my $pivotChar = index($outfileInfo{'template'}, "*");
if ($pivotChar < 0)
{
	print("Location for scaffold names (*) not indicated for outfile.\nAssuming template is only postfix.\n") if ($DEBUG);
	$outfileInfo{'postfix'} = $outfileInfo{'template'};
}
else
{
	$outfileInfo{'prefix'} = substr($outfileInfo{'template'}, 0, $pivotChar);
	$outfileInfo{'postfix'} = substr($outfileInfo{'template'}, $pivotChar + 1, length($outfileInfo{'template'}) - $pivotChar - 1);
}




if ($DEBUG)
{
	print("\nMy vcf infile is $vcfInfile. ");
	if($checkPhased)
	{
		print("Phasing will be checked and we will need a minimum of $minPhased phased genotypes.\n");
	}
	else
	{
		print("Phasing will be assumed for all genotypes.\n");
	}

	print("\nUse Mask:\n" . Dumper(%useMaskInfo));
	print("\nCallable Sites Mask:\n" . Dumper(%callMaskInfo));
	print("\nSilencing Mask:\n" . Dumper(%silMaskInfo)) if ($useSilMask);
}


sub readMask
{
	my ($maskType, $fileName) = @_;
	open(MASK, "<", $fileName);
	my @valAry;
	my $valStr = "";
	if($maskInfo{$maskType}{"type"} eq "bin")
	{
		my $binLine = <MASK>;
		chomp($binLine);
		if(substr($binLine, 0, 1) eq ">")
		{
			$binLine = <MASK>;
		}
		$valStr = $binLine;

	}
	elsif ($maskInfo{$maskType}{"type"} eq "pos")
	{
		my $curLine;
		my $curPos = 0;
		while ($curLine = <MASK>)
		{
			chomp($curLine);
			my $newInfoStr = "0" x ($curLine - $curPos - 1);
			$newInfoStr = $newInfoStr . "1";
			$curPos = $curLine;
			$valStr = $valStr . $newInfoStr;
		}
	}
	#else it's a bed file
	else
	{
		my $prevPos = 0;
		my $curLine;
		while ($curLine = <MASK>)
		{
			chomp($curLine);
			my @regionInfo = split("\t", $curLine);
			my $newInfoStr = "0" x ($regionInfo[1] - $prevPos);
			$newInfoStr = $newInfoStr . ("1" x ($regionInfo[2] - $regionInfo[1]));
			$prevPos = $regionInfo[2];
			$valStr = $valStr . $newInfoStr;
		}
	}
	close(MASK);
	#add inverting logic
	if ($maskInfo{$maskType}{'invert'})
	{
		print ("Inverting the $maskType mask.\n") if ($DEBUG);
		$valStr =~ tr/1/2/;
		$valStr =~ tr/0/1/;
		$valStr =~ tr/2/0/;
	}
	return $valStr;
}



open(VCF_IN, "<", $vcfInfile);

my $cur_vcfLine = "";
my $newScaffold = 1;
my $callVarNum = 0;
my $prevVarPos = 1;
my $maxUnphase = 0;

my $extraVar = 0;
my $extraInv = 0;
my %scaffold;

while ($cur_vcfLine = <VCF_IN>)
{
	chomp($cur_vcfLine);
	#Advance vcf to first SNP.
	if (substr($cur_vcfLine,0,1) ne "#")
	{
		my @snpInfo = split("\t", $cur_vcfLine);
		if(! $scaffold{"name"} || $scaffold{"name"} ne $snpInfo[0])
		{
			#reset scaffold information
			print($snpInfo[0] . " is a new scaffold.\n") if ($DEBUG);
			%scaffold = ();
			$scaffold{"name"} = $snpInfo[0];
			my $maxMaskLen = 0;
			foreach my $maskUsed (@masksUse)
			{
				$scaffold{$maskUsed . "FileName"} = $maskInfo{$maskUsed}{'prefix'} . $scaffold{"name"} . $maskInfo{$maskUsed}{'postfix'};
				$scaffold{$maskUsed . "ValStr"} = readMask($maskUsed, $scaffold{$maskUsed . "FileName"});
				$scaffold{$maskUsed . "Len"} = length($scaffold{$maskUsed . "ValStr"});
				$maxMaskLen = $scaffold{$maskUsed . "Len"} if ($scaffold{$maskUsed . "Len"} > $maxMaskLen);
			}
			foreach my $maskUsed (@masksUse)
			{ 
				if ($scaffold{$maskUsed . "Len"} < $maxMaskLen)
				{
					if ($maskInfo{$maskUsed}{'invert'})
					{
						print ("The $maskUsed mask is shorter than other masks and inverted. Padding with 1s.\n") if ($DEBUG);
						$scaffold{$maskUsed . "ValStr"} = $scaffold{$maskUsed . "ValStr"} . ("1" x ($maxMaskLen - $scaffold{$maskUsed . "Len"}));
					}
					else
					{
						print ("The $maskUsed mask is shorter than other masks and inverted. Padding with 0s.\n") if ($DEBUG);
						$scaffold{$maskUsed . "ValStr"} = $scaffold{$maskUsed . "ValStr"} . ("0" x ($maxMaskLen - $scaffold{$maskUsed . "Len"}));
					}
					$scaffold{$maskUsed . "Len"} = $maxMaskLen;
				}
			}
			$newScaffold = 1;
			$extraVar = 0;
			$extraInv = 0;
			$prevVarPos = 1;
		}
		my $curPos = $snpInfo[1];
		
		#If you're using the silence mask, check if the site is silenced. If not silenced or no mask, check that the site is in the "call" (callable site) mask.
		#If conditions met, analyze site.
		my $useCurVar = substr($scaffold{'useValStr'}, ($curPos - 1), 1);
		my $callCurVar = substr($scaffold{'callValStr'}, ($curPos - 1), 1);
		my $silCurVar = substr($scaffold{'silValStr'}, ($curPos - 1), 1) if ($useSilMask);
		if ((! $useSilMask || ! $silCurVar) && $callCurVar)
		{
			my $curSiteVar = 0;
			my @alleles = ($snpInfo[3], $snpInfo[4]);
			my $firstAllele = substr($snpInfo[9],0,1);
			my $unPhaseN = 0;
			my @hapSeqs = ();
			for my $i (9..(scalar(@snpInfo)-1))
			{
				my $indAllele1 = substr($snpInfo[$i],0,1);
				my $indAllele2 = substr($snpInfo[$i],2,1);
				my $indHaplSep = substr($snpInfo[$i],1,1);
				if(! $curSiteVar)
				{
					$curSiteVar = 1 if ($indAllele1 ne $firstAllele || $indAllele2 ne $firstAllele);
				}
				$unPhaseN++ if ($indAllele1 ne $indAllele2 && $indHaplSep eq "/");
				#if there are not too many unphased value and this site is to be used, concatenate the site data for the output file.
				if ($unPhaseN <= $maxUnphase && $useCurVar)
				{
					my @indHapSeqs = ();
					if ($indAllele1 eq $indAllele2 || $indHaplSep eq "|")
					{
						@indHapSeqs = ($alleles[$indAllele1] . $alleles[$indAllele2]);
					}
					else
					{
						@indHapSeqs = ($alleles[$indAllele1] . $alleles[$indAllele2], $alleles[$indAllele2] . $alleles[$indAllele1]);
					}
					if(! @hapSeqs)
					{
						@hapSeqs = @indHapSeqs;
					}
					else
					{
						my @newHapSeqs = ();
						foreach my $hapSeq (@hapSeqs)
						{
							foreach my $indHapSeq (@indHapSeqs)
							{
								push(@newHapSeqs, $hapSeq . $indHapSeq);
							}
						}
						@hapSeqs = @newHapSeqs;
					}	
				}
			}
			#If variant, increment extra counter and progress to next line of vcf.
			if ($curSiteVar && $useCurVar)
			{
				#Increment Number of extra Variants between previous site and current site.
				$extraVar++;
				#If minimum of phased sites, analyze; otherwise skip site.
				if ($unPhaseN <= $maxUnphase)
				{
					#Using previousvar position in the string puts it at previous position +1, the correct spot.
					print "PrevVarPos: " . $prevVarPos . "\nCurVarPos: " . $curPos . "\n#-CallableSites: " . (substr($scaffold{'callValStr'}, $prevVarPos, ($curPos - $prevVarPos)) =~ tr/1/1/) . "\n#-InterveningVarSites: " . $extraVar . "\n" if ($DEBUG);
					my $callableInv;
					if ($useSilMask)
					{
						my $callSites = substr($scaffold{'callValStr'}, $prevVarPos, ($curPos - $prevVarPos));
						my $silSites = substr($scaffold{'silValStr'}, $prevVarPos, ($curPos - $prevVarPos));
						for my $i (0..(length($callSites)-1))
						{
							$callableInv++ if (substr($callSites, $i, 1) && ! substr($silSites, $i, 1));
						}
						$callableInv -= $extraVar;
					}
					else
					{
						$callableInv = (substr($scaffold{'callValStr'}, $prevVarPos, ($curPos - $prevVarPos)) =~ tr/1/1/) - $extraVar;
					
					}
					$callableInv = 1 if ($callableInv <= 0);
					print($scaffold{'name'} . "\t" . $curPos . "\t" . $callableInv . "\t" . join(",", @hapSeqs) . "\n") if ($DEBUG);
					#Write output to outfile.
					open(OUTFILE, ">>", $outfileInfo{'prefix'} . $scaffold{'name'} . $outfileInfo{'postfix'});
					print(OUTFILE ($scaffold{'name'} . "\t" . $curPos . "\t" . $callableInv . "\t" . join(",", @hapSeqs) . "\n"));
					close(OUTFILE);
					$prevVarPos = $curPos;
					$extraVar = 0;
					$extraInv = 0;
				}
				else
				{
					print("The SNP at $curPos does not have $minPhased individuals phased or homozygous.\n") if ($DEBUG);
				}
			}
			elsif (! $curSiteVar)
			{
				print("The SNP at $curPos is invariant.\n") if ($DEBUG);
			}
		}
		else
		{
			print("The SNP at $curPos is silenced or uncallable.\n") if ($DEBUG);
		}
		 
		$newScaffold = 0;
	}
	elsif (substr($cur_vcfLine,0,2) eq "#C")
	{
		print($cur_vcfLine . "\n");
		my @header = split("\t", $cur_vcfLine);
		#set sample number based on header row
		$sampleN = scalar(@header)-9;
		$maxUnphase = $sampleN - $minPhased;
	}
}
close(VCF_IN);