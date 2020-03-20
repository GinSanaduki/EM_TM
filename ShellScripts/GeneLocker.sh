#!/bin/sh
# GeneLocker.sh
# sh ./ShellScripts/GeneLocker.sh

# https://heartbeats.jp/hbblog/2013/10/atomic03.html
# そのファイル、安全にロックできていますか？（アトミックなファイル操作：後編） - インフラエンジニアway - Powered by HEARTBEATS
LOCK_FILE_01="./LOCKFILE_01.lock"
LOCK_FILE_02="./LOCKFILE_02.lock"
LOCK_FILE_03="./LOCKFILE_03.lock"

sh ./ShellScripts/DelLocker.sh

ln -s $$ $LOCK_FILE_01 > /dev/null 2>&1
RetCode=$?
test $RetCode -eq 0 && exit 1

ln -s $$ $LOCK_FILE_02 > /dev/null 2>&1
RetCode=$?
test $RetCode -eq 0 && exit 2

ln -s $$ $LOCK_FILE_03 > /dev/null 2>&1
RetCode=$?
test $RetCode -eq 0 && exit 3

exit 4

