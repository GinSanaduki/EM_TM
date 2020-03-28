#!/bin/sh
# Monitor_Sub01.awk
# gawk -f AWKScripts/Monitor_Sub01.awk Sentinel_01_BitPanelArrays[i]

{
	if($0 == "99" || $0 == "09"){
		exit 99;
	} else if($0 == "0"){
		exit 1;
	} else if($0 == "00"){
		exit 2;
	} else {
		exit 99;
	}
}

