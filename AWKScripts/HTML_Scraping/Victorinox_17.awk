#!/usr/bin/gawk -f
# Victorinox_17.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_17.awk

BEGIN{
	Cnt = 1;
}

/<th>カテゴリー<\/th>/,/^ブランド/{
	match($0, /^ブランド/);
	if(RSTART > 0){
		print;
		next;
	}
	match($0, /^http/);
	if(RSTART > 0){
		match($0, />/);
		sub(/<\/td>/,"");
		print "カテゴリ\t"substr($0, RSTART + 1);
		next;
	}
	next;
}

/^<div class="item-detail-message">$/,/^<SENTINEL>$/{
	if($0 == "<div class=\"item-detail-message\">"){
		next;
	}
	if($0 == "<div class=\"message-container\">"){
		next;
	}
	if($0 == "<div class=\"message-content\">"){
		next;
	}
	if($0 == "<ul class=\"message-items\">"){
		next;
	}
	if($0 == "<li class=\"clearfix\">"){
		next;
	}
	if($0 == "<SENTINEL>"){
		print;
		next;
	}
	match($0, /<form action=".*?" method="POST">/);
	if(RSTART > 0){
		print;
		Cnt++;
	} else {
		match($0, /^<a href=/);
		if(RSTART > 0){
			printf("%s%s%s","メッセージ履歴\t"Cnt,"\t",$0);
		}
		printf("%s",$0);
	}
	next;
}

{
	print;
}

