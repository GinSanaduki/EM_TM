#!/usr/bin/gawk -f
# GeneSentinel_01.awk
# gawk -f AWKScripts/GeneSentinel_01.awk -v SYSTIME=$SYSTIME Define_SearchWord.conf

BEGIN{
	SYSTIME = SYSTIME + 0;
	SysTime = systime() - 3600;
	if(SYSTIME < SysTime){
		exit 99;
	}
	ExecTime = strftime("%Y%m%d_%H%M%S", SYSTIME);
	MainDir = "ResultOut/ResultOut_"ExecTime;
	cmd = "which chromedriver";
	while(cmd | getline Driver){
		break;
	}
	close(cmd);
	ResultCSV = MainDir"/Sentinel_01_CSV.csv";
	TimeOutMessage = "接続がタイムアウトしました。";
	HTMLFileIOErrorMessage = "HTMLファイルの書き込みに失敗しました。";
	PermissionErrorMessage = "HTMLファイルの書き込み権限がありません。";
	OSErrorMessage = "HTMLファイルの書き込みに失敗しました。（OSError）";
	OtherError = "予期せぬエラーが発生しました。";
	ArraysCnt = 1;
}

{
	if($0 == ""){
		next;
	}
	OutArraysCnt++;
	PageGeneCnt = 1;
	MaxPage = 1;
	KeyWord = $0;
	# 半角スペースはURLで「+」に変換されるので、+にしておく
	gsub(" ","+",KeyWord);
	Sentinel_01 = MainDir"/Sentinel_01/Sentinel_01_"KeyWord".py";
	Sentinel_01_BitPanel = MainDir"/Sentinel_01/Sentinel_01_BitPanel_"KeyWord".txt";
	Keyword_Arrays[ArraysCnt] = $0;
	Keyword_ConvertedArrays[ArraysCnt] = KeyWord;
	Sentinel_01_Arrays[ArraysCnt] = Sentinel_01;
	Sentinel_01_BitPanelArrays[ArraysCnt] = Sentinel_01_BitPanel;
	SubDir = MainDir"/"KeyWord;
	cmd = "mkdir "SubDir" > /dev/null 2>&1";
	system(cmd);
	close(cmd);
	OutHTML = SubDir"/"KeyWord"_page_"PageGeneCnt".html";
	OutScreenShot = SubDir"/OutScreenShots_"KeyWord"_page_"PageGeneCnt".png";
	Gene_Sentinel_01();
	ArraysCnt++;
}

function Gene_Sentinel_01(){
	print "#!/usr/bin/env python" > Sentinel_01;
	print "# -*- coding: utf-8 -*-" > Sentinel_01;
	print "# python ./"Sentinel_01 > Sentinel_01;
	print "" > Sentinel_01;
	# Import
	print "from selenium import webdriver" > Sentinel_01;
	print "from selenium.webdriver.chrome.options import Options" > Sentinel_01;
	print "import sys" > Sentinel_01;
	print "import os" > Sentinel_01;
	print "import io" > Sentinel_01;
	print "import random" > Sentinel_01;
	print "import time" > Sentinel_01;
	print "import selenium.webdriver.chrome.service as service" > Sentinel_01;
	print "from selenium.webdriver.support.ui import WebDriverWait" > Sentinel_01;
	print "from selenium.webdriver.support import expected_conditions as EC" > Sentinel_01;
	print "from selenium.common.exceptions import TimeoutException" > Sentinel_01;
	# プロセス管理用
	print "import subprocess" > Sentinel_01;
	
	print "" > Sentinel_01;
	
	# ドライバサービスの起動
	# 先にしておくほうが、これでも処理が速くなるなるという・・・。
	# ・・・と思ったが、プロセスを生成しすぎて死んでしまうので、
	# これはやめた
	# print "service = service.Service(\047"Driver"\047)" > Sentinel_01;
	# print "service.start()" > Sentinel_01;
	# print "" > Sentinel_01;
	
	# 起動オプション
	print "options = Options()" > Sentinel_01;
	print "options.add_argument(\047--headless\047)" > Sentinel_01;
	print "options.add_argument(\047--no-sandbox\047)" > Sentinel_01;
	
	# http://www.stockdog.work/entry/2017/08/22/231718
	# エラーの対処法 chrome not reachable - ストックドッグ
	# さすがに、並列処理中にkillを投げてリトライすることは難しいので、この路線で・・・。
	
	# ----------------------------------------------------------------------------------------------------
	# https://qxf2.com/blog/chrome-not-reachable-error/
	# Chrome not reachable error when running Selenium test on Linux - Qxf2 blog
	# Even after making sure that these were set properly I still got this error.
	# After quite a bit of Googling, I came across this particular StackOverflow solution which helped me resolve my issue.
	# The solution was to add a couple of arguments (no-sandbox, disable-setuid-sandbox) when starting up Chrome.
	# Since I did not understand the solution, I got more info on what Chrome’s Linux sandbox means from this link.
	# The Chrome-Sandbox SUID Helper Binary launches when Chrome does and sets up the sandbox environment.
	# The sandbox environment is meant to be restrictive to the file system and other processes, 
	# attempting to isolate various Chrome parts (such as the renderer) from the system.
	# ----------------------------------------------------------------------------------------------------
	
	# もしくは、この方法でもいいだろう。
	
	# ----------------------------------------------------------------------------------------------------
	# https://qiita.com/eRy-sk/items/f71663242b01d57be85a
	# chrome73でCIが落ちる(chrome not reachable)原因と解決法 - Qiita
	# Chromiumのバグだそうです。現在は修正済み。
	# --disable-features=VizDisplayCompositor属性を付けてやると解決すると書いてあります。
	# https://stackoverflow.com/questions/55388995/chrome-73-stop-supporting-headless-mode-in-background-scheduled-task
	# ----------------------------------------------------------------------------------------------------
	
	print "options.add_argument(\047--disable-setuid-sandbox\047)" > Sentinel_01;
	print "options.add_argument(\047--disable-gpu\047)" > Sentinel_01;
	# https://qiita.com/yoshi10321/items/8b7e6ed2c2c15c3344c6
	# Chromeの--disable-dev-shm-usageオプションについて - Qiita
	# Chrome 65から起動時に--disable-dev-shm-usageを指定することで、シェアドメモリファイルの保持場所を/dev/shmの代わりに/tmpディレクトリを使うようになる
	print "options.add_argument(\047--disable-dev-shm-usage\047)" > Sentinel_01;
	# print "options.add_argument(\047--disable-features=VizDisplayCompositor\047)" > Sentinel_01;
	print "options.add_argument(\047--window-size=1280,1024\047)" > Sentinel_01;
	print "" > Sentinel_01;
	
	# 並列でドライバを立ち上げるため、ランダムに3秒から8秒でsleepを実行
	print "time.sleep(random.randint(3,8))" > Sentinel_01;
	print "" > Sentinel_01;
	
	# ドライバを起動
	print "driver = webdriver.Chrome(options=options)" > Sentinel_01;
	print "driver = webdriver.Chrome(\047"Driver"\047, options=options)" > Sentinel_01;
	print "" > Sentinel_01;
	
	# シンボリックリンクによるロックファイルで3並列まで許容する
	print "LOCK_RCode = 0" > Sentinel_01;
	print "while True:" > Sentinel_01;
	# 1 : ロックファイル1号を取得出来た
	# 2 : ロックファイル2号を取得出来た
	# 3 : ロックファイル3号を取得出来た
	# 4 : ロックファイルを取得出来なかった
	print "	LOCK_RCode = subprocess.run([\047./ShellScripts/GeneLocker.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	LOCK_RCode_Res = LOCK_RCode.returncode" > Sentinel_01;
	print "	if LOCK_RCode_Res == 1 or LOCK_RCode_Res == 2 or LOCK_RCode_Res == 3:" > Sentinel_01;
	print "		break" > Sentinel_01;
	print "	time.sleep(random.randint(3,8))" > Sentinel_01;
	print "" > Sentinel_01;
	print "driver.get(\047https://www.mercari.com/jp/search/?page="PageGeneCnt"&keyword="KeyWord"\047)" > Sentinel_01;
	print "try:" > Sentinel_01;
	# 要素取得に30秒まで待つ
	print "	WebDriverWait(driver, 30).until(EC.presence_of_all_elements_located)" > Sentinel_01;
	print "except TimeoutException as te:" > Sentinel_01;
	BuildMessage = "";
	BuildMessage = TimeOutMessage" : 実行スクリプト名　：　"Sentinel_01"、検索ワード名　：　"KeyWord;
	print "	print(\"99\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	print "	driver.quit()" > Sentinel_01;
	print "	sys.exit(1)" > Sentinel_01;
	print "" > Sentinel_01;
	print "except Exception as e:" > Sentinel_01;
	BuildMessage = "";
	BuildMessage = OtherError" : 実行スクリプト名　：　"Sentinel_01"、検索ワード名　：　"KeyWord;
	print "	print(\"99\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	# スタックトレース発行
	print "	print(str(e), file=sys.stderr)" > Sentinel_01;
	print "	driver.quit()" > Sentinel_01;
	print "	sys.exit(1)" > Sentinel_01;
	print "finally:" > Sentinel_01;
	# ロックファイルの削除
	print "	if LOCK_RCode_Res == 1:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_01.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	elif LOCK_RCode_Res == 2:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_02.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	else:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_03.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "" > Sentinel_01;
	
	# HTMLを出力
	Sentinel_01_Arrays_HTML[ArraysCnt] = OutHTML;
	
	print "LOCK_RCode = 0" > Sentinel_01;
	print "while True:" > Sentinel_01;
	# 1 : ロックファイル1号を取得出来た
	# 2 : ロックファイル2号を取得出来た
	# 3 : ロックファイル3号を取得出来た
	# 4 : ロックファイルを取得出来なかった
	print "	LOCK_RCode = subprocess.run([\047./ShellScripts/GeneLocker.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	LOCK_RCode_Res = LOCK_RCode.returncode" > Sentinel_01;
	print "	if LOCK_RCode_Res == 1 or LOCK_RCode_Res == 2 or LOCK_RCode_Res == 3:" > Sentinel_01;
	print "		break" > Sentinel_01;
	print "	time.sleep(random.randint(3,8))" > Sentinel_01;
	print "" > Sentinel_01;
	
	print "try:" > Sentinel_01;
	print "	file = open(\047"OutHTML"\047,\047w\047,encoding=\047utf-8\047)" > Sentinel_01;
	print "	file.write(str(driver.page_source))" > Sentinel_01;
	print "except FileNotFoundError as e:" > Sentinel_01;
	Temp = " : 実行スクリプト名　：　"Sentinel_01"、検索ワード名　：　"KeyWord"、HTMLファイル名　：　"OutHTML;
	BuildMessage = "";
	BuildMessage = HTMLFileIOErrorMessage BuildMessage;
	print "	print(\"99\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	print "	sys.exit(2)" > Sentinel_01;
	print "except PermissionError as e:" > Sentinel_01;
	BuildMessage = "";
	BuildMessage = PermissionErrorMessage BuildMessage;
	print "	print(\"99\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	print "	sys.exit(2)" > Sentinel_01;
	print "except OSError as e:" > Sentinel_01;
	BuildMessage = "";
	BuildMessage = OSErrorMessage BuildMessage;
	print "	print(\"99\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	print "	sys.exit(2)" > Sentinel_01;
	print "except Exception as e:" > Sentinel_01;
	BuildMessage = "";
	BuildMessage = OtherError BuildMessage;
	print "	print(\"99\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	# スタックトレース発行
	print "	print(str(e), file=sys.stderr)" > Sentinel_01;
	print "	sys.exit(2)" > Sentinel_01;
	print "finally:" > Sentinel_01;
	print "	file.close()" > Sentinel_01;
	# ロックファイルの削除
	print "	if LOCK_RCode_Res == 1:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_01.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	elif LOCK_RCode_Res == 2:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_02.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	else:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_03.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "" > Sentinel_01;
	print "	print(\"0\", end=\"\")" > Sentinel_01;
	
	# スクリーンショットを取得
	print "LOCK_RCode = 0" > Sentinel_01;
	print "while True:" > Sentinel_01;
	# 1 : ロックファイル1号を取得出来た
	# 2 : ロックファイル2号を取得出来た
	# 3 : ロックファイル3号を取得出来た
	# 4 : ロックファイルを取得出来なかった
	print "	LOCK_RCode = subprocess.run([\047./ShellScripts/GeneLocker.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	LOCK_RCode_Res = LOCK_RCode.returncode" > Sentinel_01;
	print "	if LOCK_RCode_Res == 1 or LOCK_RCode_Res == 2 or LOCK_RCode_Res == 3:" > Sentinel_01;
	print "		break" > Sentinel_01;
	print "	time.sleep(random.randint(3,8))" > Sentinel_01;
	print "" > Sentinel_01;
	print "page_height = driver.execute_script(\047return document.body.scrollHeight\047)" > Sentinel_01;
	print "ScrollCnt = 0" > Sentinel_01;
	print "LOCK_RCode = 0" > Sentinel_01;
	# 商品画像が、スクロールしないといつまで待っても読み込まれない（白い画像として出てくる）ので、
	# 0.3秒置きに、一番下に到達するまでスクロールし続ける。
	# ----------------------------------------------------------------------------------------------------
	# https://qiita.com/mistecon/items/ef5be5079f3735792c7c
	# Selenium・Pythonを用いた動的Webサイトのスクレイピング（初心者用） - Qiita
	# airbnbのリスティングサイトでは、クリックしたいリンク先が画面内に表示されないとクリックできません。
	# そのため、スクロールしてからクリックします。
	# ----------------------------------------------------------------------------------------------------
	print "while True:" > Sentinel_01;
	print "	ScrollCnt = ScrollCnt + 100" > Sentinel_01;
	print "	if ScrollCnt > page_height:" > Sentinel_01;
	print "		ScrollCnt = page_height" > Sentinel_01;
	print "	ScriptCMD = \"window.scrollBy(0, \" + str(ScrollCnt) + \");\"" > Sentinel_01;
	print "	driver.execute_script(str(ScriptCMD))" > Sentinel_01;
	print "	time.sleep(0.3)" > Sentinel_01;
	print "	if ScrollCnt >= page_height:" > Sentinel_01;
	print "		break" > Sentinel_01;
	print "" > Sentinel_01;
	# ロックファイルの削除
	print "	if LOCK_RCode_Res == 1:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_01.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	elif LOCK_RCode_Res == 2:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_02.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	else:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_03.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "" > Sentinel_01;
	# 念のため、2秒間をおく
	print "time.sleep(2)" > Sentinel_01;
	print "" > Sentinel_01;
	# --------------------------------------------------------------------------------------------------------------------------
	# https://blog.amedama.jp/entry/2018/07/28/003342
	# Python: Selenium + Headless Chrome で Web ページ全体のスクリーンショットを撮る - CUBE SUGAR CONTAINER
	# （・・・）ページ全体の横幅と高さを取得したら、それをウィンドウサイズとしてセットする。
	# これによって Web ページ全体のスクリーンショットを一つの画像として撮影できる。
	# ちなみに Headless モードにしていないと、ここで設定できる値がモニターの解像度に依存してしまう。
	# --------------------------------------------------------------------------------------------------------------------------
	print "page_width = driver.execute_script(\047return document.body.scrollWidth\047)" > Sentinel_01;
	# 高さは、スクロールの時点で取得済
	print "driver.set_window_size(page_width, page_height)" > Sentinel_01;
	Sentinel_01_Arrays_ScreenShot[ArraysCnt] = OutScreenShot;
	print "LOCK_RCode = 0" > Sentinel_01;
	print "while True:" > Sentinel_01;
	# 1 : ロックファイル1号を取得出来た
	# 2 : ロックファイル2号を取得出来た
	# 3 : ロックファイル3号を取得出来た
	# 4 : ロックファイルを取得出来なかった
	print "	LOCK_RCode = subprocess.run([\047./ShellScripts/GeneLocker.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	LOCK_RCode_Res = LOCK_RCode.returncode" > Sentinel_01;
	print "	if LOCK_RCode_Res == 1 or LOCK_RCode_Res == 2 or LOCK_RCode_Res == 3:" > Sentinel_01;
	print "		break" > Sentinel_01;
	print "	time.sleep(random.randint(3,8))" > Sentinel_01;
	print "" > Sentinel_01;
	print "try:" > Sentinel_01;
	print "	driver.save_screenshot(\047"OutScreenShot"\047)" > Sentinel_01;
	print "except FileNotFoundError as e:" > Sentinel_01;
	Temp = " : 実行スクリプト名　：　"Sentinel_01"、検索ワード名　：　"KeyWord"、PNGファイル名　：　"OutScreenShot;
	BuildMessage = "";
	BuildMessage = HTMLFileIOErrorMessage BuildMessage;
	print "	print(\"9\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	print "	sys.exit(3)" > Sentinel_01;
	print "except PermissionError as e:" > Sentinel_01;
	BuildMessage = "";
	BuildMessage = PermissionErrorMessage BuildMessage;
	print "	print(\"9\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	print "	sys.exit(3)" > Sentinel_01;
	print "except OSError as e:" > Sentinel_01;
	BuildMessage = "";
	BuildMessage = OSErrorMessage BuildMessage;
	print "	print(\"9\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	print "	sys.exit(3)" > Sentinel_01;
	print "except Exception as e:" > Sentinel_01;
	BuildMessage = "";
	BuildMessage = OtherError BuildMessage;
	print "	print(\"9\", end=\"\")" > Sentinel_01;
	print "	print(\047"BuildMessage"\047, file=sys.stderr)" > Sentinel_01;
	# スタックトレース発行
	print "	print(str(e), file=sys.stderr)" > Sentinel_01;
	print "	sys.exit(3)" > Sentinel_01;
	
	print "finally:" > Sentinel_01;
	print "	driver.quit()" > Sentinel_01;
	# ロックファイルの削除
	print "	if LOCK_RCode_Res == 1:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_01.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	elif LOCK_RCode_Res == 2:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_02.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "	else:" > Sentinel_01;
	print "		DELCode = subprocess.run([\047./ShellScripts/DelLocker_03.sh\047], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)" > Sentinel_01;
	print "" > Sentinel_01;
	print "	print(\"0\", end=\"\")" > Sentinel_01;
	print "sys.exit(0)" > Sentinel_01;
	print "" > Sentinel_01;
}

END{
	# 起動用Shell生成
	ExecShell = MainDir"/ExecShell.sh";
	# 実行監視用Shell生成
	MonitorShell = MainDir"/Monitor.sh";
	# コマンドShell生成
	CmdShell = MainDir"/CmdShell.sh";
	
	print "#!/bin/sh" > ExecShell;
	print "# sh "ExecShell > ExecShell;
	print "" > ExecShell;
	
	for(i in Sentinel_01_BitPanelArrays){
		print "rm -f "Sentinel_01_BitPanelArrays[i]" > /dev/null 2>&1" > ExecShell;
	}
	print "" > ExecShell;
	
	# chrome関係プロセスを全て落とす
	# 道連れに落ちるのがいて、プロセスがいない、というエラーが出る場合があるので、
	# /dev/nullに捨てている
	print "sh ./ShellScripts/Chrome_Killer.sh" > ExecShell;
	print "" > ExecShell;
	# pythonのインポートまではすべて完了させておきたいので、
	# python内部のchromeやchromedriverプロセス数で動作数の制御を実施する
	# 元々時間のかかる処理だらけなので、こんな程度でいい。
	print "xargs -P 8 -a "CmdShell" -r -I{} sh -c \047{}\047 & "  > ExecShell;
	# 正直、xargs自体の復帰値はいらないが、こういう手法なので・・・。
	# 各Pythonスクリプトの進行コードは、ビットパネルファイルに書き出されるので、そこから取得して判定する。
	print "foo1pid=$!" > ExecShell;
	for(i in Sentinel_01_Arrays){
	 	print "python "Sentinel_01_Arrays[i]" > "Sentinel_01_BitPanelArrays[i] > CmdShell;
	}
	print "sh "MonitorShell" & " > ExecShell;
	print "foo2pid=$!" > ExecShell;
	print "wait $foo1pid" > ExecShell;
	print "RetCode_01=$?" > ExecShell;
	print "wait $foo2pid" > ExecShell;
	print "RetCode_02=$?" > ExecShell;
	print "sh ./ShellScripts/Chrome_Killer.sh" > ExecShell;
	print "" > ExecShell;
	# モニタリングShellの復帰値で、メインShellの復帰値を決める
	print "exit $RetCode_02" > ExecShell;
	print "" > ExecShell;
	
	# 実行監視用
	print "#!/bin/sh" > MonitorShell;
	print "" > MonitorShell;
	print "while :" > MonitorShell;
	print "do" > MonitorShell;
	print "	HTMLCnt=0" > MonitorShell;
	print "	HTMLMaxCnt="length(Sentinel_01_Arrays_HTML) > MonitorShell;
	print "	ScreenShotCnt=0" > MonitorShell;
	print "	ScreenShotMaxCnt="length(Sentinel_01_Arrays_ScreenShot) > MonitorShell;
	# BitPanelの存在を検知し、BitPanelが「99」、「09」の場合は、異常終了。
	# 「0」の場合、HTMLCntをインクリメントし、「00」の場合、HTMLCntとScreenShotCntをインクリメントする。
	for(i in Sentinel_01_BitPanelArrays){
		print "	ls \""Sentinel_01_BitPanelArrays[i]"\" > /dev/null 2>&1" > MonitorShell;
		print "	RetCode=$?" > MonitorShell;
		print "	Counter=\"\"" > MonitorShell;
		print "	test $RetCode -eq 0 && Counter=`cat \""Sentinel_01_BitPanelArrays[i]"\"`" > MonitorShell;
		print "	test $RetCode -eq 0 && test \"$Counter\" = \"99\" -o \"$Counter\" = \"09\" && exit 99" > MonitorShell;
		print "	test $RetCode -eq 0 && test \"$Counter\" = \"0\" && HTMLCnt=$(( HTMLCnt + 1 ))" > MonitorShell;
		print "	test $RetCode -eq 0 && test \"$Counter\" = \"00\" && HTMLCnt=$(( HTMLCnt + 1 )) && ScreenShotCnt=$(( ScreenShotCnt + 1 ))" > MonitorShell;
	}
	print "	DATE=`date \"+%Y年%m月%d日 %H時%M分%S秒\"`" > MonitorShell;
	print "	HTML_Percent=`echo \"$HTMLCnt\" \"$HTMLMaxCnt\" | awk \047{Calc = $1 / $2 * 100; print int(Calc + 0.5); exit;}\047`" > MonitorShell;
	print "	echo \"実行中　：　HTML取得　：　$HTMLCnt / $HTMLMaxCnt件（$HTML_Percent％完了）　$DATE\"" > MonitorShell;
	print "	ScreenShot_Percent=`echo \"$ScreenShotCnt\" \"$ScreenShotMaxCnt\" | awk \047{Calc = $1 / $2 * 100; print int(Calc + 0.5); exit;}\047`" > MonitorShell;
	print "	echo \"実行中　：　スクリーンショット取得　：　$ScreenShotCnt / $ScreenShotMaxCnt件（$ScreenShot_Percent％完了）\"　$DATE" > MonitorShell;
	print "	test $HTML_Percent -ge 100 -a $ScreenShot_Percent -ge 100 && exit 0" > MonitorShell;
	print "	sleep 5" > MonitorShell;
	print "done" > MonitorShell;
	print "" > MonitorShell;
	
	for(i in Keyword_Arrays){
		print Keyword_Arrays[i]","Keyword_ConvertedArrays[i]","Sentinel_01_Arrays[i]","Sentinel_01_Arrays_HTML[i]","Sentinel_01_Arrays_ScreenShot[i] > ResultCSV;
	}
	delete Keyword_Arrays;
	delete Keyword_ConvertedArrays;
	delete Sentinel_01_Arrays;
	delete Sentinel_01_Arrays_HTML;
	delete Sentinel_01_Arrays_ScreenShot;
}

