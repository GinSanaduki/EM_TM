#!/usr/bin/gawk -f
# GeneSentinel_Sub01.awk

# ------------------------------------------------------------------

function GENE_IMPORT(){
	print "from selenium import webdriver" > Sentinel;
	print "from selenium.webdriver.chrome.options import Options" > Sentinel;
	print "import sys" > Sentinel;
	print "import os" > Sentinel;
	print "import io" > Sentinel;
	print "import random" > Sentinel;
	print "import time" > Sentinel;
	print "import selenium.webdriver.chrome.service as service" > Sentinel;
	print "from selenium.webdriver.support.ui import WebDriverWait" > Sentinel;
	print "from selenium.webdriver.support import expected_conditions as EC" > Sentinel;
	print "from selenium.common.exceptions import TimeoutException" > Sentinel;
	print "import subprocess" > Sentinel;
	print "" > Sentinel;
}

# ------------------------------------------------------------------

function GENE_CHROME_OPTION(){
	print "options = Options()" > Sentinel;
	print "options.add_argument(\047--headless\047)" > Sentinel;
	print "options.add_argument(\047--no-sandbox\047)" > Sentinel;
	# http://www.stockdog.work/entry/2017/08/22/231718
	# エラーの対処法 chrome not reachable - ストックドッグ
	print "options.add_argument(\047--disable-setuid-sandbox\047)" > Sentinel;
	print "options.add_argument(\047--disable-gpu\047)" > Sentinel;
	# https://qiita.com/yoshi10321/items/8b7e6ed2c2c15c3344c6
	# Chromeの--disable-dev-shm-usageオプションについて - Qiita
	# Chrome 65から起動時に--disable-dev-shm-usageを指定することで、シェアドメモリファイルの保持場所を/dev/shmの代わりに/tmpディレクトリを使うようになる
	print "options.add_argument(\047--disable-dev-shm-usage\047)" > Sentinel;
	print "options.add_argument(\047--window-size=1280,1024\047)" > Sentinel;
	print "" > Sentinel;
}

# ------------------------------------------------------------------

function GENE_DEL_LOCK(SWITCHBACK, TABS, TAB_STR, TAB_STR_DEF){
	SWITCHBACK = SWITCHBACK + 0;
	TAB_STR = "";
	TAB_STR_DEF = "";
	TABS = TABS + 0;
	if(TABS == 0){
		TABS = 1;
	}
	for (z = 1; z <= TABS; z++){
		TAB_STR = TAB_STR"	";
	}
	TAB_STR_DEF = TAB_STR"	";
	RUN_ARGS_02 = "stdout = subprocess.DEVNULL";
	RUN_ARGS_03 = "stderr = subprocess.DEVNULL";
	switch(SWITCHBACK){
		case "1":
			RUN_ARGS_01 = "[\047rm\047, \047-f\047, \047LOCKFILE_00.lock\047]";
			print TAB_STR"subprocess.run("RUN_ARGS_01", "RUN_ARGS_02", "RUN_ARGS_03")" > Sentinel;
			break;
		default:
			RUN_ARGS_01_01 = "[\047rm\047, \047-f\047, \047LOCKFILE_01.lock\047]";
			RUN_ARGS_01_02 = "[\047rm\047, \047-f\047, \047LOCKFILE_02.lock\047]";
			RUN_ARGS_01_03 = "[\047rm\047, \047-f\047, \047LOCKFILE_03.lock\047]";
			print TAB_STR"if LOCK_RCode_Res == 1:" > Sentinel;
			print TAB_STR_DEF"subprocess.run("RUN_ARGS_01_01", "RUN_ARGS_02", "RUN_ARGS_03")" > Sentinel;
			print TAB_STR"elif LOCK_RCode_Res == 2:" > Sentinel;
			print TAB_STR_DEF"subprocess.run("RUN_ARGS_01_02", "RUN_ARGS_02", "RUN_ARGS_03")" > Sentinel;
			print TAB_STR"else:" > Sentinel;
			print TAB_STR_DEF"subprocess.run("RUN_ARGS_01_03", "RUN_ARGS_02", "RUN_ARGS_03")" > Sentinel;
			break;
	}
}

# ------------------------------------------------------------------

function GENE_MOVERISE_DRIVER(){
	print "try:" > Sentinel;
	print "	driver = webdriver.Chrome(options=options)" > Sentinel;
	print "	driver = webdriver.Chrome(\047"Driver"\047, options=options)" > Sentinel;
	print "except OSError as e:" > Sentinel;
	OUT_EXCEPTION(OSErrorMessage_02, "1");
	print "except Exception as e:" > Sentinel;
	OUT_EXCEPTION(OtherError, "1");
	print "" > Sentinel;
}

# ------------------------------------------------------------------

function GENE_EXCLUSION_CONTROL(SWITCHBACK, TABS, TAB_STR, TAB_STR_DEF){
	SWITCHBACK = SWITCHBACK + 0;
	TAB_STR = "";
	TAB_STR_DEF = "";
	TABS = TABS + 0;
	if(TABS == 0){
		TABS = 1;
	}
	for (z = 1; z <= TABS; z++){
		TAB_STR = TAB_STR"	";
	}
	TAB_STR_DEF = TAB_STR"	";
	RUN_ARGS_02 = "stdout = subprocess.DEVNULL";
	RUN_ARGS_03 = "stderr = subprocess.DEVNULL";
	switch(SWITCHBACK){
		case "1":
			RUN_ARGS_01 = "[\047./ShellScripts/GeneLocker_01.sh\047]";
			break;
		default:
			RUN_ARGS_01 = "[\047./ShellScripts/GeneLocker_02.sh\047]";
			break;
	}
	print TAB_STR"LOCK_RCode = subprocess.run("RUN_ARGS_01", "RUN_ARGS_02", "RUN_ARGS_03")" > Sentinel;
	print TAB_STR"LOCK_RCode_Res = LOCK_RCode.returncode" > Sentinel;
	switch(SWITCHBACK){
		case "1":
			print TAB_STR"if LOCK_RCode_Res == 0:" > Sentinel;
			break;
		default:
			print TAB_STR"if LOCK_RCode_Res == 1 or LOCK_RCode_Res == 2 or LOCK_RCode_Res == 3:" > Sentinel;
			break;
	}
	print TAB_STR_DEF"break" > Sentinel;
	print TAB_STR"time.sleep(random.randint(3,8))" > Sentinel;
	print "" > Sentinel;
}

# ------------------------------------------------------------------

# OUT_MESSAGES : 要メッセージ
# SWITCHBACK：要スイッチ
# TABS：デフォルトは1
# TAB_STR：TABS分タブ文字を生成
# TAB_STR_DEF：TABS + 1分タブ文字を生成
# BUILD_MESSAGES：内部変数用

function OUT_EXCEPTION(OUT_MESSAGES, SWITCHBACK, TABS, TAB_STR, TAB_STR_DEF, BUILD_MESSAGES){
	if(OUT_MESSAGES == ""){
		ErrorBit++;
		exit 99;
	}
	SWITCHBACK = SWITCHBACK + 0;
	TAB_STR = "";
	TAB_STR_DEF = "";
	TABS = TABS + 0;
	if(TABS == 0){
		TABS = 1;
	}
	for (z = 1; z <= TABS; z++){
		TAB_STR = TAB_STR"	";
	}
	TAB_STR_DEF = TAB_STR"	";
	switch(SWITCHBACK){
		case "1":
			BUILD_MESSAGES = OUT_MESSAGES" : 実行スクリプト名　：　"Sentinel"、検索ワード名　：　"KeyWord;
			print TAB_STR"print(\"99\", end=\"\")" > Sentinel;
			print TAB_STR"print(\047"BUILD_MESSAGES"\047, file=sys.stderr)" > Sentinel;
			# スタックトレース発行
			print TAB_STR"print(str(e), file=sys.stderr)" > Sentinel;
			print TAB_STR"driver.quit()" > Sentinel;
			# ロックファイルの削除
			GENE_DEL_LOCK("1");
			print TAB_STR"sys.exit(1)" > Sentinel;
			break;
		case "2":
			BUILD_MESSAGES = OUT_MESSAGES" : 実行スクリプト名　：　"Sentinel"、検索ワード名　：　"KeyWord"、HTMLファイル名　：　"OutHTML;
			print TAB_STR"print(\"99\", end=\"\")" > Sentinel;
			print TAB_STR"print(\047"BUILD_MESSAGES"\047, file=sys.stderr)" > Sentinel;
			print TAB_STR"print(str(e), file=sys.stderr)" > Sentinel;
			print TAB_STR"driver.quit()" > Sentinel;
			# ロックファイルの削除
			GENE_DEL_LOCK();
			print TAB_STR"sys.exit(2)" > Sentinel;
			break;
		case "3":
			BUILD_MESSAGES = OUT_MESSAGES" : 実行スクリプト名　：　"Sentinel"、検索ワード名　：　"KeyWord;
			print TAB_STR"print(\"9\", end=\"\")" > Sentinel;
			print TAB_STR"print(\047"BUILD_MESSAGES"\047, file=sys.stderr)" > Sentinel;
			print TAB_STR"print(str(e), file=sys.stderr)" > Sentinel;
			print TAB_STR"driver.quit()" > Sentinel;
			# ロックファイルの削除
			GENE_DEL_LOCK();
			print TAB_STR"sys.exit(3)" > Sentinel;
			break;
		case "4":
			BUILD_MESSAGES = OUT_MESSAGES" : 実行スクリプト名　：　"Sentinel"、検索ワード名　：　"KeyWord"、PNGファイル名　：　"OutScreenShot;
			print TAB_STR"print(\"9\", end=\"\")" > Sentinel;
			print TAB_STR"print(\047"BUILD_MESSAGES"\047, file=sys.stderr)" > Sentinel;
			print TAB_STR"print(str(e), file=sys.stderr)" > Sentinel;
			print TAB_STR"driver.quit()" > Sentinel;
			# ロックファイルの削除
			GENE_DEL_LOCK();
			print TAB_STR"sys.exit(4)" > Sentinel;
			break;
		default:
			ErrorBit++;
			exit 99;
	}
}

