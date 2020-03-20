#!/bin/sh
# GeneMercari.sh
# sh ./ShellScripts/GeneMercari.sh

# コマンドの不足を確認
echo "必要なコマンドのチェックを行います・・・"
sh ./ShellScripts/Command_Check.sh
RetCode=$?
test $RetCode -ne 0 && exit 99
echo "コマンドの存在チェックが完了しました。"

# 実行時刻のUNIX時刻と変換後の時刻表記を取得しておく
# この時刻で、生成ファイルを配置するディレクトリを生成する
SYSTIME=`awk 'BEGIN{print systime();}'`
SYSTIME_YYYYMMDD_HHMMSS=`echo $SYSTIME | gawk '{print strftime("%Y%m%d_%H%M%S", $0);exit;}'`
MainDir="ResultOut/ResultOut_"$SYSTIME_YYYYMMDD_HHMMSS
mkdir -p $MainDir > /dev/null 2>&1

test -f ./Define_SearchWord.conf
RetCode=$?
test $RetCode -ne 0 && echo "Define_SearchWord.conf NOT FOUND." && exit 99

test -s ./Define_SearchWord.conf
RetCode=$?
test $RetCode -ne 0 && echo "Define_SearchWord.conf filesize is ZERO." && exit 99

# センチネル1号機集団を作成する
Sentinel01Dir=$MainDir"/Sentinel_01"
mkdir $Sentinel01Dir > /dev/null 2>&1
gawk -f AWKScripts/GeneSentinel_01.awk -v SYSTIME=$SYSTIME Define_SearchWord.conf
rm -f LOCKFILE_01.lock > /dev/null 2>&1
rm -f LOCKFILE_02.lock > /dev/null 2>&1
rm -f LOCKFILE_03.lock > /dev/null 2>&1
sh $MainDir/ExecShell.sh
RetCode=$?
rm -f LOCKFILE_01.lock > /dev/null 2>&1
rm -f LOCKFILE_02.lock > /dev/null 2>&1
rm -f LOCKFILE_03.lock > /dev/null 2>&1
# awk側で/dev/nullを生成したら、強制終了と出たので、回避するために呼び元から/dev/nullに突っ込んでいる
ps -aux | fgrep "GeneLocker.sh" | grep -v grep | awk 'BEGIN{print ":";}{print "kill -9 "$2;}' | sh > /dev/null 2>&1
rm -rf $MainDir/Sentinel_01

test $RetCode -ne 0 && exit 99

exit 0

