#!/usr/bin/gawk -f
# Victorinox_04.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_04.awk

{
	gsub("><",">\n<");
	gsub("</div>","\n</div>");
	print;
}

