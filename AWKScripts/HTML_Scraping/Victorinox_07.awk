#!/usr/bin/gawk -f
# Victorinox_07.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_07.awk

{
	if(NR % 4){
		ORS="\t";
	} else {
		ORS="\n";
	}
	print;
}

