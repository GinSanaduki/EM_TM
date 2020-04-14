#!/usr/bin/gawk -f
# Victorinox_06.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_06.awk

BEGIN{
	MainURL = "https://www.mercari.com";
}

/^<a href=/{
	sub(/^<a href=/,"");
	sub(/>$/,"");
	gsub("\"","");
	print MainURL $0;
	next;
}

/^<div>/{
	sub(/^<div>/,"");
	print;
	next;
}

/^<h3 class=/{
	sub(/^<h3 class=/,"");
	sub(/<\/h3>$/,"");
	sub(/^.*?>/,"");
	gsub("\"","");
	print;
	next;
}

/^<div class=/{
	sub(/^<div class=.*?>/,"");
	print;
	next;
}

