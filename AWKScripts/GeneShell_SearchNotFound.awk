#!/usr/bin/gawk -f
# GeneShell_SearchNotFound.awk
# awk -f AWKScripts/GeneShell_SearchNotFound.awk $MainDir/Sentinel_01_CSV.csv

# ------------------------------------------------------------------

BEGIN{
	FS = ",";
	cmd = "gawk -f AWKScripts/ReplyDirTime.awk -v Mode=02";
	while(cmd | getline MainDir){
		break;
	}
	close(cmd);
	ExecShell = MainDir"/Exec_SearchNotFound.sh";
	ResultCSV = MainDir"/Sentinel_02_CSV.csv";
	print "#!/bin/sh" > ExecShell;
	print "# sh "ExecShell" > "ResultCSV > ExecShell;
	print "# bashdb "ExecShell" > "ResultCSV > ExecShell;
	print "" > ExecShell;
	print ". ./ShellScripts/BuiltIn_Check.sh" > ExecShell;
	print "" > ExecShell;
	KEYWORD = "該当する商品が見つかりません。検索条件を変えて、再度お試しください。";
	ArrayCnt = 1;
}

/./{
	FGREP_CMD = "fgrep -q \""KEYWORD"\" "$4" & ";
	FGREP_Arrays[ArrayCnt] = FGREP_CMD;
	# ナンバリング
	LINEArrays[ArrayCnt] = ArrayCnt","$0;
	ArrayCnt++;
}

END{
	if(ArrayCnt == 1){
		exit 99;
	}
	
	# -------------------------------------------------------------------------------------------------
	
	# http://magicant.txt-nifty.com/main/2009/05/id-3b0c.html
	# シェルの非同期コマンドとプロセス ID に関する問題: まじかんと雑記
	
	# プロセス ID が同じくなることが問題なので、同じくならないようにすれば万事解決である。
	# その為の唯一の方法は、コマンドが終了しても直ぐに wait((p)id) を行わないことだ。
	# シェルが wait((p)id) を行わないうちは、終了したプロセスは未だ成仏していないので、
	# 他のプロセスにプロセス ID を使われることはなくなる。
	# しかしこの方法は、スクリプト内で wait コマンドが実行されるまで未成仏のプロセス
	#  (いわゆるゾンビプロセス) が居残り続けるという新たな問題を生む。
	# 起動する非同期コマンドの数が少なければそれほど問題ではないが、
	# 何百も非同期コマンドをぽんぽん起動するようなスクリプトでは大問題となる
	#  (システムがゾンビプロセスで溢れかえって普通のプロセスが起動できなくなる虞がある)。
	
	# -------------------------------------------------------------------------------------------------
	
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

