#!/bin/sh
# DelLocker.sh
# sh ./ShellScripts/DelLocker.sh

# 1. 秒単位で取得
# 2. シンボリックリンクのみを取得
# 3. ロックファイルを取得
# 4. gawkのmktime関数に合わせる
# 5. UNIX時間に換算
# 6. 180秒経過していた場合、当該ファイルを削除する。
#     何もしない場合のため、NULLコマンドを最初に含んでいる。
ls -l --full-time | \
grep ^l | \
fgrep -e "LOCKFILE_01.lock" -e "LOCKFILE_02.lock" -e "LOCKFILE_03.lock" | \
awk '{gsub("-"," ",$6); $7 = substr($7,1,8); gsub(":"," ",$7); print $6" "$7" "$9;}' | \
gawk '{print mktime($1" "$2" "$3" "$4" "$5" "$6)" "$7}' | \
awk 'BEGIN{NowTime = systime();print ":";}{GapTime = NowTime - $1; if(GapTime >= 180){print "rm -f "$2" > /dev/null 2>&1";}}' | \
sh

exit 0

