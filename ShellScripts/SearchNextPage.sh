#!/bin/sh
# SearchNextPage.sh
# sh ./ShellScripts/SearchNextPage.sh hoge.html
# bashdb ./ShellScripts/SearchNextPage.sh hoge.html

. ./ShellScripts/BuiltIn_Check.sh

ls "$1" > /dev/null 2>&1
RetCode=$?
case "$RetCode" in
	"0")
		;;
	*)
		$ECHO"1"
		exit 99
esac

$TEST-s "$1"
RetCode=$?
case "$RetCode" in
	"0")
		;;
	*)
		$ECHO"1"
		exit 99
esac

fgrep -B 1 "<i class=\"icon-arrow-double-right\"></i>" "$1" | \
fgrep -q "<a href="
RetCode=$?
case "$RetCode" in
	"0")
		;;
	*)
		$ECHO"1"
		exit 99
esac

# URLはマルチバイト文字ではなくURLエンコードされているため、マルチバイト用にgawkを指定する必要はない。
fgrep -B 1 "<i class=\"icon-arrow-double-right\"></i>" "$1" | \
fgrep "<a href=" | \
awk '{gsub(" ",""); print;}' | \
awk '{match($0,/&amp;keyword=/); print substr($0, 1, RSTART - 1);}' | \
awk '{print substr($0,26);}'

exit 0

