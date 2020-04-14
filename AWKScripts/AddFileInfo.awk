#!/usr/bin/gawk -f
# AddFileInfo.awk
# awk -f AWKScripts/AddFileInfo.awk

(FNR == 1){
	split(FILENAME,FnameArrays,"/");
}

{
	# 1 : URL
	# 2 : �����_�񐬗����
	# 3 : �f���^�C�g��
	# 4 : �f�ڎҒ񎦉��i
	# 5 : �����L�[���[�h�i���p�X�y�[�X�ϊ���j
	# 6 : TSV�p�X
	# 7 : TSV�s�ԍ�
	# 8 : �y�[�W�ԍ�
	TSVPathNumber = FnameArrays[length(FnameArrays)];
	sub(/^.*?_page_/,"",TSVPathNumber);
	sub(/\.tsv$/,"",TSVPathNumber);
	print $0"\t"FnameArrays[5]"\t"FILENAME"\t"FNR"\t"TSVPathNumber;
}

