#!/usr/bin/gawk -f
# GeneCURL_Deux.awk
# awk -f AWKScripts/GeneCURL_Deux.awk

BEGIN{
	FS = "\t";
	print "#!/bin/sh";
	# ‹¤’Ê•”•ª
	RetCode_01 = "RetCode_01=$?";
	Skip_01 = "test $RetCode_01 -eq 0 && echo \"SHA-512 check is OK.\"";
	Skip_02 = "test $RetCode_01 -eq 0 && echo \"IMG file acquisition skipped.\"";
	PreCURL_01 = "test $RetCode_01 -ne 0 && echo \"IMG file acquisition start ...\"";
	RetCode_02 = "RetCode_02=$?";
	CURL_Check_02 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"IMG file acquisition complete.\"";
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
	split($1,ImgArrays,"/");
	ImgArrays[4] = "Exhibition_InfoIMG";
	HashFile = "HashList_"ImgArrays[length(ImgArrays)];
	sub(/\.tsv$/,".jpg.txt",HashFile);
	ImgFile = ImgArrays[length(ImgArrays)];
	sub(/\.tsv$/,".jpg",ImgFile);
	CommonPath = ImgArrays[1]"/"ImgArrays[2]"/"ImgArrays[3]"/"ImgArrays[4]"/"ImgArrays[5];
	HashFilePath = CommonPath"/"HashFile;
	ImgFilePath = CommonPath"/"ImgFile;
	
	SHA512_Check = "sha512sum -c --quiet \""HashFilePath"\" > /dev/null 2>&1";
	Skip_03 = "test $RetCode_01 -eq 0 && echo \"IMG File : "ImgFilePath", Hash File : "HashFilePath"\"";
	PreCURL_02 = "test $RetCode_01 -ne 0 && echo \"URL : "$4"\"";
	PreCURL_03 = "test $RetCode_01 -ne 0 && echo \"IMG File : "ImgFilePath"\"";
	CURL = "test $RetCode_01 -ne 0 && curl -s \""$4"\" > \""ImgFilePath"\"";
	CURL_Check_01 = "test $RetCode_01 -ne 0 && test $RetCode_02 -ne 0 && echo \"CURL ERROR : IMG File : "ImgFilePath"\" && exit 99";
	CURL_Check_03 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"IMG File : "ImgFilePath"\"";
	CURL_Check_04 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"Hash File : "HashFilePath"\"";
	SHA512_Exec = "sha512sum \""ImgFilePath"\" > \""HashFilePath"\"";
	delete ImgArrays;
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

