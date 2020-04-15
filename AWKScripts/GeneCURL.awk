#!/usr/bin/gawk -f
# GeneCURL.awk
# awk -f AWKScripts/GeneCURL.awk -v ConnectMode=$ConnectCMD $MainDir/Component.tsv

BEGIN{
	Cnt = 0;
	if(ConnectMode != "CURL" && ConnectMode != "WGET"){
		Cnt++;
		exit;
	}
	FS = "\t";
	print "#!/bin/sh";
	# ‹¤’Ê•”•ª
	RetCode_01 = "RetCode_01=$?";
	Skip_01 = "test $RetCode_01 -eq 0 && echo \"SHA-512 check is OK.\"";
	Skip_02 = "test $RetCode_01 -eq 0 && echo \"HTML file acquisition skipped.\"";
	PreCONNECT_01 = "test $RetCode_01 -ne 0 && echo \"HTML file acquisition start ...\"";
	RetCode_02 = "RetCode_02=$?";
	CONNECT_Check_02 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"HTML file acquisition complete.\"";
	SLEEP = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"sleep start...\" && sleep 3";
}

{
	Declare();
	Construct();
}

END{
	if(Cnt > 0){
		exit 99;
	}
	print "exit 0";
	print "";
}

function Declare(){
	SHA512_Check = "sha512sum -c --quiet \""$10"\" > /dev/null 2>&1";
	Skip_03 = "test $RetCode_01 -eq 0 && echo \"HTML File : "$9", Hash File : "$10"\"";
	PreCONNECT_02 = "test $RetCode_01 -ne 0 && echo \"URL : "$1"\"";
	PreCONNECT_03 = "test $RetCode_01 -ne 0 && echo \"HTML File : "$9"\"";
	if(ConnectMode == "CURL"){
		CONNECT = "test $RetCode_01 -ne 0 && curl -s -o \""$9"\" \""$1"\"";
	} else {
		CONNECT = "test $RetCode_01 -ne 0 && wget -q \""$1"\" -O \""$9"\"";
	}
	CONNECT_Check_01 = "test $RetCode_01 -ne 0 && test $RetCode_02 -ne 0 && echo \"CONNECT ERROR : HTML File : "$9"\" && exit 99";
	CONNECT_Check_03 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"HTML File : "$9"\"";
	CONNECT_Check_04 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"Hash File : "$10"\"";
	SHA512_Exec = "sha512sum \""$9"\" > \""$10"\"";
}

function Construct(){
	print "";
	print SHA512_Check;
	print RetCode_01;
	print Skip_01;
	print Skip_02;
	print Skip_03;
	print PreCONNECT_01;
	print PreCONNECT_02;
	print PreCONNECT_03;
	print CONNECT;
	print RetCode_02;
	print CONNECT_Check_01;
	print SHA512_Exec;
	print CONNECT_Check_02;
	print CONNECT_Check_03;
	print CONNECT_Check_04;
	print SLEEP;
	print "";
}

