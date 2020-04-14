#!/usr/bin/gawk -f
# MKDIR_RC_CNT.awk
# awk -f AWKScripts/MKDIR_RC_CNT.awk

BEGIN{
	Bit = 0;
}

{
	$0 = $0 + 0;
	if($0 > 0){
		Bit++;
		exit;
	}
}

END{
	if(Bit == 0){
		exit;
	} else {
		exit 99;
	}
}

