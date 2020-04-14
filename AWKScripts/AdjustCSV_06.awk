#!/usr/bin/gawk -f
# AdjustCSV_06.awk
# awk -f AWKScripts/AdjustCSV_06.awk

BEGIN{
	FS = ",";
	Cnt = 1;
}

{
	print  $0","Cnt",1";
	Cnt++;
}

