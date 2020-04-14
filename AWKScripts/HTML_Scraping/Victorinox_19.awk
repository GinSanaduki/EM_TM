#!/usr/bin/gawk -f
# Victorinox_19.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_19.awk

BEGIN{
	FS = "\t";
}

($1 == "メッセージ履歴" && $3 == "<figure>"){
	next;
}



($1 == "メッセージ履歴"){
	match($3, /<form action=/);
	if(RSTART > 0){
		gsub("<form action=\"","メッセージ送信者報告URL\t",$3);
		gsub(/method=.*/,"",$3);
		gsub(" ","",$3);
		gsub("\"","",$3);
		print $1"\t"$2"\t"$3;
		next;
	}
	
	match($3, /<img src=.*?/);
	if(RSTART > 0){
		gsub("<img src=\"","メッセージ送信者サムネイル\thttps:",$3);
		gsub(/alt=.*?>/,"",$3);
		gsub(" ","",$3);
		gsub("\"","",$3);
		print $1"\t"$2"\t"$3;
		next;
	}
	
	match($3, /class="message-user">$/);
	if(RSTART > 0){
		gsub("<a href=\"","メッセージ送信者URL\t",$3);
		gsub(/ class="message-user">$/,"",$3);
		gsub("\"","",$3);
		print $1"\t"$2"\t"$3;
		next;
	}
	
	match($3, /^<figcaption.*?<div class="message-body-text">.*?<span>.*?<\/span>$/);
	if(RSTART > 0){
		match($3, /<div class="message-body-text">/);
		SendUserName = substr($3,1, RSTART - 1);
		sub(/^<figcaption.*?>/,"",SendUserName);
		print $1"\t"$2"\tメッセージ送信者名\t"SendUserName;
		SendContents = substr($3,RSTART);
		match(SendContents, /<span>.*?<\/span>/);
		SendDay = substr(SendContents, RSTART);
		sub("<span>","",SendDay);
		sub("</span>","",SendDay);
		SendContents = substr(SendContents, 1,RSTART - 1);
		sub("<div class=\"message-body-text\">","",SendContents);
		print $1"\t"$2"\tメッセージ内容\t"SendContents;
		print $1"\t"$2"\tメッセージ送信日時\t"SendDay;
		next;
	}
}

{
	print;
}

