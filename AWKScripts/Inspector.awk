#!/usr/bin/gawk -f
# Inspector.awk
# awk -f AWKScripts/Inspector.awk -v Mode=Check Define_SearchWord.conf
# gawk -f AWKScripts/Inspector.awk -v Mode=Convert Define_SearchWord.conf

BEGIN{
	ErrorBit = 0;
	switch(Mode){
		case "Check":
			Cnt = 0;
			break;
		case "Convert":
			break;
		default:
			ErrorBit++;
			exit 99;
	}
}

/./{
	switch(Mode){
		case "Check":
			Cnt++;
			next;
	}
	# �����^�u�́A���p�X�y�[�X�ɕϊ�
	gsub("\011"," ");
	# 32�����Ő؂�
	$0 = substr($0,1,32);
	# �J���}�́A���̎��_�Ńp�[�Z���g�G���R�[�f�B���O����
	gsub("\054","%2C");
	print;
}

END{
	if(ErrorBit != 0){
		exit 99;
	}
	if(Mode == "Convert"){
		exit;
	}
	if(Cnt > 0){
		exit;
	} else {
		exit 1;
	}
}

