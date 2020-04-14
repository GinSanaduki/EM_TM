#!/bin/sh
# GeneLocker_02.sh
# sh ./ShellScripts/GeneLocker_02.sh

. ./ShellScripts/BuiltIn_Check.sh

# 復帰値が1：ロック（1）の取得に成功
# 復帰値が2：ロック（2）の取得に成功
# 復帰値が3：ロック（3）の取得に成功
# 復帰値が4：ロックの取得に失敗

# https://heartbeats.jp/hbblog/2013/10/atomic03.html
# そのファイル、安全にロックできていますか？（アトミックなファイル操作：後編） - インフラエンジニアway - Powered by HEARTBEATS
LOCK_FILE_01="LOCKFILE_01.lock"
LOCK_FILE_02="LOCKFILE_02.lock"
LOCK_FILE_03="LOCKFILE_03.lock"

# 1. 秒単位で取得
# 2. シンボリックリンクのみを取得
# 3. ロックファイルを取得
# 4. gawkのmktime関数に合わせる
# 5. UNIX時間に換算
# 6. 150秒経過していた場合、当該ファイルを削除する。
#     何もしない場合のため、NULLコマンドを最初に含んでいる。
ls -l --full-time | \
grep ^l | \
fgrep -e "$LOCK_FILE_01" -e "$LOCK_FILE_02" -e "$LOCK_FILE_03" | \
awk '{gsub("-"," ",$6); $7 = substr($7,1,8); gsub(":"," ",$7); print $6" "$7" "$9;}' | \
gawk '{print mktime($1" "$2" "$3" "$4" "$5" "$6)" "$7}' | \
awk 'BEGIN{NowTime = systime(); print ":";}{GapTime = NowTime - $1; if(GapTime >= 150){print "rm -f "$2";}}' | \
sh  > /dev/null 2>&1

ln -s $$ $LOCK_FILE_01 > /dev/null 2>&1
test $? -eq 0 && exit 1

ln -s $$ $LOCK_FILE_02 > /dev/null 2>&1
test $? -eq 0 && exit 2

ln -s $$ $LOCK_FILE_03 > /dev/null 2>&1
test $? -eq 0 && exit 3

exit 4

