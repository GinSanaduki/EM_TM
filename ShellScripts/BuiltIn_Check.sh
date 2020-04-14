#!/bin/sh
# BuiltIn_Check.sh
# . ./ShellScripts/BuiltIn_Check.sh

type builtin > /dev/null 2>&1
RetCode_builtin=$?
case "$RetCode_builtin" in
	"0")
		ECHO="builtin echo "
		PRINTF="builtin printf "
		TEST="builtin test "
		;;
	*)
		ECHO="echo "
		PRINTF="printf "
		TEST="test "
		;;
esac

#export $ECHO
#export $PRINTF
#export $TEST

