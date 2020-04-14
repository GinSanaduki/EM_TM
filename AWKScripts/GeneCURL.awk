#!/usr/bin/gawk -f
# GeneCURL.awk
# awk -f AWKScripts/GeneCURL.awk $MainDir/Component.tsv

BEGIN{
	FS = "\t";
	print "#!/bin/sh";
	# ‹¤’Ê•”•ª
	RetCode_01 = "RetCode_01=$?";
	Skip_01 = "test $RetCode_01 -eq 0 && echo \"SHA-512 check is OK.\"";
	Skip_02 = "test $RetCode_01 -eq 0 && echo \"HTML file acquisition skipped.\"";
	PreCURL_01 = "test $RetCode_01 -ne 0 && echo \"HTML file acquisition start ...\"";
	RetCode_02 = "RetCode_02=$?";
	CURL_Check_02 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"HTML file acquisition complete.\"";
	SLEEP = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"sleep start...\" && sleep 3";
}

{
	Declare();
	Construct();
}

END{
	print "exit 0";
	print "";
}

function Declare(){
	SHA512_Check = "sha512sum -c --quiet \""$10"\" > /dev/null 2>&1";
	Skip_03 = "test $RetCode_01 -eq 0 && echo \"HTML File : "$9", Hash File : "$10"\"";
	PreCURL_02 = "test $RetCode_01 -ne 0 && echo \"URL : "$1"\"";
	PreCURL_03 = "test $RetCode_01 -ne 0 && echo \"HTML File : "$9"\"";
	CURL = "test $RetCode_01 -ne 0 && curl -s \""$1"\" > \""$9"\"";
	CURL_Check_01 = "test $RetCode_01 -ne 0 && test $RetCode_02 -ne 0 && echo \"CURL ERROR : HTML File : "$9"\" && exit 99";
	CURL_Check_03 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"HTML File : "$9"\"";
	CURL_Check_04 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"Hash File : "$10"\"";
	SHA512_Exec = "sha512sum \""$9"\" > \""$10"\"";
}

function Construct(){
	print "";
	print SHA512_Check;
	print RetCode_01;
	print Skip_01;
	print Skip_02;
	print Skip_03;
	print PreCURL_01;
	print PreCURL_02;
	print PreCURL_03;
	print CURL;
	print RetCode_02;
	print CURL_Check_01;
	print SHA512_Exec;
	print CURL_Check_02;
	print CURL_Check_03;
	print CURL_Check_04;
	print SLEEP;
	print "";
}

