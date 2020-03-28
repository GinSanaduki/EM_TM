#!/bin/sh
# GeneMercari.sh
# スクリーンショットまで取得するVer
# sh ./ShellScripts/GeneMercari.sh NORMAL
# bashdb ./ShellScripts/GeneMercari.sh NORMAL
# HTMLのみ取得するVer
# sh ./ShellScripts/GeneMercari.sh HTML
# bashdb ./ShellScripts/GeneMercari.sh HTML

Args_01=$1
Args_01=`echo $Args_01 | awk '{print toupper($0); exit;}'`

case "$Args_01" in
	"NORMAL")
		;;
	"HTML")
		;;
	*)
		echo "INVALID ARGUMENT."
		exit 99
esac
# コマンドの不足を確認
echo "必要なコマンドのチェックを行います・・・"
sh ./ShellScripts/Command_Check.sh
RetCode=$?
test $RetCode -ne 0 && exit 99
echo "コマンドの存在チェックが完了しました。"

trap "sh ./ShellScripts/Sweeper.sh" 1 2 3 15

# 実行時刻のUNIX時刻と変換後の時刻表記を取得しておく
# この時刻で、生成ファイルを配置するディレクトリを生成する
# 時刻は、YYYYMMDD_HHmmで、UNIX時刻を6時間毎に丸める。
SYSTIME=`gawk -f AWKScripts/ReplyDirTime.awk -v Mode=01`
SYSTIME_YYYYMMDD_HH=`echo $SYSTIME | gawk '{print strftime("%Y%m%d_%H", $0)}'`
MainDir="ResultOut/ResultOut_"$SYSTIME_YYYYMMDD_HH
mkdir -p $MainDir > /dev/null 2>&1

test -f ./Define_SearchWord.conf
RetCode=$?
test $RetCode -ne 0 && echo "Define_SearchWord.conf NOT FOUND." && exit 99

test -s ./Define_SearchWord.conf
RetCode=$?
test $RetCode -ne 0 && echo "Define_SearchWord.conf filesize is ZERO." && exit 99

# --------------------------------------------------------------------------------------------------------------

Sentinel01Dir=$MainDir"/Sentinel_01"
mkdir $Sentinel01Dir > /dev/null 2>&1
# gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_01 Define_SearchWord.conf
gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_01 -v GeneMercariMode=$Args_01 Define_SearchWord.conf
test $? -ne 0 && exit 99
rm -f LOCKFILE_*.lock > /dev/null 2>&1
echo "各キーワードに対する検索を実施します・・・"
rm -f $Sentinel01Dir/*.txt > /dev/null 2>&1
sh $MainDir/Supervisor_Sentinel_01.sh
RetCode_Supervisor_Sentinel_01=$?
test $RetCode_Supervisor_Sentinel_01 -ne 0 && exit 99
rm -rf $Sentinel01Dir > /dev/null 2>&1
rm -f $MainDir/*.txt > /dev/null 2>&1
rm -f $MainDir/*.sh > /dev/null 2>&1

# --------------------------------------------------------------------------------------------------------------

# Sentinel_01_CSV.csvから、HTMLに対しfgrepを発行するShellを生成する
# 取得した1ページ目のHTMLに、「該当する商品が見つかりません。検索条件を変えて、再度お試しください。」
# が含まれているかどうか検査する
# TODO : 該当する商品が見つかりません。しかない場合
gawk -f AWKScripts/GeneSentinel_02.awk $MainDir/Sentinel_01_CSV.csv
test $? -ne 0 && exit 99
sh $MainDir/Exec_Sentinel_02.sh > $MainDir/Sentinel_02_CSV.csv
rm -f $MainDir/Sentinel_01_CSV.csv > /dev/null 2>&1
rm -f $MainDir/Exec_Sentinel_02.sh > /dev/null 2>&1

# --------------------------------------------------------------------------------------------------------------

# <icon-arrow-right>クラスにハイパーリンクが付与されているか否かを検査する
# （「＞」ボタンが存在するかどうか）
# TODO : 「＞」ボタンが存在しない場合しかない場合
gawk -f AWKScripts/GeneSentinel_03.awk $MainDir/Sentinel_02_CSV.csv
test $? -ne 0 && exit 99
sh $MainDir/Exec_Sentinel_03.sh > $MainDir/Sentinel_03_CSV.csv
rm -f $MainDir/Sentinel_02_CSV.csv > /dev/null 2>&1
rm -f $MainDir/*.sh > /dev/null 2>&1

# --------------------------------------------------------------------------------------------------------------

# 最終ページを辿っていく過程で、URL組み立て用に次ページを割り出しておく
gawk -f AWKScripts/GeneSentinel_04.awk $MainDir/Sentinel_03_CSV.csv
test $? -ne 0 && exit 99
rm -f $MainDir/Sentinel_03_CSV.csv > /dev/null 2>&1

# --------------------------------------------------------------------------------------------------------------

gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_02 -v GeneMercariMode=$Args_01 $MainDir/Sentinel_04_CSV.csv
test $? -ne 0 && exit 99

sh $MainDir/Exec_Sentinel_02.sh
RetCode=$?
test $RetCode -ne 0 && exit 99;

rm -rf $MainDir/Sentinel_02 > /dev/null 2>&1
rm -f $MainDir/Sentinel_04_CSV.csv > /dev/null 2>&1
rm -f $MainDir/Exec_Sentinel_02.sh > /dev/null 2>&1
echo "各キーワードに対する検索が完了しました。"

# --------------------------------------------------------------------------------------------------------------

# Sentinel_05_CSV.csvの8カラム目が2以上の場合、その件数分だけPythonスクリプトを生成し、実行させる。
# Pythonスクリプト側は、ハッシュ値を確認し、同一の場合、スキップさせる。

Sentinel03Dir=$MainDir"/Sentinel_03"
mkdir $Sentinel03Dir > /dev/null 2>&1
echo "gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_03 -v GeneMercariMode=$Args_01 $MainDir/Sentinel_05_CSV.csv"
gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_03 -v GeneMercariMode=$Args_01 $MainDir/Sentinel_05_CSV.csv
test $? -ne 0 && exit 99

rm -f LOCKFILE_*.lock > /dev/null 2>&1
echo "各キーワードに対する検索を実施します・・・"
rm -f $Sentinel03Dir/*.txt > /dev/null 2>&1
sh $MainDir/Supervisor_Sentinel_03.sh
RetCode_Supervisor_Sentinel_03=$?
exit

test $RetCode_Supervisor_Sentinel_03 -ne 0 && exit 99
rm -rf $Sentinel03Dir > /dev/null 2>&1
rm -f $MainDir/*.txt > /dev/null 2>&1
rm -f $MainDir/*.sh > /dev/null 2>&1

exit

echo "各キーワードに対する検索が完了しました。"

exit 0

