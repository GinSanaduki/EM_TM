#!/usr/bin/gawk -f
# GeneSentinel_01.awk
# gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_01 -v GeneMercariMode=NORMAL Define_SearchWord.conf
# gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_01 -v GeneMercariMode=HTML Define_SearchWord.conf

# gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_02 -v GeneMercariMode=NORMAL $MainDir/Sentinel_04_CSV.csv
# gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_02 -v GeneMercariMode=HTML $MainDir/Sentinel_04_CSV.csv

# gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_02_EXTEND -v GeneMercariMode=NORMAL
# gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_02_EXTEND -v GeneMercariMode=HTML

# gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_03 -v GeneMercariMode=NORMAL $MainDir/Sentinel_05_CSV.csv
# gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_03 -v GeneMercariMode=HTML $MainDir/Sentinel_05_CSV.csv

# ------------------------------------------------------------------

@include "AWKScripts/GeneSentinel_Sub00.awk";
@include "AWKScripts/GeneSentinel_Sub01.awk";
@include "AWKScripts/GeneSentinel_Sub02.awk";
@include "AWKScripts/GeneSentinel_Sub03.awk";

# ------------------------------------------------------------------

BEGIN{
	switch(GeneMercariMode){
		case "NORMAL":
			break;
		case "HTML":
			break;
		default:
			exit 99;
	}
	
	switch(Mode){
		case "Sentinel_01":
			break;
		case "Sentinel_02":
			FS = ",";
			break;
		case "Sentinel_02_EXTEND":
			# 標準出力で、空白スペース区切りで受け取る
			break;
		case "Sentinel_03":
			FS = ",";
			break;
		default:
			exit 99;
	}
	
	cmd = "gawk -f AWKScripts/ReplyDirTime.awk -v Mode=02";
	while(cmd | getline MainDir){
		break;
	}
	close(cmd);
	
	switch(Mode){
		case "Sentinel_02":
			break;
		default:
			cmd = "which chromedriver";
			while(cmd | getline Driver){
				break;
			}
			close(cmd);
	}
	
	TimeOutMessage = "接続がタイムアウトしました。";
	FileIOErrorMessage = "出力対象ファイルの書き込みに失敗しました。";
	PermissionErrorMessage = "出力対象ファイルの書き込み権限がありません。";
	OSErrorMessage = "出力対象ファイルの書き込みに失敗しました。（OSError）";
	OSErrorMessage_02 = "Chrome Driverに異常が発生しました。（OSError）";
	OtherError = "予期せぬエラーが発生しました。";
	ArraysCnt = 1;
	NonArraysCnt = 1;
}

# ------------------------------------------------------------------

/./{
	switch(Mode){
		case "Sentinel_02":
			PreWrapper();
			break;
		default:
			PreGene();
			break;
	}
}

# ------------------------------------------------------------------

END{
	switch(Mode){
		case "Sentinel_02_EXTEND":
			exit;
		case "Sentinel_02":
			break;
		default:
			Monitor_Killer = MainDir"/Monitor_Killer.sh";
			Sentinel_Bit = MainDir"/Sentinel_Bit.txt";
			Gene_Monitor_Killer();
			break;
	}
	
	Gene_ExecShell();
	
	switch(Mode){
		case "Sentinel_02":
			exit;
	}
	
	Gene_MonitorShell();
	Gene_SupervisorShell();
	
	switch(Mode){
		case "Sentinel_01":
			break;
		default:
			exit;
	}
	
	for(i in SubShellArrays){
		CSV_LINE = SubShellArrays[i][4]","SubShellArrays[i][5]","SubShellArrays[i][2]","SubShellArrays[i][7]","SubShellArrays[i][9];
		print CSV_LINE > ResultCSV;
	}
	
}

