#!/usr/bin/gawk -f
# Victorinox_02.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_02.awk

{
	sub(/^\s*?/,"");
	sub(/^\t*?/,"");
	print;
}

