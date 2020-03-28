#!/usr/bin/gawk -f
# GeneSentinel_02.awk
# gawk -f AWKScripts/GeneSentinel_02.awk $MainDir/Sentinel_01_CSV.csv

# ------------------------------------------------------------------

BEGIN{
	FS = ",";
	cmd = "gawk -f AWKScripts/ReplyDirTime.awk -v Mode=02";
	while(cmd | getline MainDir){
		break;
	}
	close(cmd);
	ExecShell = MainDir"/Exec_Sentinel_02.sh";
	OUTCSV = MainDir"/Sentinel_02_CSV.csv";
	print "#!/bin/sh" > ExecShell;
	print "# sh "ExecShell" > "OUTCSV > ExecShell;
	print "" > ExecShell;
	KEYWORD = "該当する商品が見つかりません。検索条件を変えて、再度お試しください。";
	ArrayCnt = 1;
}

/./{
	print "fgrep -q \""KEYWORD"\" "$4" & " > ExecShell;
	NRArrays[ArrayCnt] = "RetCode_"ArrayCnt"_pid";
	RETArrays[ArrayCnt] = "RetCode_"ArrayCnt;
	LINEArrays[ArrayCnt] = $0;
	print NRArrays[ArrayCnt]"=$!" > ExecShell;
	ArrayCnt++;
}

END{
	for(i in NRArrays){
		print "wait $"NRArrays[i] > ExecShell;
		print RETArrays[i]"=$?" > ExecShell;
	}
	for(i in RETArrays){
		print "echo \""LINEArrays[i]",$"RETArrays[i]"\"" > ExecShell;
	}
	print "exit" > ExecShell;
	print "" > ExecShell;
}

