#!/usr/bin/gawk -f
# GeneSentinel_Sub02.awk

# ------------------------------------------------------------------

function PreWrapper(){
	switch(Mode){
		case "Sentinel_02":
			break;
		default:
			exit 99;
	}
	MaxPage = $8 + 0;
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
	WrapperShell = SubDir"/WrapperShell_"$2".sh";
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
			exit 99;
	}
	print "#!/bin/sh" > WrapperShellArrays[ArraysCnt][1];
	print "# sh "WrapperShellArrays[ArraysCnt][1] > WrapperShellArrays[ArraysCnt][1];
	print "# bashdb "WrapperShellArrays[ArraysCnt][1] > WrapperShellArrays[ArraysCnt][1];
	print "" > WrapperShellArrays[ArraysCnt][1];
	# gawkに引き渡す変数の初期化
	print "PageNumber="MaxPage > WrapperShellArrays[ArraysCnt][1];
	print "KeyWord=\""$2"\"" > WrapperShellArrays[ArraysCnt][1];
	print "KeyWord_Pre=\""$1"\"" > WrapperShellArrays[ArraysCnt][1];
	# SkipBit
	print "SkipBit=255" > WrapperShellArrays[ArraysCnt][1];
	Col_04 = $4;
	gsub(/_page_.*?.html/,"_page_",Col_04);
	CSVLine_from01_to07 = $1","$2","$3","$4","$5","$6","$7;
	# ↓↓ここから無限ループ↓↓
	# 「icon-arrow-double-right」クラスのハイパーリンクが存在しなくなるまで、ページを辿っていく
	Sentinel = MainDir"/"Mode"/"Mode"_"$2"_$PageNumber.py";
	BitPanel = MainDir"/"Mode"/"Mode"_BitPanel_"$2"_$PageNumber.txt";
	ResultCSV = MainDir"/Sentinel_05_CSV.csv";
	print "CSVLine_from01_to07=\""CSVLine_from01_to07"\"" > WrapperShellArrays[ArraysCnt][1];
	print "while :" > WrapperShellArrays[ArraysCnt][1];
	print "do" > WrapperShellArrays[ArraysCnt][1];
	# ループ内部でAWKからPythonを自動生成する
	print "	Sentinel=\""Sentinel"\"" > WrapperShellArrays[ArraysCnt][1];
	print "	BitPanel=\""BitPanel"\"" > WrapperShellArrays[ArraysCnt][1];
	print "	: > $Sentinel" > WrapperShellArrays[ArraysCnt][1];
	print "	rm -f $BitPanel > /dev/null 2>&1" > WrapperShellArrays[ArraysCnt][1];
	print "	echo \"$PageNumber $KeyWord $Sentinel $BitPanel\" | gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_02_EXTEND -v GeneMercariMode="GeneMercariMode > WrapperShellArrays[ArraysCnt][1];
	print "	RetCode=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	test $RetCode -ne 0 && test $RetCode -ne 255 && echo \"Pythonスクリプト生成段階で異常が発生しました。\"" > WrapperShellArrays[ArraysCnt][1];
	print "	test $RetCode -ne 0 && test $RetCode -ne 255 && exit 99" > WrapperShellArrays[ArraysCnt][1];
	print "	" > WrapperShellArrays[ArraysCnt][1];
	# SkipBitが255かつRetCodeが0の場合、SkipBitを0にする
	print "	test $SkipBit -eq 255 && test $RetCode -eq 0 && SkipBit=0" > WrapperShellArrays[ArraysCnt][1];
	print "	echo \"$RetCode $PageNumber $KeyWord_Pre\" | gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeSkipped" > WrapperShellArrays[ArraysCnt][1];
	print "	RetCode_02=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	test $RetCode_02 -ne 1 && test $RetCode_02 -ne 2 && exit 99" > WrapperShellArrays[ArraysCnt][1];
	print "	test $RetCode_02 -eq 2 && python $Sentinel > $BitPanel" > WrapperShellArrays[ArraysCnt][1];
	print "	RetCode_03=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	test $RetCode_02 -eq 1 && RetCode_03=0" > WrapperShellArrays[ArraysCnt][1];
	# ビットパネルが存在し、RetCode_03が0の場合に、出力対象ファイルのサイズチェックを行う
	# 255の場合、ビットパネルは未出力であり、存在しない
	print "	ls \"$BitPanel\" > /dev/null 2>&1" > WrapperShellArrays[ArraysCnt][1];
	print "	BitPanel_IsExist=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	test $BitPanel_IsExist -eq 0 && test $RetCode_03 -eq 0 && echo \"$Sentinel\" | awk -f AWKScripts/FileSizeJudge.awk -v GeneMercariMode="GeneMercariMode > WrapperShellArrays[ArraysCnt][1];
	print "	FileSizeJudge=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	test $BitPanel_IsExist -ne 0 && FileSizeJudge=0" > WrapperShellArrays[ArraysCnt][1];
	# ファイルサイズチェックで何らかの異常が発生した場合、99で落とす
	print "	test $FileSizeJudge -ne 0 && RetCode_03=99" > WrapperShellArrays[ArraysCnt][1];
	print "	test $RetCode_02 -eq 2 && echo \"$RetCode_03 $PageNumber $KeyWord_Pre\" | gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeSuccess" > WrapperShellArrays[ArraysCnt][1];
	print "	test $RetCode_03 -ne 0 && exit 99" > WrapperShellArrays[ArraysCnt][1];
	print "	" > WrapperShellArrays[ArraysCnt][1];
	print "	NextNumber=`sh ./ShellScripts/SearchNextPage.sh \""Col_04"$PageNumber.html\"`" > WrapperShellArrays[ArraysCnt][1];
	print "	echo \"$NextNumber $PageNumber $KeyWord_Pre\" | gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeFinale" > WrapperShellArrays[ArraysCnt][1];
	print "	RetCode_04=$?" > WrapperShellArrays[ArraysCnt][1];
	print "	test $RetCode_04 -eq 1 && echo \"$CSVLine_from01_to07,$PageNumber\" >> "ResultCSV > WrapperShellArrays[ArraysCnt][1];
	print "	test $RetCode_04 -eq 1 && exit $SkipBit" > WrapperShellArrays[ArraysCnt][1];
	print "	PageNumber=$NextNumber" > WrapperShellArrays[ArraysCnt][1];
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
				exit 99;
			}
			LastPage = Init;
			KeyWord = $2;
			if(KeyWord == ""){
				exit 99;
			}
			break;
		case "Sentinel_03":
			# 出力不要のため
			ResultCSV = "/dev/null";
			Init = 1;
			# 最終ページ番号
			LastPage = $8 + 0;
			if(LastPage < 2){
				next;
			}
			KeyWord= $2;
			break;
	}
	SubDir = MainDir"/"KeyWord;
	if(Mode == "Sentinel_02_EXTEND"){
		SubMode = "Sentinel_02";
	} else {
		SubMode = Mode;
	}
	for (k = Init; k <= LastPage; k++){
		# Selenium操作Python
		Sentinel = MainDir"/"SubMode"/"SubMode"_"KeyWord"_"k".py";
		# モニタリング用ビットパネル
		BitPanel = MainDir"/"SubMode"/"SubMode"_BitPanel_"KeyWord"_"k".txt";
		Python_CMD = "python ./"Sentinel" > "BitPanel;
		if(Mode == "Sentinel_01"){
			MD(SubDir);
		}
		OutHTML = SubDir"/"KeyWord"_page_"k".html";
		OutHTML_HASH = SubDir"/HashList_"KeyWord"_page_"k".txt";
		OutScreenShot = SubDir"/OutScreenShots_"KeyWord"_page_"k".png";
		OutScreenShot_HASH = SubDir"/HashList_OutScreenShots_"KeyWord"_page_"k".txt";
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
			default:
				break;
		}
		Gene_Sentinel();
		ArraysCnt++;
	}
}

# ------------------------------------------------------------------

