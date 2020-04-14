#!/usr/bin/gawk -f
# GeneSentinel_Sub02.awk

# ------------------------------------------------------------------

function PreWrapper(){
	switch(Mode){
		case "Sentinel_02":
			break;
		default:
			ErrorBit++;
			exit 99;
	}
	MaxPage = $9 + 0;
	if(MaxPage < 1){
		MaxPage = 1;
	}
	if(MaxPage == 1){
		NonArrays[NonArraysCnt] = $0;
		NonArraysCnt++;
		next;
	}
	# 追跡対象のキーワードでラッパーShellを作成
	SubDir = MainDir"/"Mode;
	MD(SubDir);
	File_or_Dir_Use_KeyWord = Inspector_ForD($3);
	WrapperShell = SubDir"/WrapperShell_"File_or_Dir_Use_KeyWord".sh";
	PID = "WrapperShell_"ArraysCnt"_PID";
	RETCODE = "RetCode_"PID;
	WrapperShellArrays[ArraysCnt][1] = WrapperShell;
	WrapperShellArrays[ArraysCnt][2] = PID;
	WrapperShellArrays[ArraysCnt][3] = RETCODE;
	GeneWrapper();
	ArraysCnt++;
}

# ------------------------------------------------------------------

function GeneWrapper(){
	switch(Mode){
		case "Sentinel_02":
			break;
		default:
			ErrorBit++;
			exit 99;
	}
	print "#!/bin/sh" > WrapperShellArrays[ArraysCnt][1];
	print "# sh "WrapperShellArrays[ArraysCnt][1] > WrapperShellArrays[ArraysCnt][1];
	print "# bashdb "WrapperShellArrays[ArraysCnt][1] > WrapperShellArrays[ArraysCnt][1];
	print "" > WrapperShellArrays[ArraysCnt][1];
	print ". ./ShellScripts/BuiltIn_Check.sh" > WrapperShellArrays[ArraysCnt][1];
	print "" > WrapperShellArrays[ArraysCnt][1];
	# gawkに引き渡す変数の初期化
	print "PageNumber="MaxPage > WrapperShellArrays[ArraysCnt][1];
	Keyword_Inspected = Inspector($3);
	print "KeyWord=\""Keyword_Inspected"\"" > WrapperShellArrays[ArraysCnt][1];
	print "KeyWord_Pre=\""$2"\"" > WrapperShellArrays[ArraysCnt][1];
	# SkipBit
	print "SkipBit=255" > WrapperShellArrays[ArraysCnt][1];
	Col_05 = $4;
	gsub(/_page_.*?.html/,"_page_",Col_05);
	CSVLine_from01_to08 = $1","$2","$3","$4","$5","$6","$7","$8;
	# ↓↓ここから無限ループ↓↓
	# 「icon-arrow-double-right」クラスのハイパーリンクが存在しなくなるまで、ページを辿っていく
	Keyword_Inspected_FD = Inspector_ForD($3);
	Sentinel = MainDir"/"Mode"/"Mode"_"Keyword_Inspected_FD"_$PageNumber.py";
	BitPanel = MainDir"/"Mode"/"Mode"_BitPanel_"Keyword_Inspected_FD"_$PageNumber.txt";
	ResultCSV = MainDir"/Sentinel_05_CSV.csv";
	print "CSVLine_from01_to08=\""CSVLine_from01_to08"\"" > WrapperShellArrays[ArraysCnt][1];
	print "while :" > WrapperShellArrays[ArraysCnt][1];
	print "do" > WrapperShellArrays[ArraysCnt][1];
	# ループ内部でAWKからPythonを自動生成する
	Sentinel_Line = "	Sentinel=\""Sentinel"\"";
	gsub("+","_",Sentinel_Line);
	BitPanel_Line = "	BitPanel=\""BitPanel"\"";
	gsub("+","_",BitPanel_Line);
	print Sentinel_Line > WrapperShellArrays[ArraysCnt][1];
	print BitPanel_Line > WrapperShellArrays[ArraysCnt][1];
	print "	: > $Sentinel" > WrapperShellArrays[ArraysCnt][1];
	print "	rm -f $BitPanel > /dev/null 2>&1" > WrapperShellArrays[ArraysCnt][1];
	print "	$ECHO\"$PageNumber $KeyWord $Sentinel $BitPanel\" | gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_02_EXTEND -v GeneMercariMode="GeneMercariMode > WrapperShellArrays[ArraysCnt][1];
	print "	RetCode=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	" > WrapperShellArrays[ArraysCnt][1];
	print "	case \"$RetCode\" in" > WrapperShellArrays[ArraysCnt][1];
	print "		\"0\")" > WrapperShellArrays[ArraysCnt][1];
	print "			$TEST$SkipBit -eq 255 && SkipBit=0" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "		\"255\")" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "		*)" > WrapperShellArrays[ArraysCnt][1];
	print "			$ECHO\"Pythonスクリプト生成段階で異常が発生しました。\"" > WrapperShellArrays[ArraysCnt][1];
	print "			exit 99" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "	esac" > WrapperShellArrays[ArraysCnt][1];
	print "	" > WrapperShellArrays[ArraysCnt][1];
	print "	$ECHO\"$RetCode $PageNumber $KeyWord_Pre\" | gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeSkipped" > WrapperShellArrays[ArraysCnt][1];
	print "	RetCode_02=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	RetCode_03=0" > WrapperShellArrays[ArraysCnt][1];
	print "	" > WrapperShellArrays[ArraysCnt][1];
	print "	case \"$RetCode_02\" in" > WrapperShellArrays[ArraysCnt][1];
	print "		\"1\")" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "		\"2\")" > WrapperShellArrays[ArraysCnt][1];
	print "			python $Sentinel > $BitPanel" > WrapperShellArrays[ArraysCnt][1];
	print "			RetCode_03=$?" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "		*)" > WrapperShellArrays[ArraysCnt][1];
	print "			exit 99" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "	esac" > WrapperShellArrays[ArraysCnt][1];
	print "	" > WrapperShellArrays[ArraysCnt][1];
	# ビットパネルが存在し、RetCode_03が0の場合に、出力対象ファイルのサイズチェックを行う
	# 255の場合、ビットパネルは未出力であり、存在しない
	print "	ls \"$BitPanel\" > /dev/null 2>&1" > WrapperShellArrays[ArraysCnt][1];
	print "	BitPanel_IsExist=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	case \"$BitPanel_IsExist\" in" > WrapperShellArrays[ArraysCnt][1];
	print "		\"0\")" > WrapperShellArrays[ArraysCnt][1];
	print "			case \"$RetCode_03\" in" > WrapperShellArrays[ArraysCnt][1];
	print "				\"0\")" > WrapperShellArrays[ArraysCnt][1];
	print "					$ECHO\"$Sentinel\" | awk -f AWKScripts/FileSizeJudge.awk -v GeneMercariMode="GeneMercariMode > WrapperShellArrays[ArraysCnt][1];
	print "					FileSizeJudge=$?" > WrapperShellArrays[ArraysCnt][1];
	print "					;;" > WrapperShellArrays[ArraysCnt][1];
	print "			esac" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "		*)" > WrapperShellArrays[ArraysCnt][1];
	print "			FileSizeJudge=0" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "	esac" > WrapperShellArrays[ArraysCnt][1];
	print "	" > WrapperShellArrays[ArraysCnt][1];
	# ファイルサイズチェックで何らかの異常が発生した場合、99で落とす
	print "	$TEST$FileSizeJudge -ne 0 && RetCode_03=99" > WrapperShellArrays[ArraysCnt][1];
	print "	$TEST$RetCode_02 -eq 2 && $ECHO\"$RetCode_03 $PageNumber $KeyWord_Pre\" | gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeSuccess" > WrapperShellArrays[ArraysCnt][1];
	print "	$TEST$RetCode_03 -ne 0 && exit 99" > WrapperShellArrays[ArraysCnt][1];
	print "	" > WrapperShellArrays[ArraysCnt][1];
	print "	NextNumber=`sh ./ShellScripts/SearchNextPage.sh \""Col_05"$PageNumber.html\"`" > WrapperShellArrays[ArraysCnt][1];
	print "	$ECHO\"$NextNumber $PageNumber $KeyWord_Pre\" | gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeFinale" > WrapperShellArrays[ArraysCnt][1];
	print "	RetCode_04=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	case \"$RetCode_04\" in" > WrapperShellArrays[ArraysCnt][1];
	print "		\"1\")" > WrapperShellArrays[ArraysCnt][1];
	print "			$ECHO\"$CSVLine_from01_to08,$PageNumber\" >> "ResultCSV > WrapperShellArrays[ArraysCnt][1];
	print "			exit $SkipBit" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "		*)" > WrapperShellArrays[ArraysCnt][1];
	print "			PageNumber=$NextNumber" > WrapperShellArrays[ArraysCnt][1];
	print "			;;" > WrapperShellArrays[ArraysCnt][1];
	print "	esac" > WrapperShellArrays[ArraysCnt][1];
	print "	" > WrapperShellArrays[ArraysCnt][1];
	print "done" > WrapperShellArrays[ArraysCnt][1];
	print "" > WrapperShellArrays[ArraysCnt][1];
	# ↑↑ここまで無限ループ↑↑
}

# ------------------------------------------------------------------

function PreGene(){
	switch(Mode){
		case "Sentinel_01":
			ResultCSV = MainDir"/Sentinel_01_CSV.csv";
			KeyWord = $0;
			# 半角スペースはURLで「+」に変換されるので、+にしておく
			gsub(" ","+",KeyWord);
			# ループで使いまわすための固定値
			Init = 1;
			LastPage = 1;
			break;
		case "Sentinel_02_EXTEND":
			# 出力不要のため
			ResultCSV = "/dev/null";
			# ループで使いまわすための固定値
			Init = $1;
			if(Init < 1){
				ErrorBit++;
				exit 99;
			}
			LastPage = Init;
			KeyWord = $2;
			if(KeyWord == ""){
				ErrorBit++;
				exit 99;
			}
			break;
		case "Sentinel_03":
			ResultCSV = MainDir"/Result_Sentinel_06_CSV.csv";
			Init = 1;
			# 最終ページ番号
			LastPage = $9 + 0;
			if(LastPage < 2){
				# Sentinel_03におけるシーケンシャル番号を末尾に付与
				OutArrays[OutArraysCnt] = $0","OutArraysCnt",1";
				OutArraysCnt++;
				next;
			}
			KeyWord= $3;
			break;
	}
	File_or_Dir_Use_KeyWord = Inspector_ForD(KeyWord);
	SubDir = MainDir"/"File_or_Dir_Use_KeyWord;
	DuplicationBit = 0;
	if(ArraysCnt == 1){
		SubDirArrays[ArraysCnt] = SubDir;
	} else {
		# ディレクトリ名が重複していないかを検査
		# 重複していた場合、擬似乱数から生成したハッシュ値でソルトを付与する
		for(i in SubDirArrays){
			if(SubDir == SubDirArrays[i]){
				DuplicationBit++;
				break;
			}
		}
		if(DuplicationBit == 0){
			SubDirArrays[ArraysCnt] = SubDir;
		} else {
			cmd = "sh ./ShellScripts/Pseudorandom.sh";
			while(cmd | getline Salt){
				break;
			}
			close(cmd);
			SubDir = SubDir"_"Salt;
			SubDirArrays[ArraysCnt] = SubDir;
		}
	}
	if(Mode == "Sentinel_02_EXTEND"){
		SubMode = "Sentinel_02";
	} else {
		SubMode = Mode;
	}
	for (k = Init; k <= LastPage; k++){
		if(DuplicationBit == 0){
			# Selenium操作Python
			Sentinel = MainDir"/"SubMode"/"SubMode"_"File_or_Dir_Use_KeyWord"_"k".py";
			# モニタリング用ビットパネル
			BitPanel = MainDir"/"SubMode"/"SubMode"_BitPanel_"File_or_Dir_Use_KeyWord"_"k".txt";
			OutHTML = SubDir"/"File_or_Dir_Use_KeyWord"_page_"k".html";
			OutHTML_HASH = SubDir"/HashList_"File_or_Dir_Use_KeyWord"_page_"k".txt";
			OutScreenShot = SubDir"/OutScreenShots_"File_or_Dir_Use_KeyWord"_page_"k".png";
			OutScreenShot_HASH = SubDir"/HashList_OutScreenShots_"File_or_Dir_Use_KeyWord"_page_"k".txt";
		} else {
			# Selenium操作Python
			Sentinel = MainDir"/"SubMode"/"SubMode"_"File_or_Dir_Use_KeyWord"_"Salt"_"k".py";
			# モニタリング用ビットパネル
			BitPanel = MainDir"/"SubMode"/"SubMode"_BitPanel_"File_or_Dir_Use_KeyWord"_"Salt"_"k".txt";
			OutHTML = SubDir"/"File_or_Dir_Use_KeyWord"_page_"Salt"_"k".html";
			OutHTML_HASH = SubDir"/HashList_"File_or_Dir_Use_KeyWord"_page_"Salt"_"k".txt";
			OutScreenShot = SubDir"/OutScreenShots_"File_or_Dir_Use_KeyWord"_page_"Salt"_"k".png";
			OutScreenShot_HASH = SubDir"/HashList_OutScreenShots_"File_or_Dir_Use_KeyWord"_page_"Salt"_"k".txt";
		}
		Python_CMD = "python ./"Sentinel" > "BitPanel;
		if(Mode == "Sentinel_01"){
			MD(SubDir);
		}
		# SubShellArrays[ArraysCnt][1] : python実行コマンド
		# SubShellArrays[ArraysCnt][2] : pythonスクリプト名
		# SubShellArrays[ArraysCnt][3] : ビットパネル名
		# SubShellArrays[ArraysCnt][4] : 検索キーワード（半角スペース変換前）
		# SubShellArrays[ArraysCnt][5] : 検索キーワード（半角スペース変換後）
		# SubShellArrays[ArraysCnt][6] : HTML、スクリーンショット出力先ディレクトリ
		# SubShellArrays[ArraysCnt][7] : 出力対象HTML
		# SubShellArrays[ArraysCnt][8] : 出力対象HTMLの、SHA-512によるハッシュファイル
		# SubShellArrays[ArraysCnt][9] : 出力対象スクリーンショットファイル
		# SubShellArrays[ArraysCnt][10] : 出力対象スクリーンショットファイルの、SHA-512によるハッシュファイル
		SubShellArrays[ArraysCnt][1] = Python_CMD;
		SubShellArrays[ArraysCnt][2] = Sentinel;
		SubShellArrays[ArraysCnt][3] = BitPanel;
		if(Mode == "Sentinel_01"){
			SubShellArrays[ArraysCnt][4] = $0;
		} else {
			SubShellArrays[ArraysCnt][4] = "";
		}
		SubShellArrays[ArraysCnt][5] = KeyWord;
		SubShellArrays[ArraysCnt][6] = SubDir;
		SubShellArrays[ArraysCnt][7] = OutHTML;
		SubShellArrays[ArraysCnt][8] = OutHTML_HASH;
		SubShellArrays[ArraysCnt][9] = OutScreenShot;
		SubShellArrays[ArraysCnt][10] = OutScreenShot_HASH;
		switch(Mode){
			case "Sentinel_02_EXTEND":
				HashCheck(SubShellArrays[ArraysCnt][8], SubShellArrays[ArraysCnt][10], SubShellArrays[ArraysCnt][7], SubShellArrays[ArraysCnt][9]);
				# HashCheckを抜けた場合に、空のビットパネルを生成する
				cmd = ": > "SubShellArrays[ArraysCnt][3];
				system(cmd);
				close(cmd);
				break;
			case "Sentinel_03":
				# InputのCSV構成は、
				# $1 : シーケンシャル番号
				# $2 : 検索キーワード（半角スペース変換前）
				# $3 : 検索キーワード（半角スペース変換後）
				# $4 : 検索結果の1ページ目を取得した際のPythonスクリプトファイルの相対パス名
				# $5 : 検索結果の1ページ目のHTMLファイルの相対パス名
				# $6 : 検索結果の1ページ目のスクリーンショットファイルの相対パス名
				# $7 : 検索結果が不存在(0)/検索結果が存在(1)
				# $8 : 検索結果が1ページのみ(1) / 検索結果が2ページ以上存在(0) / $7が0(NOT FOUND)
				# $9 : 終端ページ数 / $8が1 or NOT FOUNDの場合は1
				OutCSV_Line_01_04 = $1","$2","SubShellArrays[ArraysCnt][5]","SubShellArrays[ArraysCnt][2];
				OutCSV_Line_05_08 = SubShellArrays[ArraysCnt][7]","SubShellArrays[ArraysCnt][9]","$7","$8;
				# $10 : Sentinel_03におけるシーケンシャル番号
				# $11 : キーワードにおけるページ数
				OutCSV_Line_09_11 = $9","OutArraysCnt","k;
				OutCSV_Line = OutCSV_Line_01_04","OutCSV_Line_05_08","OutCSV_Line_09_11;
				OutArrays[OutArraysCnt] = OutCSV_Line;
				OutArraysCnt++;
				break;
			default:
				break;
		}
		Gene_Sentinel();
		ArraysCnt++;
	}
}

# ------------------------------------------------------------------

function Inspector_ForD(Inspector_ForD_KeyWord){
	if(Inspector_ForD_KeyWord == ""){
		ErrorBit++;
		exit 99;
	}
	# ファイル名なので、使うべきでない文字はすべて「_」で置き換える
	gsub("\041","_",Inspector_ForD_KeyWord);
	gsub("\042","_",Inspector_ForD_KeyWord);
	gsub("\043","_",Inspector_ForD_KeyWord);
	# $については、終端に認識されるので、一つ戻す
	gsub("\044","_",Inspector_ForD_KeyWord);
	Inspector_ForD_KeyWord = substr(Inspector_ForD_KeyWord,1,length(Inspector_ForD_KeyWord) - 1);
	gsub("\045","_",Inspector_ForD_KeyWord);
	gsub("\046","_",Inspector_ForD_KeyWord);
	gsub("\047","_",Inspector_ForD_KeyWord);
	gsub("\\\050","_",Inspector_ForD_KeyWord);
	gsub("\051","_",Inspector_ForD_KeyWord);
	# 「*」も、前の継続文字列と認識されるので、エスケープする
	gsub("\\\\052","_",Inspector_ForD_KeyWord);
	# 「+」についても変換する
	gsub("\053","_",Inspector_ForD_KeyWord);
	gsub("\054","_",Inspector_ForD_KeyWord);
	gsub("\055","_",Inspector_ForD_KeyWord);
	# ^については、先頭に認識されるので、2文字目以降を取得する
	gsub("\\\\056","_",Inspector_ForD_KeyWord);
	gsub("\057","_",Inspector_ForD_KeyWord);
	gsub("\072","_",Inspector_ForD_KeyWord);
	gsub("\073","_",Inspector_ForD_KeyWord);
	gsub("\074","_",Inspector_ForD_KeyWord);
	gsub("\075","_",Inspector_ForD_KeyWord);
	gsub("\076","_",Inspector_ForD_KeyWord);
	gsub("\077","_",Inspector_ForD_KeyWord);
	gsub("\100","_",Inspector_ForD_KeyWord);
	gsub("\\\133","_",Inspector_ForD_KeyWord);
	gsub("\\\134","_",Inspector_ForD_KeyWord);
	gsub("\135","_",Inspector_ForD_KeyWord);
	# ^については、先頭に認識されるので、2文字目以降を取得する
	gsub("\136","_",Inspector_ForD_KeyWord);
	Inspector_ForD_KeyWord = substr(Inspector_ForD_KeyWord,2);
	gsub("\140","_",Inspector_ForD_KeyWord);
	gsub("\123","_",Inspector_ForD_KeyWord);
	gsub("\124","_",Inspector_ForD_KeyWord);
	gsub("\125","_",Inspector_ForD_KeyWord);
	gsub("\126","_",Inspector_ForD_KeyWord);
	gsub("\127","_",Inspector_ForD_KeyWord);
	return Inspector_ForD_KeyWord;
}
