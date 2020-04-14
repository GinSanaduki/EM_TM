#!/usr/bin/gawk -f
# Victorinox_08.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_08.awk ec.txt

BEGIN{
	FS = "\t";
}

{
	gsub(",","",$4);
	match($4,/[[:digit:]]*$/);
	$4 = substr($4,RSTART,RLENGTH);
	$4 = $4 + 0;
	print $1"\t"$2"\t"$3"\t"$4;
}

