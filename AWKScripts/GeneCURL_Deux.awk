#!/usr/bin/gawk -f
# GeneCURL_Deux.awk
# awk -f AWKScripts/GeneCURL_Deux.awk -v ConnectMode=$ConnectCMD

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
	Skip_02 = "test $RetCode_01 -eq 0 && echo \"IMG file acquisition skipped.\"";
	PreCONNECT_01 = "test $RetCode_01 -ne 0 && echo \"IMG file acquisition start ...\"";
	RetCode_02 = "RetCode_02=$?";
	CONNECT_Check_02 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"IMG file acquisition complete.\"";
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
	PreCONNECT_02 = "test $RetCode_01 -ne 0 && echo \"URL : "$4"\"";
	PreCONNECT_03 = "test $RetCode_01 -ne 0 && echo \"IMG File : "ImgFilePath"\"";
	if(ConnectMode == "CURL"){
		CONNECT = "test $RetCode_01 -ne 0 && curl -s -o \""ImgFilePath"\" \""$4"\"";
	} else {
		CONNECT = "test $RetCode_01 -ne 0 && wget -q \""$4"\" -O \""ImgFilePath"\"";
	}
	CONNECT_Check_01 = "test $RetCode_01 -ne 0 && test $RetCode_02 -ne 0 && echo \"CONNECT ERROR : IMG File : "ImgFilePath"\" && exit 99";
	CONNECT_Check_03 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"IMG File : "ImgFilePath"\"";
	CONNECT_Check_04 = "test $RetCode_01 -ne 0 && test $RetCode_02 -eq 0 && echo \"Hash File : "HashFilePath"\"";
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

