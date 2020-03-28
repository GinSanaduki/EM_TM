#!/bin/sh
# Sweeper.sh
# sh ./ShellScripts/Sweeper.sh

sh ./ShellScripts/Chrome_Killer.sh

rm -f LOCKFILE_*.lock > /dev/null 2>&1

# awk側で/dev/nullを生成したら、強制終了と出たので、回避するために呼び元から/dev/nullに突っ込んでいる
ps -aux | \
fgrep "GeneLocker.sh" | \
grep -v grep | \
awk 'BEGIN{print ":";}{print "kill -9 "$2;}' | \
sh > /dev/null 2>&1

exit 0

