#!/usr/bin/gawk -f
# Victorinox_05.awk
# gawk -f AWKScripts/HTML_Scraping/Victorinox_05.awk

/^<a href=/{
	print;
	# 1行先読みし、「<div>SOLD」か否かを判断
	getline NextSTDIN;
	if(NextSTDIN != "<div>SOLD"){
		# 売買契約が未締結の場合、<div>SOLDが存在しないため、判定用に「<div>NO CONTRACT」を挟む
		print "<div>NO CONTRACT";
	}
	print NextSTDIN;
	next;
}

{
	print;
}

