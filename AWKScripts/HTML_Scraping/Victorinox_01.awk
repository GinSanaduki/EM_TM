#!/usr/bin/gawk -f
# Victorinox_01.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_01.awk

/<div class="items-box-content clearfix">/,/<div class="l-side">/{
	print;
}

