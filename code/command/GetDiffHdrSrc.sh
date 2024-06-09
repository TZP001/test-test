#! /usr/bin/ksh

file=$1
reffile=$2

if [ ! -f $file ]; then
	echo "$file not found." 1>&2
	exit 1
fi
if [ ! -f $reffile ]; then
	echo "$reffile not found." 1>&2
	exit 1
fi

awk 'BEGIN{
		reffile="'$reffile'";
		test=(getline < reffile);
		if(test!=-1) {
			close(reffile);
			while(getline line < reffile) {
				SELECT[line]=1;
			}
		}
		else {
			print "Cannot open " reffile ".";
			exit;
		}
	}
	{
		if(SELECT[$0]!=1) print;
	}' $file
