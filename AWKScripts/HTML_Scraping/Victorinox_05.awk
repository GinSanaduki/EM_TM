#!/usr/bin/gawk -f
# Victorinox_05.awk
# gawk -f AWKScripts/HTML_Scraping/Victorinox_05.awk

/^<a href=/{
	print;
	# 1�s��ǂ݂��A�u<div>SOLD�v���ۂ��𔻒f
	getline NextSTDIN;
	if(NextSTDIN != "<div>SOLD"){
		# �����_�񂪖������̏ꍇ�A<div>SOLD�����݂��Ȃ����߁A����p�Ɂu<div>NO CONTRACT�v������
		print "<div>NO CONTRACT";
	}
	print NextSTDIN;
	next;
}

{
	print;
}

