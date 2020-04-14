#!/usr/bin/gawk -f
# Victorinox_12.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_12.awk

/<div class="item-button-container clearfix">/,/<i class="icon-like-border"><\/i>/{
	next;
}

{
	print;
}

