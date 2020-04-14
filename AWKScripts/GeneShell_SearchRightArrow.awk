#!/usr/bin/gawk -f
# GeneShell_SearchRightArrow.awk
# awk -f AWKScripts/GeneShell_SearchRightArrow.awk $MainDir/Result_Exec_SearchNotFound.csv

# ------------------------------------------------------------------

BEGIN{
	FS = ",";
	cmd = "gawk -f AWKScripts/ReplyDirTime.awk -v Mode=02";
	while(cmd | getline MainDir){
		break;
	}
	close(cmd);
	ExecShell = MainDir"/Exec_SearchRightArrow.sh";
	ResultCSV = MainDir"/Sentinel_03_CSV.csv";
	print "#!/bin/sh" > ExecShell;
	print "# sh "ExecShell" > "ResultCSV > ExecShell;
	print "# bashdb "ExecShell" > "ResultCSV > ExecShell;
	print "" > ExecShell;
	print ". ./ShellScripts/BuiltIn_Check.sh" > ExecShell;
	print "" > ExecShell;
	ExistedArrayCnt = 1;
	NotFoundArraysCnt = 1;
	FGREP_CMD_02 = "fgrep -q \"<a href=\" & ";
	ErrorBit = 0;
}

/./{
	switch($7){
		case "0":
			print "検索キーワード　：　"$3"　は、検索結果が存在しませんでした。";
			NotFoundArrays[NotFoundArraysCnt] = $0",NOT FOUND";
			NotFoundArraysCnt++;
			break;
		case "1":
			print "検索キーワード　：　"$3"　は、検索結果が存在しました。";
			print "処理を継続します。";
			# <i class="icon-arrow-right"></i>
			# 「＞」ボタンがあるかないか
			# ある場合は、1行上にハイパーリンクが仕込んである
			FGREP_CMD_01 = "fgrep -B 1 \"<i class=\\\"icon-arrow-right\\\"></i>\" "$5;
			FGREP_CMD = FGREP_CMD_01" | "FGREP_CMD_02;
			FGREP_Arrays[ExistedArrayCnt] = FGREP_CMD;
			LINEArrays[ExistedArrayCnt] = $0;
			ExistedArrayCnt++;
			break;
		default:
			ErrorBit++;
			exit 99;
	}
}

END{
	if(ErrorBit != 0){
		exit 99;
	}
	if(ExistedArrayCnt == 1){
		exit 255;
	}
	for(i in NotFoundArrays){
		print "$ECHO\""NotFoundArrays[i]"\"" > ExecShell;
	}
	WaitArraysCnt = 1;
	Len = length(FGREP_Arrays);
	for(i in FGREP_Arrays){
		# 50並列まで
		Remainder = i % 50;
		# 配列の終端の場合
		if(i == Len){
			Remainder = 0;
		}
		# バックグラウンドでfgrepを実行
		print FGREP_Arrays[i] > ExecShell;
		# 最後に起動した非同期リスト (バックグラウンドプロセス) のプロセス IDを格納
		WaitPIDArrays[WaitArraysCnt] = "FGREP_"WaitArraysCnt"_pid";
		RetCodeArrays[WaitArraysCnt] = "RetCode_"WaitPIDArrays[WaitArraysCnt];
		LineTempArrays[WaitArraysCnt] = LINEArrays[i];
		print WaitPIDArrays[WaitArraysCnt]"=$!" > ExecShell;
		print "" > ExecShell;
		# 配列の終端、または50件目で、waitを発行する
		if(Remainder == 0){
			for(j in WaitPIDArrays){
				print "wait $"WaitPIDArrays[j] > ExecShell;
				print RetCodeArrays[j]"=$?" > ExecShell;
			}
			for(j in LineTempArrays){
				print "$ECHO\""LineTempArrays[j]",$"RetCodeArrays[j]"\"" > ExecShell;
			}
			# 終端でない場合、復帰値格納変数を初期化する
			if(i < Len){
				for(j in RetCodeArrays){
					print RetCodeArrays[j]"=0" > ExecShell;
				}
			}
			WaitArraysCnt = 1;
			delete WaitPIDArrays;
			delete RetCodeArrays;
			delete LineTempArrays;
		} else {
			WaitArraysCnt++;
		}
	}
	print "exit 0" > ExecShell;
	print "" > ExecShell;
}

