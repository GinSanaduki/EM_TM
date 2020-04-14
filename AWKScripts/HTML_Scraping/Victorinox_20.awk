#!/usr/bin/gawk -f
# Victorinox_20.awk
# gawk -f AWKScripts/HTML_Scraping/Victorinox_20.awk

BEGIN{
	FS = "\t";
	UnixTime = systime();
}

($1 == "メッセージ履歴" && $3 == "メッセージ送信日時"){
	# ○○日前のみ、正式な日付を出力する
	# さすがに、1年過ぎたら正式な日付は出ないような気がする
	match($4, /日前/);
	if(RSTART > 0){
		Col_04 = $4;
		gsub("日前", "", Col_04);
		gsub(" ", "", Col_04);
		Col_04 = Col_04 + 0;
		if(Col_04 > 0){
			# 86400 : 60s * 60m * 24h
			CalcBack = UnixTime - Col_04 * 86400;
			YYYYMMDD = strftime("%Y年%m月%d日",CalcBack);
			print $0"\t"YYYYMMDD;
			next;
		}
	}
}

{
	print;
}

