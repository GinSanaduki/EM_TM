#!/bin/sh
# ReplyProgress.awk
# awk -f AWKScripts/ReplyProgress.awk

{
	Calc = $1 / $2 * 100;
	print int(Calc + 0.5);
	exit;
}

