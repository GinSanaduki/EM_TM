#!/bin/sh
# LimitCount.awk
# awk -f AWKScripts/LimitCount.awk

{
	$0 = $0 + 0;
	if($0 == 0){
		exit 99;
	}
	if(systime() > $0){
		exit 99;
	} else {
		exit;
	}
}

