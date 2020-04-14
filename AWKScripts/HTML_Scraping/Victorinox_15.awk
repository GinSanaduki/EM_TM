#!/usr/bin/gawk -f
# Victorinox_15.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_15.awk

/^商品添付イメージ/{
	gsub(" ","");
	print;
	next;
}

{
	sub("</p><LineFeed_LF_LineFeed>","</p>\n");
	gsub("<div class=\"item-user-ratings\">","");
	gsub("</td><th>","</td>\n<th>");
	print;
}

