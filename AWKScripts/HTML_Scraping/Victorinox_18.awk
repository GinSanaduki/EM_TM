#!/usr/bin/gawk -f
# Victorinox_18.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_18.awk

BEGIN{
	FS = "\t";
}

($1 == "メッセージ履歴"){
	Conv = ">\n"$1"\t"$2"\t<";
	gsub("><",Conv);
	print;
	next;
}

{
	print;
}

