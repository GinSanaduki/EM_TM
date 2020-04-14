#!/bin/sh
# GeneLocker_01.sh
# sh ./ShellScripts/GeneLocker_01.sh

. ./ShellScripts/BuiltIn_Check.sh

# 復帰値が0：ロックの取得に成功
# 復帰値が1：ロックの取得に失敗

# https://heartbeats.jp/hbblog/2013/10/atomic03.html
# そのファイル、安全にロックできていますか？（アトミックなファイル操作：後編） - インフラエンジニアway - Powered by HEARTBEATS
LOCK_FILE_00="LOCKFILE_00.lock"

# 1. 秒単位で取得
# 2. シンボリックリンクのみを取得
# 3. ロックファイルを取得
# 4. gawkのmktime関数に合わせる
# 5. UNIX時間に換算
# 6. 45秒経過していた場合、当該ファイルを削除する。
#     何もしない場合のため、NULLコマンドを最初に含んでいる。
ls -l --full-time | \
grep ^l | \
fgrep "$LOCK_FILE_00" | \
awk '{gsub("-"," ",$6); $7 = substr($7,1,8); gsub(":"," ",$7); print $6" "$7" "$9;}' | \
gawk '{print mktime($1" "$2" "$3" "$4" "$5" "$6)" "$7}' | \
awk 'BEGIN{NowTime = systime(); print ":";}{GapTime = NowTime - $1; if(GapTime >= 45){print "rm -f "$2";}}' | \
sh  > /dev/null 2>&1

ln -s $$ $LOCK_FILE_00 > /dev/null 2>&1
$TEST$? -eq 0 && exit 0

exit 1

