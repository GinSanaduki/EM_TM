#!/usr/bin/gawk -f
# ReplyDirTime.awk
# gawk -f AWKScripts/ReplyDirTime.awk -v Mode=01
# gawk -f AWKScripts/ReplyDirTime.awk -v Mode=02
# gawk -f AWKScripts/ReplyDirTime.awk -v Mode=03

BEGIN{
	switch(Mode){
		case "01":
			break;
		case "02":
			break;
		case "03":
			print systime();
			exit;
		default:
			exit 99;
	}
	NowUNIXTime = systime();
	YYYYMMDD = strftime("%Y %m %d", NowUNIXTime);
	HH = strftime("%H", NowUNIXTime);
	HH = HH + 0;
	if(HH >= 18){
		HH = "18";
	} else if(HH >= 12){
		HH = "12";
	} else if(HH >= 6){
		HH = "06";
	} else {
		HH = "00";
	}
	
	YYYYMMDD_HHmmSS = YYYYMMDD" "HH" 00 00";
	switch(Mode){
		case "01":
			print mktime(YYYYMMDD_HHmmSS);
			break;
		case "02":
			MainDir = "ResultOut/ResultOut_"YYYYMMDD"_"HH;
			gsub(" ","", MainDir);
			print MainDir;
			break;
	}
}

