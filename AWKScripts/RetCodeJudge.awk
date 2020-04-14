#!/usr/bin/gawk -f
# RetCodeJudge.awk
# awk -f AWKScripts/RetCodeJudge.awk

{
	mat_Col_01 = match($1,/[[:digit:]]/);
	mat_Col_02 = match($2,/[[:digit:]]/);
	mat_Col_03 = match($3,/[[:digit:]]/);
	if(mat_Col_01 <= 0 || mat_Col_02 <= 0 || mat_Col_03 <= 0){
		exit 99;
	}
	$1 = $1 + 0;
	$2 = $2 + 0;
	$3 = $3 + 0;
	if($1 == 255 && $2 == 255 && $3 == 255){
		exit 255;
	}
	if($1 == 0 || $1 == 255){
		if($2 == 0 || $2 == 255){
			if($3 == 0 || $3 == 255){
				exit;
			}
		}
	}
	exit 99;
}

