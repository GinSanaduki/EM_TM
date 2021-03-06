#!/usr/bin/gawk -f
# GeneSentinel_Sub03.awk

# ------------------------------------------------------------------

function Gene_Monitor_Killer(){
	switch(Mode){
		case "Sentinel_01":
			break;
		case "Sentinel_03":
			break;
		default:
			ErrorBit++;
			exit 99;
	}
	print "#!/bin/sh" > Monitor_Killer;
	print "# sh "Monitor_Killer > Monitor_Killer;
	print "# bashdb "Monitor_Killer > Monitor_Killer;
	print "" > Monitor_Killer;
	print ". ./ShellScripts/BuiltIn_Check.sh" > Monitor_Killer;
	print "" > Monitor_Killer;
	print "while :" > Monitor_Killer;
	print "do" > Monitor_Killer;
	print "	ls "Sentinel_Bit" > /dev/null 2>&1" > Monitor_Killer;
	print "	RetCode=$?" > Monitor_Killer;
	print "	case \"$RetCode\" in" > Monitor_Killer;
	print "		\"0\")" > Monitor_Killer;
	print "			ps -aux | grep Monitor_Sentinel | grep -v grep | awk -f AWKScripts/GeneKill.awk | sh > /dev/null 2>&1" > Monitor_Killer;
	print "			exit 0" > Monitor_Killer;
	print "	esac" > Monitor_Killer;
	print "	" > Monitor_Killer;
	print "done" > Monitor_Killer;
	print "" > Monitor_Killer;
}

# ------------------------------------------------------------------

function Gene_ExecShell(){
	switch(Mode){
		case "Sentinel_01":
			break;
		case "Sentinel_02":
			break;
		case "Sentinel_03":
			break;
		default:
			ErrorBit++;
			exit 99;
	}
	ExecShell = MainDir"/Exec_"Mode".sh";
	print "#!/bin/sh" > ExecShell;
	print "# sh "ExecShell > ExecShell;
	print "# bashdb "ExecShell > ExecShell;
	print "" > ExecShell;
	print ". ./ShellScripts/BuiltIn_Check.sh" > ExecShell;
	print "" > ExecShell;
	
	switch(Mode){
		case "Sentinel_02":
			print "rm -f "ResultCSV" > /dev/null 2>&1" > ExecShell;
			# CSVに、本件処理対象外の行を出力する
			for(i in NonArrays){
				print "$ECHO\""NonArrays[i]"\" >> "ResultCSV > ExecShell;
			}
			break;
		default:
			# Sentinel_Bit.txtの存在有無により、監視の終了を決める
			print "rm -f "Sentinel_Bit" > /dev/null 2>&1" > ExecShell;
			break;
	}
	XAxisCnt = 1;
	switch(Mode){
		# 3並列ずつバックグラウンドで処理させる
		# 無限ループですべての復帰値が0になるまで実行させ、chromeの副産物を処理しつつ、次の処理へ遷移する。
		case "Sentinel_02":
			Reload_WrapperShell();
			break;
		default:
			Reload_SubShell();
			break;
	}
	# 空きスロットに、復帰値255を返す1行Shellコマンドを書き込む
	EXIT_255 = "-c \047exit 255\047";
	for(i in SubShellArraysXY){
		if(SubShellArraysXY[i][1] == ""){
			SubShellArraysXY[i][1] = EXIT_255;
			BitPanelArraysXY[i][1] = ":";
		}
		if(SubShellArraysXY[i][2] == ""){
			SubShellArraysXY[i][2] = EXIT_255;
			BitPanelArraysXY[i][2] = ":";
		}
		if(SubShellArraysXY[i][3] == ""){
			SubShellArraysXY[i][3] = EXIT_255;
			BitPanelArraysXY[i][3] = ":";
		}
	}
	
	for(i in SubShellArraysXY){
		print "RETRY_CNT=0" > ExecShell;
		print "while :" > ExecShell;
		print "do" > ExecShell;
		print "	$TEST$RETRY_CNT -gt 5 && $ECHO\"リトライ許容回数を超過したため、異常終了します。\"" > ExecShell;
		print "	$TEST$RETRY_CNT -gt 5 && ps -aux | grep Monitor_Sentinel | grep -v grep | awk -f AWKScripts/GeneKill.awk | sh > /dev/null 2>&1" > ExecShell;
		switch(Mode){
			case "Sentinel_01":
				print "	$TEST$RETRY_CNT -gt 5 && ps -aux | grep Monitor_Sentinel | grep -v grep | awk -f AWKScripts/GeneKill.awk | sh > /dev/null 2>&1" > ExecShell;
				print "	$TEST$RETRY_CNT -gt 5 && : > "Sentinel_Bit > ExecShell;
				break;
			case "Sentinel_03":
				print "	$TEST$RETRY_CNT -gt 5 && ps -aux | grep Monitor_Sentinel | grep -v grep | awk -f AWKScripts/GeneKill.awk | sh > /dev/null 2>&1" > ExecShell;
				print "	$TEST$RETRY_CNT -gt 5 && : > "Sentinel_Bit > ExecShell;
				break;
		}
		print "	$TEST$RETRY_CNT -gt 5 && exit 99" > ExecShell;
		# ループ内で処理で使用するビットパネルのみを削除
		if(BitPanelArraysXY[i][1] != ":"){
			print "	"BitPanelArraysXY[i][1] > ExecShell;
		}
		if(BitPanelArraysXY[i][2] != ":"){
			print "	"BitPanelArraysXY[i][2] > ExecShell;
		}
		if(BitPanelArraysXY[i][3] != ":"){
			print "	"BitPanelArraysXY[i][3] > ExecShell;
		}
		# ChromeやChrome Driver、Seleniumのプロセス等を一旦削除
		print "	$TEST$RETRY_CNT -gt 1 && sh ./ShellScripts/Sweeper.sh" > ExecShell;
		print "	$TEST$RETRY_CNT -gt 1 && sleep 3" > ExecShell;
		# python or ラッパーShellを実行
		switch(SubShellArraysXY[i][1]){
			case "-c \047exit 255\047":
				print "	sh "EXIT_255" & " > ExecShell;
				break;
			default:
				switch(Mode){
					case "Sentinel_01":
						print "	"SubShellArraysXY[i][1]" & " > ExecShell;
						break;
					case "Sentinel_02":
						print "	sh "SubShellArraysXY[i][1]" & " > ExecShell;
						break;
					case "Sentinel_03":
						print "	"SubShellArraysXY[i][1]" & " > ExecShell;
						break;
				}
				break;
		}
		print "	python_01_pid=$!" > ExecShell;
		switch(SubShellArraysXY[i][2]){
			case "-c \047exit 255\047":
				print "	sh "EXIT_255" & " > ExecShell;
				break;
			default:
				switch(Mode){
					case "Sentinel_01":
						print "	"SubShellArraysXY[i][2]" & " > ExecShell;
						break;
					case "Sentinel_02":
						print "	sh "SubShellArraysXY[i][2]" & " > ExecShell;
						break;
					case "Sentinel_03":
						print "	"SubShellArraysXY[i][2]" & " > ExecShell;
						break;
				}
				break;
		}
		print "	python_02_pid=$!" > ExecShell;
		switch(SubShellArraysXY[i][3]){
			case "-c \047exit 255\047":
				print "	sh "EXIT_255" & " > ExecShell;
				break;
			default:
				switch(Mode){
					case "Sentinel_01":
						print "	"SubShellArraysXY[i][3]" & " > ExecShell;
						break;
					case "Sentinel_02":
						print "	sh "SubShellArraysXY[i][3]" & " > ExecShell;
						break;
					case "Sentinel_03":
						print "	"SubShellArraysXY[i][3]" & " > ExecShell;
						break;
				}
				break;
		}
		print "	python_03_pid=$!" > ExecShell;
		print "	wait $python_01_pid" > ExecShell;
		print "	RetCode_01=$?" > ExecShell;
		print "	wait $python_02_pid" > ExecShell;
		print "	RetCode_02=$?" > ExecShell;
		print "	wait $python_03_pid" > ExecShell;
		print "	RetCode_03=$?" > ExecShell;
		print "	$ECHO\"$RetCode_01 $RetCode_02 $RetCode_03\" | awk -f AWKScripts/RetCodeJudge.awk" > ExecShell;
		print "	RetCode_RetCodeJudge=$?" > ExecShell;
		print "	case \"$RetCode_RetCodeJudge\" in" > ExecShell;
		print "		\"255\")" > ExecShell;
		print "			break" > ExecShell;
		print "			;;" > ExecShell;
		print "	esac" > ExecShell;
		# ChromeやChrome Driver、Seleniumのプロセス等を一旦削除
		print "	sh ./ShellScripts/Sweeper.sh" > ExecShell;
		print "	sleep 3" > ExecShell;
		print "	case \"$RetCode_RetCodeJudge\" in" > ExecShell;
		print "		\"0\")" > ExecShell;
		print "			break" > ExecShell;
		print "			;;" > ExecShell;
		print "	esac" > ExecShell;
		print "	RETRY_CNT=$(( RETRY_CNT + 1 ))" > ExecShell;
		print "	$ECHO\"リトライ：$RETRY_CNT回目\"" > ExecShell;
		print "done" > ExecShell;
		print "" > ExecShell;
	}
	InsertSentinel();
	print "$ECHO\"全件の取得処理が完了しました。\"" > ExecShell;
	switch(Mode){
		case "Sentinel_03":
			print "$ECHO\"CSVの出力を開始します・・・\"" > ExecShell;
			print ": > \""ResultCSV"\"" > ExecShell;
			print "" > ExecShell;
			if(length(OutArrays) < 1){
				ErrorBit++;
				exit 99;
			}
			for(i in OutArrays){
				print "$ECHO\""OutArrays[i]"\" >> "ResultCSV > ExecShell;
			}
			print "" > ExecShell;
			print "$ECHO\"CSVの出力が完了しました。\"" > ExecShell;
			break;
	}
	print "" > ExecShell;
	print "exit 0" > ExecShell;
	print "" > ExecShell;
}

# ------------------------------------------------------------------

function InsertSentinel(){
	# Monitor_Killerの起動センチネル
	switch(Mode){
		case "Sentinel_01":
			break;
		case "Sentinel_03":
			break;
		default:
			return;
	}
	print ": > "Sentinel_Bit > ExecShell;
}

# ------------------------------------------------------------------

function Gene_MonitorShell(){
	# 実行監視Shell
	MonitorShell = MainDir"/Monitor_"Mode".sh";
	# 実行監視用
	# 処理件数×60秒を監視リミットとする
	print "#!/bin/sh" > MonitorShell;
	print "# sh "MonitorShell > MonitorShell;
	print "# bashdb "MonitorShell > MonitorShell;
	print "" > MonitorShell;
	print ". ./ShellScripts/BuiltIn_Check.sh" > MonitorShell;
	print "" > MonitorShell;
	print "trap \"sh ./ShellScripts/Sweeper.sh\" 1 2 3 15" > MonitorShell;
	print "StartTime=`gawk -f AWKScripts/ReplyDirTime.awk -v Mode=03`" > MonitorShell;
	print "HTMLMaxCnt="length(Sentinel_Arrays_HTML) > MonitorShell;
	switch(GeneMercariMode){
		case "NORMAL":
			print "ScreenShotMaxCnt="length(Sentinel_Arrays_ScreenShot) > MonitorShell;
			break;
	}
	print "EndTime=$(( StartTime + HTMLMaxCnt * 60 ))" > MonitorShell;
	print "while :" > MonitorShell;
	print "do" > MonitorShell;
	print "	$ECHO$EndTime | awk -f AWKScripts/LimitCount.awk" > MonitorShell;
	print "	RetCode_00=$?" > MonitorShell;
	print "	DATE=`date \"+%Y年%m月%d日 %H時%M分%S秒\"`" > MonitorShell;
	print "	$TEST$RetCode_00 -eq 99 && $ECHO\"監視予定時刻を超過したため、監視を終了します。　$DATE\" && exit 99" > MonitorShell;
	print "	HTMLCnt=0" > MonitorShell;
	print "	ScreenShotCnt=0" > MonitorShell;
	# BitPanelの存在を検知し、BitPanelが「99」、「09」の場合は、異常終了。
	# 「0」の場合、HTMLCntをインクリメントし、「00」の場合、HTMLCntとScreenShotCntをインクリメントする。
	for(i in SubShellArrays){
		print "	ls \""SubShellArrays[i][3]"\" > /dev/null 2>&1" > MonitorShell;
		print "	RetCode_01=$?" > MonitorShell;
		print "	$TEST$RetCode_01 -eq 0 && awk -f AWKScripts/Monitor_Sub01.awk \""SubShellArrays[i][3]"\"" > MonitorShell;
		print "	RetCode_02=$?" > MonitorShell;
		switch(GeneMercariMode){
			case "NORMAL":
				print "	$TEST$RetCode_01 -eq 0 -a $RetCode_02 -eq 1 && HTMLCnt=$(( HTMLCnt + 1 ))" > MonitorShell;
				print "	$TEST$RetCode_01 -eq 0 -a $RetCode_02 -eq 2 && HTMLCnt=$(( HTMLCnt + 1 )) && ScreenShotCnt=$(( ScreenShotCnt + 1 ))" > MonitorShell;
				break;
			case "HTML":
				# HTMLモードの場合、ビットパネル出力は00、99しかない
				print "	$TEST$RetCode_01 -eq 0 -a $RetCode_02 -eq 2 && HTMLCnt=$(( HTMLCnt + 1 ))" > MonitorShell;
				break;
		}
	}
	print "	DATE=`date \"+%Y年%m月%d日 %H時%M分%S秒\"`" > MonitorShell;
	print "	HTML_Percent=`$ECHO\"$HTMLCnt\" \"$HTMLMaxCnt\" | awk -f AWKScripts/ReplyProgress.awk`" > MonitorShell;
	print "	$ECHO\"実行中　：　HTML取得　：　$HTMLCnt / $HTMLMaxCnt件（$HTML_Percent％完了）　$DATE\"" > MonitorShell;
	switch(GeneMercariMode){
		case "NORMAL":
			print "	ScreenShot_Percent=`$ECHO\"$ScreenShotCnt\" \"$ScreenShotMaxCnt\" | awk -f AWKScripts/ReplyProgress.awk`" > MonitorShell;
			print "	$ECHO\"実行中　：　スクリーンショット取得　：　$ScreenShotCnt / $ScreenShotMaxCnt件（$ScreenShot_Percent％完了）\"　$DATE" > MonitorShell;
			print "	$TEST$HTML_Percent -ge 100 -a $ScreenShot_Percent -ge 100 && $ECHO\"監視を終了します。\" && exit 0" > MonitorShell;
			break;
		case "HTML":
			print "	$TEST$HTML_Percent -ge 100 && $ECHO\"監視を終了します。\" && exit 0" > MonitorShell;
			break;
	}
	print "	sleep 5" > MonitorShell;
	print "done" > MonitorShell;
	print "" > MonitorShell;
}

# ------------------------------------------------------------------

function Gene_SupervisorShell(){
	switch(Mode){
		case "Sentinel_01":
			break;
		case "Sentinel_03":
			break;
		default:
			ErrorBit++;
			exit 99;
	}
	# 統括Shell
	Supervisor = MainDir"/Supervisor_"Mode".sh";
	print "#!/bin/sh" > Supervisor;
	print "# sh "Supervisor > Supervisor;
	print "# bashdb "Supervisor > Supervisor;
	print "" > Supervisor;
	print "sh "ExecShell" & " > Supervisor;
	print "ExecShell_PID=$!" > Supervisor;
	print "sh "MonitorShell" & " > Supervisor;
	print "MonitorShell_PID=$!" > Supervisor;
	print "sh "Monitor_Killer" & " > Supervisor;
	print "Monitor_Killer_PID=$!" > Supervisor;
	print "wait $ExecShell_PID" > Supervisor;
	print "RetCode_ExecShell=$?" > Supervisor;
	print "wait $MonitorShell_PID" > Supervisor;
	print "RetCode_MonitorShell=$?" > Supervisor;
	print "wait $Monitor_Killer_PID" > Supervisor;
	print "RetCode_Monitor_Killer=$?" > Supervisor;
	print "test $RetCode_ExecShell -ne 0 && exit 99" > Supervisor;
	print "exit 0" > Supervisor;
	print "" > Supervisor;
}
# ------------------------------------------------------------------

function Sorting(Sorting_Code, Sorting_Script){
	switch(Sorting_Code){
		case "1":
			break;
		case "2":
			break;
		case "3":
			break;
		default:
			ErrorBit++;
			exit 99;
	}
	
	# 復帰値の振り分け
	print "	$TEST$RetCode_0"Sorting_Code" -eq 0" > ExecShell;
	print "	RetCode_0"Sorting_Code"_IS_00=$?" > ExecShell;
	print "	$TEST$RetCode_0"Sorting_Code"_IS_00 -eq 1 && $TEST$RetCode_0"Sorting_Code" -eq 255" > ExecShell;
	print "	RetCode_0"Sorting_Code"_IS_255=$?" > ExecShell;
	
	# 255の場合、起因がEXIT_255以外かつSentinel_02以外の場合、ReplyMessages.awkをコールする
	switch(Sorting_Script){
		case "-c \047exit 255\047":
			break;
		default:
			switch(Mode){
				case "Sentinel_02":
					break;
				default:
					print "	$TEST$RetCode_0"Sorting_Code"_IS_255 -eq 0 && $ECHO\""Sorting_Script"\" | gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeSkipped_IS_255" > ExecShell;
					break;
			}
			break;
	}
	
	# 0の場合、起因がEXIT_255以外かつSentinel_02以外の場合、FileSizeJudge.awkをコールする
	switch(Sorting_Script){
		case "-c \047exit 255\047":
			break;
		default:
			switch(Mode){
				case "Sentinel_02":
					break;
				default:
					print "	$TEST$RetCode_0"Sorting_Code"_IS_00 -eq 0 && $ECHO\""Sorting_Script"\" | awk -f AWKScripts/FileSizeJudge.awk -v GeneMercariMode="GeneMercariMode > ExecShell;
					print "	FileSizeJudge_0"Sorting_Code"=$?" > ExecShell;
					# ファイルサイズチェックで何らかの異常が発生した場合、99で再度実行させる
					print "	$TEST$RetCode_0"Sorting_Code"_IS_00 -eq 0 && $TEST$FileSizeJudge_0"Sorting_Code" -ne 0 && RetCode_0"Sorting_Code"=99" > ExecShell;
					break;
			}
			break;
	}
}

# ------------------------------------------------------------------

