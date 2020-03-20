#!/bin/sh
# Call_Processing_02.sh
# sh ./ShellScripts/Call_Processing_02.sh

ps -aux | fgrep chrome | fgrep -v chromedriver | grep -v grep | awk 'END{if(NR > 255){exit 255;} exit NR;}'
Retcode=$?
# ps -aux | fgrep chrome | fgrep -v chromedriver | awk '{print > /dev/stderr;}'
ps -aux | fgrep chrome | fgrep -v chromedriver

exit $Retcode

