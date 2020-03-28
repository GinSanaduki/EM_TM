#!/usr/bin/gawk -f
# GeneSentinel_Sub00.awk

# ------------------------------------------------------------------

function Gene_Sentinel(){
	print "#!/usr/bin/env python" > Sentinel;
	print "# -*- coding: utf-8 -*-" > Sentinel;
	print "# python ./"Sentinel > Sentinel;
	print "# python -m pdb  ./"Sentinel > Sentinel;
	print "" > Sentinel;
	# Import
	GENE_IMPORT();
	# ハッシュ値を検証し、同一ならばスキップ
	SHACMD_01 = "sha512sum -c --quiet "SubShellArrays[ArraysCnt][8]" > /dev/null 2>&1";
	SHACMD_02 = "sha512sum -c --quiet "SubShellArrays[ArraysCnt][10] " > /dev/null 2>&1";
	print "Hash_Judge = 0" > Sentinel;
	print "Hash_RCode_01 = subprocess.run(\""SHACMD_01"\", shell = True)" > Sentinel;
	switch(GeneMercariMode){
		case "NORMAL":
			print "Hash_RCode_02 = subprocess.run(\""SHACMD_02"\", shell = True)" > Sentinel;
			break;
		case "HTML":
			break;
	}
	print "Hash_RCode_01_Res = Hash_RCode_01.returncode" > Sentinel;
	switch(GeneMercariMode){
		case "NORMAL":
			print "Hash_RCode_02_Res = Hash_RCode_02.returncode" > Sentinel;
			print "if Hash_RCode_01_Res == 0 and Hash_RCode_02_Res == 0:" > Sentinel;
			break;
		case "HTML":
			print "if Hash_RCode_01_Res == 0:" > Sentinel;
			break;
	}
	print "	Hash_Judge = 1" > Sentinel;
	print "if Hash_Judge == 0:" > Sentinel;
	RMCMD_01 = "rm -f \\\""SubShellArrays[ArraysCnt][7]"\\\" > /dev/null 2>&1";
	RMCMD_02 = "rm -f \\\""SubShellArrays[ArraysCnt][8]"\\\" > /dev/null 2>&1";
	RMCMD_03 = "rm -f \\\""SubShellArrays[ArraysCnt][9]"\\\" > /dev/null 2>&1";
	RMCMD_04 = "rm -f \\\""SubShellArrays[ArraysCnt][10]"\\\" > /dev/null 2>&1";
	print "	subprocess.run(\""RMCMD_01"\", shell = True)" > Sentinel;
	print "	subprocess.run(\""RMCMD_02"\", shell = True)" > Sentinel;
	switch(GeneMercariMode){
		case "NORMAL":
			print "	subprocess.run(\""RMCMD_03"\", shell = True)" > Sentinel;
			print "	subprocess.run(\""RMCMD_04"\", shell = True)" > Sentinel;
			break;
	}
	print "if Hash_Judge == 1:" > Sentinel;
	FileSizeCMD = "echo \\\""SubShellArrays[ArraysCnt][1]"\\\" | awk -f AWKScripts/FileSizeJudge.awk  -v GeneMercariMode="GeneMercariMode;
	print "	FileSize_RCode = subprocess.run(\""FileSizeCMD"\", shell = True)" > Sentinel;
	print "	FileSize_RCode_Res = FileSize_RCode.returncode" > Sentinel;
	print "	if FileSize_RCode_Res == 0:" > Sentinel;
	print "		print(\"00\", end=\"\")" > Sentinel;

	ALERTCMD_Main = "gawk -f AWKScripts/AlertMessages.awk";
	ALERTCMD_Option01 = " -v MESSAGE=SKIPPED";
	ALERTCMD_Option02 = " -v PAGENUMBER="k;
	ALERTCMD_Option03 = " -v SEARCHWORD="SubShellArrays[ArraysCnt][5];
	ALERTCMD_Option04 = " -v OUTFILENAME_01="SubShellArrays[ArraysCnt][7];
	ALERTCMD_Option05 = " -v HASHLIST_01="SubShellArrays[ArraysCnt][8];
	ALERTCMD_Option06 = " -v GENE_MERCARIMODE="GeneMercariMode;
	switch(GeneMercariMode){
		case "NORMAL":
			ALERTCMD_Option07 = " -v OUTFILENAME_02="SubShellArrays[ArraysCnt][9];
			ALERTCMD_Option08 = " -v HASHLIST_02="SubShellArrays[ArraysCnt][10];
			break;
		case "HTML":
			ALERTCMD_Option07 = "";
			ALERTCMD_Option08 = "";
			break;
	}
	ALERTCMD = ALERTCMD_Main ALERTCMD_Option01 ALERTCMD_Option02 ALERTCMD_Option03 ALERTCMD_Option04 ALERTCMD_Option05 ALERTCMD_Option06 ALERTCMD_Option07 ALERTCMD_Option08;
	print "		subprocess.run(\""ALERTCMD"\", shell = True)" > Sentinel;
	print "		sys.exit(255)" > Sentinel;
	print "	" > Sentinel;
	print "" > Sentinel;
	# 起動オプション
	GENE_CHROME_OPTION();
	# ドライバを起動
	GENE_MOVERISE_DRIVER();
	# メルカリに接続
	# 接続時点は1件ずつの排他制御をかける
	print "while True:" > Sentinel;
	GENE_EXCLUSION_CONTROL("1");
	
	print "try:" > Sentinel;
	print "	driver.get(\047https://www.mercari.com/jp/search/?page="k"&keyword="SubShellArrays[ArraysCnt][5]"\047)" > Sentinel;
	# 要素取得に30秒まで待つ
	print "	WebDriverWait(driver, 30).until(EC.presence_of_all_elements_located)" > Sentinel;
	print "except TimeoutException as e:" > Sentinel;
	OUT_EXCEPTION(TimeOutMessage,"1");
	print "except Exception as e:" > Sentinel;
	OUT_EXCEPTION(OtherError,"1");
	print "finally:" > Sentinel;
	# 接続インターバル
	print "	time.sleep(5)" > Sentinel;
	# ロックファイルの削除
	GENE_DEL_LOCK("1");
	print "" > Sentinel;
	
	# HTMLを出力
	Sentinel_Arrays_HTML[ArraysCnt] = SubShellArrays[ArraysCnt][7];
	# 3件まで排他制御をかける
	print "while True:" > Sentinel;
	GENE_EXCLUSION_CONTROL();
	print "try:" > Sentinel;
	print "	file = open(\047"SubShellArrays[ArraysCnt][7]"\047,\047w\047,encoding=\047utf-8\047)" > Sentinel;
	print "	file.write(str(driver.page_source))" > Sentinel;
	print "except FileNotFoundError as e:" > Sentinel;
	OUT_EXCEPTION(FileIOErrorMessage, "2");
	print "except PermissionError as e:" > Sentinel;
	OUT_EXCEPTION(PermissionErrorMessage, "2");
	print "except OSError as e:" > Sentinel;
	OUT_EXCEPTION(OSErrorMessage, "2");
	print "except Exception as e:" > Sentinel;
	OUT_EXCEPTION(OtherError, "2");
	print "finally:" > Sentinel;
	print "	file.close()" > Sentinel;
	switch(GeneMercariMode){
		case "NORMAL":
			print "	print(\"0\", end=\"\")" > Sentinel;
			break;
		case "HTML":
			print "	print(\"00\", end=\"\")" > Sentinel;
			break;
	}
	# ハッシュ値を取得
	SHACMD = "sha512sum \\\""SubShellArrays[ArraysCnt][7]"\\\" > \\\""SubShellArrays[ArraysCnt][8]"\\\"";
	print "	subprocess.run(\""SHACMD"\", shell = True)" > Sentinel;
	ALERTCMD_Main = "gawk -f AWKScripts/AlertMessages.awk";
	ALERTCMD_Option01 = " -v MESSAGE=COMP_HTML";
	ALERTCMD_Option02 = " -v PAGENUMBER="k;
	ALERTCMD_Option03 = " -v SEARCHWORD="SubShellArrays[ArraysCnt][5];
	ALERTCMD_Option04 = " -v OUTFILENAME="SubShellArrays[ArraysCnt][7];
	ALERTCMD_Option05 = " -v HASHLIST="SubShellArrays[ArraysCnt][8];
	ALERTCMD_Option06 = " -v GENE_MERCARIMODE="GeneMercariMode;
	ALERTCMD_Option = ALERTCMD_Option01 ALERTCMD_Option02 ALERTCMD_Option03 ALERTCMD_Option04 ALERTCMD_Option05 ALERTCMD_Option06;
	ALERTCMD = ALERTCMD_Main ALERTCMD_Option;
	print "	subprocess.run(\""ALERTCMD"\", shell = True)" > Sentinel;
	print "" > Sentinel;
	
	switch(GeneMercariMode){
		case "HTML":
			print "	driver.quit()" > Sentinel;
			# ロックファイルの削除
			GENE_DEL_LOCK();
			print "sys.exit(0)" > Sentinel;
			print "" > Sentinel;
			return;
	}
	# スクリーンショットを取得
	# 商品画像が、スクロールしないといつまで待っても読み込まれない（白い画像として出てくる）ので、
	# 0.3秒置きに、一番下に到達するまでスクロールし続ける。
	# ----------------------------------------------------------------------------------------------------
	# https://qiita.com/mistecon/items/ef5be5079f3735792c7c
	# Selenium・Pythonを用いた動的Webサイトのスクレイピング（初心者用） - Qiita
	# airbnbのリスティングサイトでは、クリックしたいリンク先が画面内に表示されないとクリックできません。
	# そのため、スクロールしてからクリックします。
	# ----------------------------------------------------------------------------------------------------
	print "try:" > Sentinel;
	print "	page_height = driver.execute_script(\047return document.body.scrollHeight\047)" > Sentinel;
	print "except Exception as e:" > Sentinel;
	OUT_EXCEPTION(OtherError, "3");
	print "" > Sentinel;
	print "ScrollCnt = 0" > Sentinel;
	print "LOCK_RCode = 0" > Sentinel;
	print "while True:" > Sentinel;
	print "	ScrollCnt = ScrollCnt + 100" > Sentinel;
	print "	if ScrollCnt > page_height:" > Sentinel;
	print "		ScrollCnt = page_height" > Sentinel;
	print "	ScriptCMD = \"window.scrollBy(0, \" + str(ScrollCnt) + \");\"" > Sentinel;
	print "	try:" > Sentinel;
	print "		driver.execute_script(str(ScriptCMD))" > Sentinel;
	print "	except Exception as e:" > Sentinel;
	OUT_EXCEPTION(OtherError, "3", "2");
	print "	if ScrollCnt >= page_height:" > Sentinel;
	print "		break" > Sentinel;
	print "	time.sleep(0.3)" > Sentinel;
	print "" > Sentinel;
	print "time.sleep(2)" > Sentinel;
	print "" > Sentinel;
	# --------------------------------------------------------------------------------------------------------------------------
	# https://blog.amedama.jp/entry/2018/07/28/003342
	# Python: Selenium + Headless Chrome で Web ページ全体のスクリーンショットを撮る - CUBE SUGAR CONTAINER
	# （・・・）ページ全体の横幅と高さを取得したら、それをウィンドウサイズとしてセットする。
	# これによって Web ページ全体のスクリーンショットを一つの画像として撮影できる。
	# ちなみに Headless モードにしていないと、ここで設定できる値がモニターの解像度に依存してしまう。
	# --------------------------------------------------------------------------------------------------------------------------
	print "try:" > Sentinel;
	print "	page_width = driver.execute_script(\047return document.body.scrollWidth\047)" > Sentinel;
	# 高さは、スクロールの時点で取得済
	print "	driver.set_window_size(page_width, page_height)" > Sentinel;
	print "except Exception as e:" > Sentinel;
	OUT_EXCEPTION(OtherError, "3");
	print "" > Sentinel;
	Sentinel_Arrays_ScreenShot[ArraysCnt] = SubShellArrays[ArraysCnt][9];
	print "try:" > Sentinel;
	print "	driver.save_screenshot(\047"SubShellArrays[ArraysCnt][9]"\047)" > Sentinel;
	print "except FileNotFoundError as e:" > Sentinel;
	OUT_EXCEPTION(FileIOErrorMessage, "4");
	print "except PermissionError as e:" > Sentinel;
	OUT_EXCEPTION(PermissionErrorMessage, "4");
	print "except OSError as e:" > Sentinel;
	OUT_EXCEPTION(OSErrorMessage, "4");
	print "except Exception as e:" > Sentinel;
	OUT_EXCEPTION(OtherError, "4");
	print "finally:" > Sentinel;
	print "	driver.quit()" > Sentinel;
	# ハッシュ値を取得
	SHACMD = "sha512sum \\\""SubShellArrays[ArraysCnt][9]"\\\" > \\\""SubShellArrays[ArraysCnt][10] "\\\"";
	print "	subprocess.run(\""SHACMD"\", shell = True)" > Sentinel;
	ALERTCMD_Main = "gawk -f AWKScripts/AlertMessages.awk";
	ALERTCMD_Option01 = " -v MESSAGE=COMP_PNG";
	ALERTCMD_Option02 = " -v PAGENUMBER="k;
	ALERTCMD_Option03 = " -v SEARCHWORD="SubShellArrays[ArraysCnt][5];
	ALERTCMD_Option04 = " -v OUTFILENAME="SubShellArrays[ArraysCnt][9];
	ALERTCMD_Option05 = " -v HASHLIST="SubShellArrays[ArraysCnt][10];
	ALERTCMD_Option06 = " -v GENE_MERCARIMODE="GeneMercariMode;
	ALERTCMD_Option = ALERTCMD_Option01 ALERTCMD_Option02 ALERTCMD_Option03 ALERTCMD_Option04 ALERTCMD_Option05 ALERTCMD_Option06;
	ALERTCMD = ALERTCMD_Main ALERTCMD_Option;
	print "	subprocess.run(\""ALERTCMD"\", shell = True)" > Sentinel;
	# ロックファイルの削除
	GENE_DEL_LOCK();
	print "	print(\"0\", end=\"\")" > Sentinel;
	print "" > Sentinel;
	print "sys.exit(0)" > Sentinel;
	print "" > Sentinel;
}

# ------------------------------------------------------------------

function MD(MKDIR_DIR, MD_CMD){
	MD_CMD = "mkdir "MKDIR_DIR" > /dev/null 2>&1";
	system(MD_CMD);
	close(MD_CMD);
}

# ------------------------------------------------------------------

function RM(RM_FILE){
	RM_CMD = "rm -f \""MKDIR_DIR"\" > /dev/null 2>&1";
	system(RM_CMD);
	close(RM_CMD);
}

# ------------------------------------------------------------------

function HashCheck(HashCheck_HTML, HashCheck_ScreenShot, HashCheck_HTMLFile, HashCheck_ScreenShotFile){
	if(HashCheck_HTML == "" || HashCheck_ScreenShot == "" || HashCheck_HTMLFile == "" || HashCheck_ScreenShotFile == ""){
		exit 99;
	}
	# 対象のハッシュ値をこの時点で検証し、問題がなければ生成をスキップし、255を返送する
	SHA512_CMD_HTML = "sha512sum -c --quiet "HashCheck_HTML" > /dev/null 2>&1";
	SHA512_CMD_ScreenShot = "sha512sum -c --quiet "HashCheck_ScreenShot" > /dev/null 2>&1";
	RetCode_SHA512_CMD_HTML = 1;
	RetCode_SHA512_CMD_ScreenShot = 1;
	RetCode_SHA512_CMD_HTML = system(SHA512_CMD_HTML);
	close(SHA512_CMD_HTML);
	switch(GeneMercariMode){
		case "NORMAL":
			RetCode_SHA512_CMD_ScreenShot = system(SHA512_CMD_ScreenShot);
			close(SHA512_CMD_ScreenShot);
			break;
		case "HTML":
			RetCode_SHA512_CMD_ScreenShot = 0;
			break;
	}
	if(RetCode_SHA512_CMD_HTML != 0 || RetCode_SHA512_CMD_ScreenShot != 0){
		# ハッシュ表、実ファイルを削除
		RM(HashCheck_HTML);
		RM(HashCheck_ScreenShot);
		RM(HashCheck_HTMLFile);
		RM(HashCheck_ScreenShotFile);
		return;
	}
	LS_HTML_CMD = "ls -l \""HashCheck_HTMLFile"\" | awk \047{print $5; exit;}\047";
	LS_ScreenShot_CMD = "ls -l \""HashCheck_ScreenShotFile"\" | awk \047{print $5; exit;}\047";
	Filesize_HTML = 0;
	Filesize_ScreenShot = 0;
	RegulationSize_HTML = 921600;
	RegulationSize_ScreenShot = 563200;
	while(LS_HTML_CMD | getline Filesize_HTML){
		break;
	}
	close(LS_HTML_CMD);
	switch(GeneMercariMode){
		case "NORMAL":
			while(LS_ScreenShot_CMD | getline Filesize_ScreenShot){
				break;
			}
			close(LS_ScreenShot_CMD);
		case "HTML":
			Filesize_ScreenShot = RegulationSize_ScreenShot;
	}
	
	if(Filesize_HTML < RegulationSize_HTML || Filesize_ScreenShot < RegulationSize_ScreenShot){
		# ハッシュ表、実ファイルを削除
		RM(HashCheck_HTML);
		RM(HashCheck_ScreenShot);
		RM(HashCheck_HTMLFile);
		RM(HashCheck_ScreenShotFile);
		return;
	}
	exit 255;
}

# ------------------------------------------------------------------

function Reload_SubShell(){
	Len_SubShellArrays = length(SubShellArrays);
	for(i in SubShellArrays){
		Remainder = i % 3;
		switch(Remainder){
			case "2":
				SubShellArraysXY[XAxisCnt][1] = SubShellArrays[i][1];
				BitPanelArraysXY[XAxisCnt][1] = "rm -f \""SubShellArrays[i][3]"\" > /dev/null 2>&1";
				break;
			case "1":
				SubShellArraysXY[XAxisCnt][2] = SubShellArrays[i][1];
				BitPanelArraysXY[XAxisCnt][2] = "rm -f \""SubShellArrays[i][3]"\" > /dev/null 2>&1";
				break;
			case "0":
				SubShellArraysXY[XAxisCnt][3] = SubShellArrays[i][1];
				BitPanelArraysXY[XAxisCnt][3] = "rm -f \""SubShellArrays[i][3]"\" > /dev/null 2>&1";
				XAxisCnt++;
				break;
			default:
				exit 99;
		}
	}
}

# ------------------------------------------------------------------

function Reload_WrapperShell(){
	Len_SubShellArrays = length(WrapperShellArrays);
	for(i in WrapperShellArrays){
		Remainder = i % 3;
		switch(Remainder){
			case "2":
				SubShellArraysXY[XAxisCnt][1] = WrapperShellArrays[i][1];
				BitPanelArraysXY[XAxisCnt][1] = ":";
				break;
			case "1":
				SubShellArraysXY[XAxisCnt][2] = WrapperShellArrays[i][1];
				BitPanelArraysXY[XAxisCnt][2] = ":";
				break;
			case "0":
				SubShellArraysXY[XAxisCnt][3] = SubShellArrays[i][1];
				BitPanelArraysXY[XAxisCnt][3] = ":";
				XAxisCnt++;
				break;
			default:
				exit 99;
		}
	}
}

# ------------------------------------------------------------------

