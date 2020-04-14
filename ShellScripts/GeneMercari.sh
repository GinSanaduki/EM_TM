#!/bin/sh
# GeneMercari.sh
# スクリーンショットまで取得するVer
# sh ./ShellScripts/GeneMercari.sh NORMAL
# bashdb ./ShellScripts/GeneMercari.sh NORMAL
# HTMLのみ取得するVer
# sh ./ShellScripts/GeneMercari.sh HTML
# bashdb ./ShellScripts/GeneMercari.sh HTML

# 検索ワードは32文字で打ち切る
# ファイル名との絡みもあるからね

. ./ShellScripts/BuiltIn_Check.sh

Args_01=$1
Args_01=`$ECHO$Args_01 | awk '{print toupper($0); exit;}'`

case "$Args_01" in
	"NORMAL")
		;;
	"HTML")
		;;
	*)
		$ECHO"INVALID ARGUMENT."
		exit 99
esac

# コマンドの不足を確認
$ECHO"必要なコマンドのチェックを行います・・・"
sh ./ShellScripts/Command_Check.sh
test $? -ne 0 && exit 99
$ECHO"コマンドの存在チェックが完了しました。"

trap "sh ./ShellScripts/Sweeper.sh" 1 2 3 15

# 実行時刻のUNIX時刻と変換後の時刻表記を取得しておく
# この時刻で、生成ファイルを配置するディレクトリを生成する
# 時刻は、YYYYMMDD_HHmmで、UNIX時刻を6時間毎に丸める。
SYSTIME=`gawk -f AWKScripts/ReplyDirTime.awk -v Mode=01`
SYSTIME_YYYYMMDD_HH=`$ECHO$SYSTIME | gawk '{print strftime("%Y%m%d_%H", $0)}'`
MainDir="ResultOut/ResultOut_"$SYSTIME_YYYYMMDD_HH
mkdir -p $MainDir > /dev/null 2>&1
$TEST$? -ne 0 && exit 99

$TEST-f ./Define_SearchWord.conf
$TEST$? -ne 0 && $ECHO"Define_SearchWord.conf NOT FOUND." && exit 99

$TEST-s ./Define_SearchWord.conf
RetCode=$?
$TEST$? -ne 0 && $ECHO"Define_SearchWord.conf filesize is ZERO." && exit 99

# --------------------------------------------------------------------------------------------------------------

Sentinel01Dir=$MainDir"/Sentinel_01"
mkdir -p $Sentinel01Dir > /dev/null 2>&1
$TEST$? -ne 0 && exit 99
# 重複キーワード、使用すべきでない記号を除外
rm -f Converted_Define_SearchWord.conf > /dev/null 2>&1
awk -f AWKScripts/Inspector.awk -v Mode=Check Define_SearchWord.conf
RetCode=$?
case "$RetCode" in
	"0")
		;;
	"1")
		Error_Messages_01="Define_SearchWord.confに有効な記載が存在しません。"
		Error_Messages_02="Define_SearchWord.confに検索したいキーワードを記載してください。"
		$PRINTF'%s\n%s\n' "$Error_Messages_01" "$Error_Messages_02"
		exit 99
		;;
	*)
		$ECHO"INVALID ARGUMENT."
		exit 99
esac

gawk -f AWKScripts/Inspector.awk -v Mode=Convert Define_SearchWord.conf | \
sort | \
uniq > Converted_Define_SearchWord.conf

gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_01 -v GeneMercariMode=$Args_01 Converted_Define_SearchWord.conf
$TEST$? -ne 0 && exit 99
rm -f LOCKFILE_*.lock > /dev/null 2>&1
$ECHO"各キーワードに対する検索を実施します・・・"
rm -f $Sentinel01Dir/BitPanel_*.txt > /dev/null 2>&1
sh $MainDir/Supervisor_Sentinel_01.sh
$TEST$? -ne 0 && exit 99
rm -rf $Sentinel01Dir > /dev/null 2>&1
rm -f $MainDir/*.txt > /dev/null 2>&1
rm -f $MainDir/*.sh > /dev/null 2>&1
rm -f Converted_Define_SearchWord.conf > /dev/null 2>&1

# --------------------------------------------------------------------------------------------------------------

# Sentinel_01_CSV.csvから、HTMLに対しfgrepを発行するShellを生成する
# 取得した1ページ目のHTMLに、「該当する商品が見つかりません。検索条件を変えて、再度お試しください。」
# が含まれているかどうか検査する
awk -f AWKScripts/GeneShell_SearchNotFound.awk $MainDir/Sentinel_01_CSV.csv
$TEST$? -ne 0 && exit 99
sh $MainDir/Exec_SearchNotFound.sh | \
sort -t ',' -k 1n,1 | \
uniq > $MainDir/Result_Exec_SearchNotFound.csv
rm -f $MainDir/Sentinel_01_CSV.csv > /dev/null 2>&1
rm -f $MainDir/Exec_SearchNotFound.sh > /dev/null 2>&1

# --------------------------------------------------------------------------------------------------------------

# <icon-arrow-right>クラスにハイパーリンクが付与されているか否かを検査する
# （「＞」ボタンが存在するかどうか）
awk -f AWKScripts/GeneShell_SearchRightArrow.awk $MainDir/Result_Exec_SearchNotFound.csv
RetCode=$?
case "$RetCode" in
	"0")
		;;
	"255")
		Error_Messages_01="すべての検索対象キーワードにおいて、検索結果が存在しませんでした。"
		Error_Messages_02="スクリプトを終了します。"
		$PRINTF'%s\n%s\n' "$Error_Messages_01" "$Error_Messages_02"
		exit 1
		;;
	*)
		exit 99
esac

sh $MainDir/Exec_SearchRightArrow.sh > $MainDir/Result_Exec_SearchRightArrow.csv
$TEST$? -ne 0 && exit 99
cat $MainDir/Result_Exec_SearchRightArrow.csv | \
sort -t ',' -k 1n,1 | \
uniq > $MainDir/Sorted_Result_Exec_SearchRightArrow.csv
rm -f $MainDir/Result_Exec_SearchNotFound.csv > /dev/null 2>&1
rm -f $MainDir/Result_Exec_SearchRightArrow.csv > /dev/null 2>&1
rm -f $MainDir/*.sh > /dev/null 2>&1

# --------------------------------------------------------------------------------------------------------------

# 最終ページを辿っていく過程で、URL組み立て用に次ページを割り出しておく
ContinueSkipBit=0
awk -f AWKScripts/GeneCSV_SearchNextPageColumn.awk $MainDir/Sorted_Result_Exec_SearchRightArrow.csv
RetCode=$?
case "$RetCode" in
	"0")
		;;
	"1")
		$ECHO"すべての検索対象キーワードにおいて、1ページのみ検索結果が存在しました。"
		ContinueSkipBit=1
		;;
	*)
		exit 99
esac
rm -f $MainDir/Sorted_Result_Exec_SearchRightArrow.csv > /dev/null 2>&1

# --------------------------------------------------------------------------------------------------------------

case "$ContinueSkipBit" in
	"0")
		gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_02 -v GeneMercariMode=$Args_01 $MainDir/Sentinel_02_CSV.csv
		$TEST$? -ne 0 && exit 99
		
		sh $MainDir/Exec_Sentinel_02.sh
		$TEST$? -ne 0 && exit 99
		
		cat $MainDir/Sentinel_05_CSV.csv | \
		sort -t ',' -k 1n,1 | \
		uniq > $MainDir/Sorted_Result_Sentinel_05_CSV.csv
		
		rm -rf $MainDir/Sentinel_02 > /dev/null 2>&1
		rm -f $MainDir/Sentinel_02_CSV.csv > /dev/null 2>&1
		rm -f $MainDir/Sentinel_04_CSV.csv > /dev/null 2>&1
		rm -f $MainDir/Sentinel_05_CSV.csv > /dev/null 2>&1
		rm -f $MainDir/Exec_Sentinel_02.sh > /dev/null 2>&1
		
		$ECHO"各キーワードに対する検索が完了しました。"
		# Sentinel_05_CSV.csvの8カラム目が2以上の場合、その件数分だけPythonスクリプトを生成し、実行させる。
		# Pythonスクリプト側は、ハッシュ値を確認し、同一の場合、スキップさせる。
		Sentinel03Dir=$MainDir"/Sentinel_03"
		mkdir -p $Sentinel03Dir > /dev/null 2>&1
		$TEST$? -ne 0 && exit 99
		
		gawk -f AWKScripts/GeneSentinel_01.awk -v Mode=Sentinel_03 -v GeneMercariMode=$Args_01 $MainDir/Sorted_Result_Sentinel_05_CSV.csv
		$TEST$? -ne 0 && exit 99
		
		rm -f LOCKFILE_*.lock > /dev/null 2>&1
		$ECHO"各キーワードに対する検索を実施します・・・"
		rm -f $Sentinel03Dir/BitPanel_*.txt > /dev/null 2>&1
		
		sh $MainDir/Supervisor_Sentinel_03.sh
		$TEST$? -ne 0 && exit 99
		
		rm -rf $Sentinel03Dir > /dev/null 2>&1
		rm -f $MainDir/*.txt > /dev/null 2>&1
		rm -f $MainDir/*.sh > /dev/null 2>&1
		cat $MainDir/Result_Sentinel_06_CSV.csv | \
		sort -t ',' -k 1n,1 -k 11n,11 | \
		uniq > $MainDir/Sorted_Result_Sentinel_06_CSV.csv
		
		rm -f $MainDir/Sorted_Result_Sentinel_05_CSV.csv
		rm -f $MainDir/Result_Sentinel_06_CSV.csv
		
		$ECHO"各キーワードに対する検索が完了しました。"
		;;
	"1")
		awk -f AWKScripts/AdjustCSV_06.awk $MainDir/Sentinel_02_CSV.csv > $MainDir/Sorted_Result_Sentinel_06_CSV.csv
		rm -f $MainDir/Sentinel_02_CSV.csv > /dev/null 2>&1
		;;
esac

# --------------------------------------------------------------------------------------------------------------

rm -f $MainDir/Sentinel_Bit.txt > /dev/null 2>&1
SRS06="$MainDir/Sorted_Result_Sentinel_06_CSV.csv"
Hash_SRS06="$MainDir/Hash_SRS06.txt"
test -f $SRS06
$TEST$? -ne 0 && exit 99
sha512sum $SRS06 > $Hash_SRS06

WorksDir=$MainDir"/Works"
echo "WorksDir : "$WorksDir
mkdir -p $WorksDir > /dev/null 2>&1
$TEST$? -ne 0 && exit 99

WorksTSVDir=$WorksDir"/TSV"
echo "WorksTSVDir : "$WorksTSVDir
mkdir -p $WorksTSVDir > /dev/null 2>&1
$TEST$? -ne 0 && exit 99

WorksHTMLDir=$WorksDir"/HTML"
echo "WorksHTMLDir : "$WorksHTMLDir
mkdir -p $WorksHTMLDir > /dev/null 2>&1
$TEST$? -ne 0 && exit 99

WorksExhibition_InfoTSV_Dir=$WorksDir"/Exhibition_InfoTSV"
echo "WorksExhibition_InfoTSV_Dir : "$WorksExhibition_InfoTSV_Dir
mkdir -p $WorksExhibition_InfoTSV_Dir > /dev/null 2>&1
$TEST$? -ne 0 && exit 99

WorksExhibition_InfoIMG_Dir=$WorksDir"/Exhibition_InfoIMG"
echo "WorksExhibition_InfoIMG_Dir : "$WorksExhibition_InfoIMG_Dir
mkdir -p $WorksExhibition_InfoIMG_Dir > /dev/null 2>&1
$TEST$? -ne 0 && exit 99

cut -f 3 -d ',' $MainDir/Sorted_Result_Sentinel_06_CSV.csv | \
sort | \
uniq | \
awk -f AWKScripts/MKDIR.awk -v WorksDir=$WorksTSVDir | \
sh | \
awk -f AWKScripts/MKDIR_RC_CNT.awk
$TEST$? -ne 0 && exit 99

cut -f 3 -d ',' $MainDir/Sorted_Result_Sentinel_06_CSV.csv | \
sort | \
uniq | \
awk -f AWKScripts/MKDIR.awk -v WorksDir=$WorksHTMLDir | \
sh | \
awk -f AWKScripts/MKDIR_RC_CNT.awk
$TEST$? -ne 0 && exit 99

cut -f 3 -d ',' $MainDir/Sorted_Result_Sentinel_06_CSV.csv | \
sort | \
uniq | \
awk -f AWKScripts/MKDIR.awk -v WorksDir=$WorksExhibition_InfoTSV_Dir | \
sh | \
awk -f AWKScripts/MKDIR_RC_CNT.awk
$TEST$? -ne 0 && exit 99

cut -f 3 -d ',' $MainDir/Sorted_Result_Sentinel_06_CSV.csv | \
sort | \
uniq | \
awk -f AWKScripts/MKDIR.awk -v WorksDir=$WorksExhibition_InfoIMG_Dir | \
sh | \
awk -f AWKScripts/MKDIR_RC_CNT.awk
$TEST$? -ne 0 && exit 99

# 並列処理数を確定させる。
# 原則は、物理コア数+1とする。
awk -f AWKScripts/ParallelCnt.awk
Parallel=$?

# スクレイピング用のコマンドを発行し、xargsで実行する
sha512sum -c --quiet $Hash_SRS06 > /dev/null 2>&1
$TEST$? -ne 0 && exit 99

awk -f AWKScripts/GeneScraper.awk $SRS06 | \
xargs -P $Parallel -r -I{} sh -c '{}'

# メルカリは、検索ページはseleniumが必要になる（curlでは403になる）が、
# 個別ページはふつうにcurlで取得出来る
find $WorksTSVDir -type f | \
egrep '.tsv$' | \
awk '{print "awk -f AWKScripts/AddFileInfo.awk "$0;}' | \
xargs -P $Parallel -r -I{} sh -c '{}' | \
# https://qiita.com/miminashi/items/a0d22ada995b8bbdff16
# sortコマンドやcolumnコマンドで区切り文字にタブ文字を指定する - Qiita
sort -t "`printf '\t'`" -k 5,5 -k 8n,8 -k 7n,7 | \
uniq | \
awk -f AWKScripts/ADD_OutHTML.awk > $MainDir/Component.tsv

awk -f AWKScripts/GeneCURL.awk $MainDir/Component.tsv > $MainDir/GeneShell.sh

sh $MainDir/GeneShell.sh
$TEST$? -ne 0 && exit 99
rm -f $MainDir/GeneShell.sh > /dev/null 2>&1

cut -f 9 $MainDir/Component.tsv | \
awk -f AWKScripts/GeneScraper_Deux.awk | \
xargs -P $Parallel -r -I{} sh -c '{}'

egrep -r '^商品添付イメージ' $WorksExhibition_InfoTSV_Dir/*/*.tsv | fgrep -q "https"
$TEST$? -ne 0 && $ECHO"商品添付イメージファイルが存在しませんでした。" && $ECHO"EM_TM System Shell terminated normally." && exit 0;

egrep -H -r '^商品添付イメージ' $WorksExhibition_InfoTSV_Dir/*/*.tsv | \
fgrep -h "https" | \
awk '{sub(":","\t"); print;}' | \
awk -f AWKScripts/GeneCURL_Deux.awk > $MainDir/GeneShell.sh

sh $MainDir/GeneShell.sh
$TEST$? -ne 0 && exit 99
rm -f $MainDir/GeneShell.sh > /dev/null 2>&1

$ECHO"EM_TM System Shell terminated normally."

exit 0

