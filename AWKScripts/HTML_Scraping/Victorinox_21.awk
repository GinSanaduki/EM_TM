#!/usr/bin/gawk -f
# Victorinox_21.awk
# gawk -f AWKScripts/HTML_Scraping/Victorinox_21.awk

/^<div class="item-btn-float-area">$/{
	print "売買契約\t未成立";
	next;
}

{
	print;
}

