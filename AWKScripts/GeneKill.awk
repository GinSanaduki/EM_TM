#!/usr/bin/gawk -f
# GeneKill.awk
# awk -f AWKScripts/GeneKill.awk

BEGIN{
	print ":";
}

{
	print "kill -9 "$2;
}

