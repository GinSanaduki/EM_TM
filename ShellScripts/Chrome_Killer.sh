#!/bin/sh
# Chrome_Killer.sh
# sh ./ShellScripts/Chrome_Killer.sh

ps -aux | fgrep "/usr/bin/google-chrome" | awk '{print "kill -9 "$2}' | sh > /dev/null 2>&1
ps -aux | fgrep "/usr/local/bin/chromedriver" | awk '{print "kill -9 "$2}' | sh > /dev/null 2>&1
ps -aux | fgrep "chrome" | fgrep -v "chromedriver" | awk '{print "kill -9 "$2}' | sh > /dev/null 2>&1
ps -aux | fgrep "Monitor.sh" | fgrep -v "chromedriver" | awk '{print "kill -9 "$2}' | sh > /dev/null 2>&1
# https://qastack.jp/ubuntu/201303/what-is-a-defunct-process-and-why-doesnt-it-get-killed
# <defunct>プロセスとは何ですか。なぜ強制終了されないのですか？
ps -ef | fgrep "defunct" | grep -v grep | awk '{print "kill -9 "$2" "$3;}' | sh > /dev/null 2>&1

rm -rf /tmp/.org.chromium.Chromium.* > /dev/null  2>&1

exit 0

