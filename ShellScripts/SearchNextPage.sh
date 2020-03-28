#!/bin/sh
# SearchNextPage.sh
# sh ./ShellScripts/SearchNextPage.sh hoge.html

ls "$1" > /dev/null 2>&1
test $? -ne 0 && echo "1" && exit 99

test -s "$1"
test $? -ne 0 && echo "1" && exit 99

fgrep -B 1 "<i class=\"icon-arrow-double-right\"></i>" "$1" | \
fgrep -q "<a href="
test $? -ne 0 && echo "1" && exit 99

# URLはマルチバイト文字ではなくURLエンコードされているため、マルチバイト用にgawkを指定する必要はない。
fgrep -B 1 "<i class=\"icon-arrow-double-right\"></i>" "$1" | \
fgrep "<a href=" | \
awk '{gsub(" ",""); print;}' | \
awk '{match($0,/&amp;keyword=/); print substr($0, 1, RSTART - 1);}' | \
awk '{print substr($0,26);}'

exit 0

