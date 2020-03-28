#!/usr/bin/env python
# -*- coding: utf-8 -*-
# python ./ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py
# python -m pdb  ./ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import sys
import os
import io
import random
import time
import selenium.webdriver.chrome.service as service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
import subprocess

Hash_Judge = 0
Hash_RCode_01 = subprocess.run("sha512sum -c --quiet ResultOut/ResultOut_20200329_00/赤本/HashList_赤本_page_95.txt > /dev/null 2>&1", shell = True)
Hash_RCode_01_Res = Hash_RCode_01.returncode
if Hash_RCode_01_Res == 0:
	Hash_Judge = 1
if Hash_Judge == 0:
	subprocess.run("rm -f \"ResultOut/ResultOut_20200329_00/赤本/赤本_page_95.html\" > /dev/null 2>&1", shell = True)
	subprocess.run("rm -f \"ResultOut/ResultOut_20200329_00/赤本/HashList_赤本_page_95.txt\" > /dev/null 2>&1", shell = True)
if Hash_Judge == 1:
	FileSize_RCode = subprocess.run("echo \"python ./ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py > ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_BitPanel_赤本_95.txt\" | awk -f AWKScripts/FileSizeJudge.awk  -v GeneMercariMode=HTML", shell = True)
	FileSize_RCode_Res = FileSize_RCode.returncode
	if FileSize_RCode_Res == 0:
		print("00", end="")
		subprocess.run("gawk -f AWKScripts/AlertMessages.awk -v MESSAGE=SKIPPED -v PAGENUMBER=95 -v SEARCHWORD=赤本 -v OUTFILENAME_01=ResultOut/ResultOut_20200329_00/赤本/赤本_page_95.html -v HASHLIST_01=ResultOut/ResultOut_20200329_00/赤本/HashList_赤本_page_95.txt -v GENE_MERCARIMODE=HTML", shell = True)
		sys.exit(255)
	

options = Options()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-setuid-sandbox')
options.add_argument('--disable-gpu')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--window-size=1280,1024')

try:
	driver = webdriver.Chrome(options=options)
	driver = webdriver.Chrome('/usr/local/bin/chromedriver', options=options)
except OSError as e:
	print("99", end="")
	print('Chrome Driverに異常が発生しました。（OSError） : 実行スクリプト名　：　ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py、検索ワード名　：　赤本', file=sys.stderr)
	print(str(e), file=sys.stderr)
	driver.quit()
	subprocess.run(['rm', '-f', 'LOCKFILE_00.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	sys.exit(1)
except Exception as e:
	print("99", end="")
	print('予期せぬエラーが発生しました。 : 実行スクリプト名　：　ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py、検索ワード名　：　赤本', file=sys.stderr)
	print(str(e), file=sys.stderr)
	driver.quit()
	subprocess.run(['rm', '-f', 'LOCKFILE_00.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	sys.exit(1)

while True:
	LOCK_RCode = subprocess.run(['./ShellScripts/GeneLocker_01.sh'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	LOCK_RCode_Res = LOCK_RCode.returncode
	if LOCK_RCode_Res == 0:
		break
	time.sleep(random.randint(3,8))

try:
	driver.get('https://www.mercari.com/jp/search/?page=95&keyword=赤本')
	WebDriverWait(driver, 30).until(EC.presence_of_all_elements_located)
except TimeoutException as e:
	print("99", end="")
	print('接続がタイムアウトしました。 : 実行スクリプト名　：　ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py、検索ワード名　：　赤本', file=sys.stderr)
	print(str(e), file=sys.stderr)
	driver.quit()
	subprocess.run(['rm', '-f', 'LOCKFILE_00.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	sys.exit(1)
except Exception as e:
	print("99", end="")
	print('予期せぬエラーが発生しました。 : 実行スクリプト名　：　ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py、検索ワード名　：　赤本', file=sys.stderr)
	print(str(e), file=sys.stderr)
	driver.quit()
	subprocess.run(['rm', '-f', 'LOCKFILE_00.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	sys.exit(1)
finally:
	time.sleep(5)
	subprocess.run(['rm', '-f', 'LOCKFILE_00.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)

while True:
	LOCK_RCode = subprocess.run(['./ShellScripts/GeneLocker_02.sh'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	LOCK_RCode_Res = LOCK_RCode.returncode
	if LOCK_RCode_Res == 1 or LOCK_RCode_Res == 2 or LOCK_RCode_Res == 3:
		break
	time.sleep(random.randint(3,8))

try:
	file = open('ResultOut/ResultOut_20200329_00/赤本/赤本_page_95.html','w',encoding='utf-8')
	file.write(str(driver.page_source))
except FileNotFoundError as e:
	print("99", end="")
	print('出力対象ファイルの書き込みに失敗しました。 : 実行スクリプト名　：　ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py、検索ワード名　：　赤本、HTMLファイル名　：　ResultOut/ResultOut_20200329_00/赤本/赤本_page_95.html', file=sys.stderr)
	print(str(e), file=sys.stderr)
	driver.quit()
	if LOCK_RCode_Res == 1:
		subprocess.run(['rm', '-f', 'LOCKFILE_01.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	elif LOCK_RCode_Res == 2:
		subprocess.run(['rm', '-f', 'LOCKFILE_02.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	else:
		subprocess.run(['rm', '-f', 'LOCKFILE_03.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	sys.exit(2)
except PermissionError as e:
	print("99", end="")
	print('出力対象ファイルの書き込み権限がありません。 : 実行スクリプト名　：　ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py、検索ワード名　：　赤本、HTMLファイル名　：　ResultOut/ResultOut_20200329_00/赤本/赤本_page_95.html', file=sys.stderr)
	print(str(e), file=sys.stderr)
	driver.quit()
	if LOCK_RCode_Res == 1:
		subprocess.run(['rm', '-f', 'LOCKFILE_01.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	elif LOCK_RCode_Res == 2:
		subprocess.run(['rm', '-f', 'LOCKFILE_02.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	else:
		subprocess.run(['rm', '-f', 'LOCKFILE_03.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	sys.exit(2)
except OSError as e:
	print("99", end="")
	print('出力対象ファイルの書き込みに失敗しました。（OSError） : 実行スクリプト名　：　ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py、検索ワード名　：　赤本、HTMLファイル名　：　ResultOut/ResultOut_20200329_00/赤本/赤本_page_95.html', file=sys.stderr)
	print(str(e), file=sys.stderr)
	driver.quit()
	if LOCK_RCode_Res == 1:
		subprocess.run(['rm', '-f', 'LOCKFILE_01.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	elif LOCK_RCode_Res == 2:
		subprocess.run(['rm', '-f', 'LOCKFILE_02.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	else:
		subprocess.run(['rm', '-f', 'LOCKFILE_03.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	sys.exit(2)
except Exception as e:
	print("99", end="")
	print('予期せぬエラーが発生しました。 : 実行スクリプト名　：　ResultOut/ResultOut_20200329_00/Sentinel_03/Sentinel_03_赤本_95.py、検索ワード名　：　赤本、HTMLファイル名　：　ResultOut/ResultOut_20200329_00/赤本/赤本_page_95.html', file=sys.stderr)
	print(str(e), file=sys.stderr)
	driver.quit()
	if LOCK_RCode_Res == 1:
		subprocess.run(['rm', '-f', 'LOCKFILE_01.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	elif LOCK_RCode_Res == 2:
		subprocess.run(['rm', '-f', 'LOCKFILE_02.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	else:
		subprocess.run(['rm', '-f', 'LOCKFILE_03.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	sys.exit(2)
finally:
	file.close()
	print("00", end="")
	subprocess.run("sha512sum \"ResultOut/ResultOut_20200329_00/赤本/赤本_page_95.html\" > \"ResultOut/ResultOut_20200329_00/赤本/HashList_赤本_page_95.txt\"", shell = True)
	subprocess.run("gawk -f AWKScripts/AlertMessages.awk -v MESSAGE=COMP_HTML -v PAGENUMBER=95 -v SEARCHWORD=赤本 -v OUTFILENAME=ResultOut/ResultOut_20200329_00/赤本/赤本_page_95.html -v HASHLIST=ResultOut/ResultOut_20200329_00/赤本/HashList_赤本_page_95.txt -v GENE_MERCARIMODE=HTML", shell = True)

	driver.quit()
	if LOCK_RCode_Res == 1:
		subprocess.run(['rm', '-f', 'LOCKFILE_01.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	elif LOCK_RCode_Res == 2:
		subprocess.run(['rm', '-f', 'LOCKFILE_02.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
	else:
		subprocess.run(['rm', '-f', 'LOCKFILE_03.lock'], stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)
sys.exit(0)

