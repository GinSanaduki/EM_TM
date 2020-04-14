#!/usr/bin/gawk -f
# Inspector.awk
# awk -f AWKScripts/Inspector.awk -v Mode=Check Define_SearchWord.conf
# gawk -f AWKScripts/Inspector.awk -v Mode=Convert Define_SearchWord.conf

BEGIN{
	ErrorBit = 0;
	switch(Mode){
		case "Check":
			Cnt = 0;
			break;
		case "Convert":
			break;
		default:
			ErrorBit++;
			exit 99;
	}
}

/./{
	switch(Mode){
		case "Check":
			Cnt++;
			next;
	}
	# 水平タブは、半角スペースに変換
	gsub("\011"," ");
	# 32文字で切る
	$0 = substr($0,1,32);
	# カンマは、この時点でパーセントエンコーディングする
	gsub("\054","%2C");
	print;
}

END{
	if(ErrorBit != 0){
		exit 99;
	}
	if(Mode == "Convert"){
		exit;
	}
	if(Cnt > 0){
		exit;
	} else {
		exit 1;
	}
}

