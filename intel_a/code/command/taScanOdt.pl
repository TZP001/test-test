#!/usr/bin/env perl -w
# Copyright Dassault Systemes 2001
#
# taScanOdt
#	scan for structural anomalies in test frameworks, and their associations
#	with code frameworks
#
#	fmf	26jan01	creation
#

use strict;
use Class::Struct;			# use structured data
use File::Basename;			# use basename and dirname
use FindBin;				# retrieve the script directory as $FindBin::Bin
use Getopt::Long;			# standard script arguments processing

#---------------------------------------------------------------------------
# global vars

# environment variables, see setupEnv subroutine
my( $fsep, $psep, $os );
my( $taRootPath, $systemTaRootPath, $addlPath );

# the status for each test fw: a value of 1 in this hash means that the
# test fw was found, a value of 2 means that it is used by a code fw
my %testFwStatus;

# the ds people list, associated to their 2nd level organization
my %dsorg;

# all the errors that were found
my @errors;	

# statistics on errors
my %errStats;

# structure to retain errors
struct Error =>
{
	fw		=> '$',
	shell	=> '$',
	line	=> '$',
	type	=> '$',
	msg		=> '$'
};

#---------------------------------------------------------------------------
# subroutine prototypes
sub main();
sub buildDsorg();
sub byError;
sub checkPertinence();
sub computeStats();
sub env( $ );
sub getOptions();
sub handleCodeFw( $;$ );
sub handleTestFw( $;$ );
sub printResults();
sub scanCodeFws();
sub scanShell( $$$ );
sub scanTestFws();
sub setupEnv();
sub storeError( $$$;$$ );
sub storeNonAttachedTestFws();
sub toBxml();
sub toFinalOutputDir();
sub usage();
sub which($);
sub xmlOpenElement( $;$@ );
sub xmlCloseElement( ;$ );
sub xmlOpenCloseElement( $;$@ );
sub xmlBuildAttrs( @ );
sub xmlBuildStatAttrs( \% );

#---------------------------------------------------------------------------
# call to main subroutine then exit
main();
0;

#---------------------------------------------------------------------------
# main subroutine, it queries first all test frameworks, then all code
# frameworks, comparing the attachment lists
sub main()
{
	# setup the environment variables
	setupEnv();

	# get the options
	getOptions();

	# first build the ds people list from 0DSOrg
	buildDsorg();

	# first scan all test fws, and all test shells within them
	scanTestFws();

	# now scan all fws to check associations
	scanCodeFws();

	# check if test fws have any attached component
	storeNonAttachedTestFws();

	# check odt pertinence (from the odt results file)
	checkPertinence();

	# sort the error list
	@errors = sort byError @errors;

	# compute statistics
	computeStats();

	# dump results to an xml file
	printResults();

	# compute the bxml file
	toBxml();

	# move results to final output dir if they were generated in *.new
	toFinalOutputDir();
}

#-----------------------------------------------------------------------
# setup environment
sub setupEnv()
{
	# unix vs. NT separators, os name
	$fsep	= ( env( "MkmkOS_NAME" ) eq "Windows_NT" ) ? '\\' : '/';
	$psep	= ( env( "MkmkOS_NAME" ) eq "Windows_NT" ) ? ';' : ':';
	my $os	= env( "MkmkOS_Buildtime" );

	# script directory
    my $scriptDir	= $FindBin::Bin;
	$scriptDir		=~ s#\\#/#g;

	# differentiate between installed and dev environment
	if( env( "ADL_IMAGE_DIR" ) )
	{
		# dev environment, we don't use the runtime view
		$taRootPath		= dirname dirname dirname dirname $scriptDir;
		$systemTaRootPath	= $taRootPath;
		$systemTaRootPath	=~ s#/#$fsep#g ;

		# get the prereq concatenation
		open PREQ, "mkGetPreq -W '$systemTaRootPath'|"
					or die "Couldn't get prereq: $!";
		while( <PREQ> )
		{
			chomp;
			$addlPath .= $psep.join( $fsep, $_, $os, "code", "bin");
		}
		close PREQ;
	} else
	{
		# installed environment
		$taRootPath			= dirname dirname dirname $scriptDir;
		$systemTaRootPath	= $taRootPath;
		$systemTaRootPath	=~ s#/#$fsep#g ;
		$addlPath			= $psep . join( $fsep, $systemTaRootPath,
									$os, "code", "bin" );
	}

	$ENV{PATH}				.= $addlPath;
	$ENV{LIBPATH}			.= $addlPath;
	$ENV{LD_LIBRARY_PATH}	.= $addlPath;
	$ENV{SHLIB_PATH}		.= $addlPath;
}

#---------------------------------------------------------------------------
sub getOptions()
{
	GetOptions( "testWs=s", "codeWs=s", "pertFile=s", "outputDir=s", "local",
				"help|h|?" );
	$::opt_codeWs		||= $::opt_testWs;
	$::opt_outputDir	||= "TAResults";

	# track invalid command line or help request
	$::opt_help and die usage();
	-d (dirname $::opt_outputDir ) or
			mkdir dirname( $::opt_outputDir ), 0755 or
			die "Couldn't create in " . dirname( $::opt_outputDir ) . ": $!";
	-d $::opt_outputDir or
			mkdir $::opt_outputDir, 0755 or
			die "Couln't create $::opt_outputDir: $!";

	$::opt_codeWs and $::opt_testWs and $::opt_outputDir or
			die usage();

	# avoid stupid warnings
	my $hlp = $::opt_help;
}

#---------------------------------------------------------------------------
# return usage string
sub usage()
{
	return "\nUsage: " . basename($0) . "\n" .
		"  --testWs <ws>       mandatory, the test workspace\n".
		"  --codeWs <ws2>      the code workspace, default is testWs\n".
		"  --pertFile <file>   the odt results file, where pertinence info\n".
		"                      is found\n".
		"  --outputDir <dir>   the output directory, default is\n".
		"                      ./TAResults\n".
		"  --local             report only local errors (for RP)\n\n".
		"  --help              prints this help\n";
}

#---------------------------------------------------------------------------
# read 0dsorg from testWs and codeWs
sub buildDsorg()
{
	for my $ws ( ($::opt_testWs, $::opt_codeWs) )
	{
		# open dsorg, file not found not being fatal
		if( open DSORG, "<$ws/0DSOrg" )
		{
			while( <DSORG> )
			{
				# fmf01 10dec01 take only the first organisation
				#m#^\.?(\w+\.\w+).*?(\w+)\.?$# and $dsorg{uc $2} = uc $1;
				m#^\.?(\w+).*?(\w+)\.?$# and $dsorg{uc $2} = uc $1;
			}
			close DSORG;
		}
	}
}

#---------------------------------------------------------------------------
# go thru test workspace
sub scanTestFws()
{
	my %testFws;							# hash of test fws in testWs
											# value is the responsible if any

	# build the fw list
	opendir( REP, $::opt_testWs );
	%testFws =	map { $_, undef }			# create the hash
				grep { -d "$::opt_testWs/$_" }# keep only directories
				sort						# sort the resulting list
				grep { /\.tst$/ }			# take only test fws
				grep { !/^[\.0]/ }			# ignore dirs starting with . or 0
				readdir(REP);
	closedir REP;

	# fill in responsible values, file not found is not fatal
	if( %dsorg and
		open ADLRESP, "<$::opt_testWs/0adl_responsible" )
	{
		while( <ADLRESP> )
		{
			next unless m/FwName:(.*?) Fw:.*? Resp:(\w*)$/ ;
			if( exists $testFws{$1} and exists $dsorg{uc $2} )
			{
				$testFws{$1} = uc $2;
			}
		}
		close ADLRESP;
	}

	my $totalTestFws = scalar keys %testFws;
	my $curFw;								# current test fw
	my $index = 0;							# nth fw being studied
	foreach $curFw ( keys %testFws )
	{
		$index++;
		print STDERR "scanning test fw #$index out of $totalTestFws\r";
		handleTestFw( $curFw, $testFws{$curFw} );
	}
	print STDERR "\n";
}

#---------------------------------------------------------------------------
# handle each test fw found in testWs
sub handleTestFw( $;$ )
{
	my ($fw, $resp) = @_;
	my $hasTests = 0;

	defined $resp or
			storeError( "NRSP", "doesn't have a valid responsible", $fw );

	if( ! -e "$::opt_testWs/$fw/IdentityCard/IdentityCard.h" )
	{
		storeError( "NIDC", "doesn't have an id card", $fw );
		return;
	}

	$testFwStatus{$fw}->[0] = 1;
	$testFwStatus{$fw}->[1] = $resp;
	
	for ( qw( TestCases SwitchTestCases InputData ) )
	{
		my $shortDir = $_;
		my $dir = "$::opt_testWs/$fw/FunctionTests/$shortDir";
		next unless -d $dir;

		opendir TESTDIR, $dir or die "couldn't read $dir: $!";
		foreach( grep /\.sh$/, grep !/^\./, readdir TESTDIR )
		{
			$hasTests = 1 unless $shortDir eq "InputData";
			scanShell( "$dir/$_", $fw, "$shortDir/$_" );
		}
		close TESTDIR;
	}
	$hasTests or storeError( "NODT", "doesn't contain any odt", $fw );
}

#---------------------------------------------------------------------------
sub scanShell( $$$ )
{
	my ($whole, $fw, $shell) = @_;

	open SHELL, "<$whole" or die "couldn't read $whole: $!";
	while( <SHELL> )
	{
		# get rid of comments
		s/#.*//;
		# get rid of things within ${} because we can misunderstand sequences
		s/(\$\{\w*).*?\}/$1\}/ ;

		# test wrong comments
		if( m#^\s*//# )
		{
			storeError( "SLCO", "uses '//' to comment out", $fw, $shell, $. );
			next;
		}

		# test running java, not javaReplay
		/^\s*java\b/ and
				storeError( "RJAV", "runs java directly", $fw, $shell, $. );

		# test a direct reference to classes.zip or rt.jar
		/\b(classes\.zip|rt\.jar)\b/i and
				storeError( "RCLZ", "references $1 directly", $fw, $shell, $. );
		
		# test a parent directory reference
		/\.\./ and !/\.\.\./ and
				storeError( "RPAR", "references a parent directory",
							$fw, $shell, $. );

		# test if an odt doesn't get replayed in purify
		/SetOdtParam\s+Replay_(Windows_NT|intel_a)\s*=\s*NO/ and
				storeError( "NPUR", "is not replayed on NT",
							$fw, $shell, $. );
		/SetOdtParam\s+TYPE\s*=\s*NoPurify/ and
				storeError( "NPUR", "is not replayed in purify mode",
							$fw, $shell, $. );
		
		# test if ADL_ODT_TMP/OUT/IN is modified within the script
		/export\s+ADL_ODT_(OUT|IN|TMP)\b/ and
				storeError( "SROV", "sets mkodt read-only variable ADL_ODT_$1",
							$fw, $shell, $. );
	}
	close SHELL;
}

#---------------------------------------------------------------------------
# go through code workspace, knowing about test fws
sub scanCodeFws()
{
	my %codeFws;							# hash of code fws in codeWs
											# value is the responsible if any

	# build the fw list
	opendir( REP, $::opt_codeWs );
	%codeFws =	map { $_, undef }			# create the hash
				grep { -d "$::opt_codeWs/$_" }	# keep only directories
				sort						# sort the resulting list
				grep { !/^(Doc|JAVA|control|Release\.data)$/ }
											# ignore systems directories
				grep { !/_[a-z]$/ }			# ignore systems directories
				grep { !/\.grp$/i }			# ignore group directories
				grep { !/\.tst$/i }			# ignore test directories
				grep { !/^[\.0]/ }			# ignore dirs starting with . or 0
				readdir(REP);
	closedir REP;

	# fill in responsible values, file not found is not fatal
	if( %dsorg and
		open ADLRESP, "<$::opt_codeWs/0adl_responsible" )
	{
		while( <ADLRESP> )
		{
			next unless m/FwName:(.*?) Fw:.*? Resp:(\w*)$/ ;
			if( exists $codeFws{$1} and exists $dsorg{uc $2} )
			{
				$codeFws{$1} = uc $2;
			}
		}
		close ADLRESP;
	}

	my $totalFws = scalar keys %codeFws;
	my $curFw;								# current code fw
	my $index = 0;							# nth fw being studied
	foreach $curFw ( keys %codeFws )
	{
		$index++;
		print STDERR "scanning code fw #$index out of $totalFws\r";
		handleCodeFw( $curFw, $codeFws{$curFw} );
	}
	print STDERR "\n";
}

#---------------------------------------------------------------------------
sub handleCodeFw( $;$ )
{
	my ($fw, $resp) = @_;
	my $hasAttached = 0;
	my $implicitTestFw = $fw;
	$implicitTestFw =~ s/(\.edu)?$/.tst/ ;

	defined $resp or
			storeError( "NRSP", "doesn't have a valid responsible", $fw );

	if( ! -e "$::opt_codeWs/$fw/IdentityCard/IdentityCard.h" )
	{
		storeError( "NIDC", "doesn't have an id card", $fw );
		return;
	}

	# test that there is at least one code module
	# otherwise just return, this is a data framework
	opendir( REP, "$::opt_codeWs/$fw" );
	my @modules = grep { m/\.(m|mj)/ } readdir(REP);
	closedir REP;
	scalar @modules or return;

	if( exists $testFwStatus{$implicitTestFw} )
	{
		$hasAttached = 1;
		$testFwStatus{$implicitTestFw}->[0] = 2;
	}

	open IDCARD, "<$::opt_codeWs/$fw/IdentityCard/IdentityCard.h"
			or die "couldn't open $fw identity card: $!";
	my( $testResp );
	while( <IDCARD> )
	{
		# wipe out comments
		s#//.*##;
		if( /AttachComponent.*?"(.*?\.tst)"/ )
		{
			if( exists $testFwStatus{$1} )
			{
				$hasAttached = 1;
				$testFwStatus{$1}->[0] = 2;
				$testResp = $testFwStatus{$1}->[1];
				if ( defined $resp and defined $testResp and
					 $dsorg{$resp} ne $dsorg{$testResp} )
				{
					storeError( "CFTF", "is officially covered by foreign " .
								"test fw $1 ($dsorg{$testResp}) " .
								"while it is in $dsorg{$resp}",
								$fw );
				}

			} else
			{
				storeError( "NETF", "is officially covered by non-existent " .
							"test fw $1", $fw ) unless $::opt_local;
			}
		}
	}
	close IDCARD;
	
	$hasAttached or ( $fw =~ /\.edu$/ ) or $::opt_local or
		storeError( "NCOV", "isn't covered officially by any test framework",
					$fw );
}

#---------------------------------------------------------------------------
sub storeNonAttachedTestFws()
{
	foreach( keys %testFwStatus )
	{
		$testFwStatus{$_}->[0] == 2 or $::opt_local or
				storeError( "NATF", "doesn't cover officially any code fw",
							$_ );
	}
}

#---------------------------------------------------------------------------
# check pertinence from odt results file
sub checkPertinence()
{
	$::opt_pertFile or return;
	open PERT, "<$::opt_pertFile" or
			warn "Couldn't read $::opt_pertFile: $!\n" and return;

	while( <PERT> )
	{
		my($fw, undef, undef, $shell, undef, undef, undef, undef, $type, $pert)
			= split;
		if( exists $testFwStatus{$fw} and $pert eq "0" )
		{
			$shell = ( ($type eq "XX") ? "TestCases" : "SwitchTestCases" )
						.$fsep.$shell.".sh";
			storeError( "NPER",
						"returns 0 even outside the runtime environment",
						$fw, $shell );
		}
	}
	close PERT;
}

#---------------------------------------------------------------------------
# sort error messages by fw, shell, line, type
sub byError
{
	return( $a->fw cmp $b->fw or
			$a->shell cmp $b->shell or
			$a->line <=> $b->line or
			$a->type cmp $b->type );
}

#---------------------------------------------------------------------------
# compute statistics at every level
sub computeStats()
{
	my %allStats;
	my %fwStats;
	my %shellStats;
	my( $curFw, $curShell );
	my @errorStack	= @errors;
	my $error		= shift @errorStack;
	
	while( defined $error )
	{
		# open elements if needed
		if( ! defined $curFw )
		{
			$curFw = $error->fw;
			undef %fwStats;
		}
		if( ! defined $curShell and $error->shell )
		{
			$curShell = $error->shell;
			undef %shellStats;
		}

		# register the error in stats
		$allStats{$error->type}++;
		$fwStats{$error->type}++;
		$shellStats{$error->type}++;

		# jump to next error
		$error = shift @errorStack;

		# close pending elements if needed
		if( defined $curShell )
		{
			if( ! defined $error or
				$error->fw ne $curFw or
				! defined $error->shell or
				$curShell ne $error->shell )
			{
				$errStats{"$curFw#$curShell"} = xmlBuildStatAttrs( %shellStats );
				undef $curShell;
			}
		}
		if( defined $curFw )
		{
			if( ! defined $error or
				$error->fw ne $curFw )
			{
				$errStats{$curFw} = xmlBuildStatAttrs( %fwStats );
				undef $curFw;
			}
		}
	}
	$errStats{"all"} = xmlBuildStatAttrs( %allStats );
}

#---------------------------------------------------------------------------
# print all errors from the errors array
sub printResults()
{
	my( $curFw, $curShell );
	my @errorStack	= @errors;
	my $error		= shift @errorStack;

	# open output file for writing
	open XMLOUTPUT, ">$::opt_outputDir/taScanOdtResults.xml"
			or die "Couldn't write to $::opt_outputDir/taScanOdtResults.xml: $!";
	my $oldOut = select XMLOUTPUT;

	# compute runtime information
	my @localtime = localtime;
	my $date = sprintf( "%02d-%02d-%4d.%02d.%02d",
					 $localtime[4]+1, $localtime[3], 1900+$localtime[5],
					 $localtime[2], $localtime[1] );
	$_ = uc `id`;
	my ($logname) = m/\((.*?)\)/ ;
	my $level = basename dirname $::opt_codeWs;

	# print header
	print "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n\n";
	xmlOpenElement( "ROOT" );
	xmlOpenElement( "TASCANODTRESULTS", $errStats{"all"},
					name => $level,
					codeWs => $::opt_codeWs,
					testWs => $::opt_testWs,
					logname => $logname,
					taScanOdtDate => $date );

	while( defined $error )
	{
		# open elements if needed
		if( ! defined $curFw )
		{
			$curFw = $error->fw;
			xmlOpenElement( "FRAMEWORK", $errStats{$curFw},
							name => $curFw );
		}
		if( ! defined $curShell and $error->shell )
		{
			$curShell = $error->shell;
			xmlOpenElement( "SHELL", $errStats{"$curFw#$curShell"},
							name => $curShell );
		}

		# print error
		$error->line ?
				xmlOpenCloseElement( "HIT", undef,
									 name => $error->type,
									 line => $error->line,
									 text => $error->msg ) :
				xmlOpenCloseElement( "HIT", undef,
									 name => $error->type,
									 text => $error->msg );

		# jump to next error
		$error = shift @errorStack;

		# close pending elements if needed
		if( defined $curShell )
		{
			if( ! defined $error or
				$error->fw ne $curFw or
				! defined $error->shell or
				$curShell ne $error->shell )
			{
				xmlCloseElement( "SHELL" );
				undef $curShell;
			}
		}
		if( defined $curFw )
		{
			if( ! defined $error or
				$error->fw ne $curFw )
			{
				xmlCloseElement( "FRAMEWORK" );
				undef $curFw;
			}
		}
	}
	xmlCloseElement( "TASCANODTRESULTS" );
	xmlCloseElement( "ROOT" );

	select $oldOut;
	close XMLOUTPUT;
}

#---------------------------------------------------------------------------
# convert xml output to bxml
sub toBxml()
{
	system "BXMLConverter -xml2bxml $::opt_outputDir/taScanOdtResults.xml" .
				" $::opt_outputDir/taScanOdtResults.bxml";
	$? and die "Problem in conversion to bxml";
}

#---------------------------------------------------------------------------
# eventually move the results to main directory if they were created in
# .new directory
sub toFinalOutputDir()
{
	if( $::opt_outputDir =~ s/\.new$// )
	{
		system "rm -rf $::opt_outputDir.old" if -d "$::opt_outputDir.old";
		rename $::opt_outputDir, "$::opt_outputDir.old" if -d $::opt_outputDir;
		rename "$::opt_outputDir.new", $::opt_outputDir;
	}
}

#--------------------------------------------------------------------------
# handle the environment variables to be system-independent
sub env( $ )
{
	my( $var ) = @_;
	# get all uppercase env variable if literal env variable doesn't exist
	my $value = exists( $ENV{$var} ) ? $ENV{$var} : $ENV{"\U$var"};
	# replace backslashes with forward slashes
	$value =~ s#\\#/#g if $value;
	return $value;
}

#---------------------------------------------------------------------------
sub storeError( $$$;$$ )
{
	my( $type, $msg, $fw, $shell, $line ) = @_;

	my $error = Error->new();
	$error->fw( $fw );
	$error->shell( defined $shell ? $shell : "");
	$error->line( defined $line ? $line : 0 );
	$error->type( $type );
	$error->msg( $msg );

	push @errors, $error;
}

#-----------------------------------------------------------------------
# find an executable in the path
sub which($)
{
	my( $orig ) = @_;
	my( $path, $full );

	# search in the path if the command doesn't specify its own path
	unless ( -x $orig and
			 index( $orig, $fsep ) >= 0 )
	{
		foreach $path ( split $psep, env( "PATH" ) )
		{
			if( -f "$path$fsep$orig" )
			{
				$full = "$path$fsep$orig";
				last;
			}
		}
	}

	# analyse results a little bit
	if ( ! defined $full )
	{
		$full = "";
	} elsif ( $full !~ m#^(\w:)?[/\\]# )
	{
		$full = cwd() . $fsep . $full;
	}

	return $full;
}

#===========================================================================
# xml goodies

# current indentation in document
my $xmlIndent;
# current pending stack
my @xmlPending;

# open an element in xml document
sub xmlOpenElement( $;$@ )
{
	my( $tag, $stats, @others ) = @_;

	defined $xmlIndent or $xmlIndent = 0;
	print( ' ' x $xmlIndent );
	print "<$tag";
	print xmlBuildAttrs( @others ) if @others;
	print $stats if defined $stats;
	print ">\n";

	$xmlIndent++;
	push @xmlPending, $tag;
}

# close an element in xml document
sub xmlCloseElement( ;$ )
{
	my ($verif) = @_;
	my $tag = pop @xmlPending;

	# check programming...
	$tag or die "Tried to close an element but none was pending.";
	defined $verif and $verif ne $tag and
			die "Tried to close $verif but $tag was pending.";

	$xmlIndent--;
	print( ' ' x $xmlIndent . "</$tag>\n" );
}

# open and close an element at the same time
sub xmlOpenCloseElement( $;$@ )
{
	my( $tag, $stats, @others ) = @_;

	print( ' ' x $xmlIndent . "<$tag" );
	print xmlBuildAttrs( @others ) if @others;
	print $stats if defined $stats;
	print "/>\n";
}

# build attributes string in an element
sub xmlBuildAttrs( @ )
{
	my (@attrs) = @_;
	my $attr;
	my $res = "";
	foreach( @attrs )
	{
		if( ! defined $attr )
		{
			$attr = $_;
		} else
		{
			$res .= " $attr=\"$_\"";
			undef $attr;
		}
	}
	return $res;
}

# build attributes string in an element
sub xmlBuildStatAttrs( \% )
{
	my ($attrs) = @_;
	my $total = 0;
	my $res = "";
	foreach( sort keys %$attrs )
	{
		$res .= " $_=\"$$attrs{$_}\"";
		$total += $$attrs{$_};
	}
	$res .= " totalHits=\"$total\"" if $total;

	return $res;
}
