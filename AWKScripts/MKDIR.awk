#!/usr/bin/gawk -f
# MKDIR.awk
# awk -f AWKScripts/MKDIR.awk -v WorksDir=$WorksDir

BEGIN{
	print ":";
	print "echo $?";
}

{
	print "mkdir -p \""WorksDir"/"$0"\" > /dev/null 2>&1";
	print "echo $?";
}

