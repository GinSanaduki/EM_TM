#!/usr/bin/gawk -f
# GeneSentinel_03.awk
# gawk -f AWKScripts/GeneSentinel_03.awk $MainDir/Sentinel_02_CSV.csv

# ------------------------------------------------------------------

BEGIN{
	FS = ",";
	cmd = "gawk -f AWKScripts/ReplyDirTime.awk -v Mode=02";
	while(cmd | getline MainDir){
		break;
	}
	close(cmd);
	ExecShell = MainDir"/Exec_Sentinel_03.sh";
	OUTCSV = MainDir"/Sentinel_03_CSV.csv";
	print "#!/bin/sh" > ExecShell;
	print "# sh "ExecShell" > "OUTCSV > ExecShell;
	print "" > ExecShell;
	ArrayCnt = 1;
	NotFoundArraysCnt = 1;
}

/./{
	switch($6){
		case "0":
			print "検索キーワード　：　"$1"は、検索結果が存在しませんでした。";
			NotFoundArrays[NotFoundArraysCnt] = $0;
			NotFoundArraysCnt++;
			break;
		case "1":
			print "検索キーワード　：　"$1"は、検索結果が存在しました。";
			print "処理を継続します。";
			# <i class="icon-arrow-right"></i>
			# 「＞」ボタンがあるかないか
			# ある場合は、1行上にハイパーリンクが仕込んである
			print "fgrep -B 1 \"<i class=\\\"icon-arrow-right\\\"></i>\" "$4" | fgrep -q \"<a href=\" & " > ExecShell;
			NRArrays[ArraysCnt] = "RetCode_"ArraysCnt"_pid";
			RETArrays[ArraysCnt] = "RetCode_"ArraysCnt;
			LINEArrays[ArraysCnt] = $0;
			print NRArrays[ArraysCnt]"=$!" > ExecShell;
			ArraysCnt++;
			break;
		default:
			exit 99;
	}
}

END{
	for(i in NRArrays){
		print "wait $"NRArrays[i] > ExecShell;
		print RETArrays[i]"=$?" > ExecShell;
	}
	for(i in NotFoundArrays){
		print "echo \""NotFoundArrays[i]",NOT FOUND\"" > ExecShell;
	}
	for(i in RETArrays){
		print "echo \""LINEArrays[i]",$"RETArrays[i]"\"" > ExecShell;
	}
	print "exit" > ExecShell;
	print "" > ExecShell;
}

