#!/usr/bin/gawk -f
# GeneScraper.awk
# awk -f AWKScripts/GeneScraper.awk $SRS06

BEGIN{
	FS = ",";
	CommonCMD();
}

{
	GS_CMD_01 = "cat \""$5"\"";
	GS_CMD_01_12 = GS_CMD_01" | "GS_CMD_02_12;
	split($5,OutPathArrays,"/");
	sub(/.html$/,".tsv",OutPathArrays[4]);
	OutPath = OutPathArrays[1]"/"OutPathArrays[2]"/Works/TSV/"OutPathArrays[3]"/"OutPathArrays[4];
	GS_CMD_00 = GS_CMD_01_12" > \""OutPath"\"";
	GS_CMD_00_Hash = "sha512sum "OutPath" > "OutPathArrays[1]"/"OutPathArrays[2]"/Works/TSV/"OutPathArrays[3]"/HashList_"OutPathArrays[4]".txt";
	GS_CMD_00 = GS_CMD_00" && "GS_CMD_00_Hash;
	delete OutPathArrays;
	print GS_CMD_00;
}

function CommonCMD(){
	# HTML�̌��o���ꂽ���i����؂�o��
	GS_CMD_02 = "awk -f AWKScripts/HTML_Scraping/Victorinox_01.awk";
	# �擪�ɑ��݂���A�����锼�p�X�y�[�X�A�܂��̓^�u����������
	GS_CMD_03 = "awk -f AWKScripts/HTML_Scraping/Victorinox_02.awk";
	# ��s�����O
	GS_CMD_04 = "awk -f AWKScripts/HTML_Scraping/Victorinox_03.awk";
	# �u><�v�A�u</div>�v�ɉ��s������
	GS_CMD_05 = "awk -f AWKScripts/HTML_Scraping/Victorinox_04.awk";
	GS_CMD_06 = GS_CMD_04;
	# �s�v����������
	GS_CMD_07 = "fgrep -v -f GrepKeyWord/Pattern_01.txt";
	# �����_�񂪒����ς݂��ۂ��𔻒f
	GS_CMD_08 = "awk -f AWKScripts/HTML_Scraping/Victorinox_05.awk";
	# �^�O�����̒���
	GS_CMD_09 = "awk -f AWKScripts/HTML_Scraping/Victorinox_06.awk";
	# 4�s���^�u��؂��1�s�ɂ���
	GS_CMD_10 = "awk -f AWKScripts/HTML_Scraping/Victorinox_07.awk";
	# �T�j�^�C�Y���ꂽHTML���ꕶ�����f�R�[�h����
	GS_CMD_11 = "awk -f AWKScripts/HTML_Scraping/HTML_Special_Charactor_Decoder.awk";
	# ���z�̕s�v�������폜
	GS_CMD_12 = "gawk -f AWKScripts/HTML_Scraping/Victorinox_08.awk";
	
	GS_CMD_02_04 = GS_CMD_02" | "GS_CMD_03" | "GS_CMD_04;
	GS_CMD_05_07 = GS_CMD_05" | "GS_CMD_06" | "GS_CMD_07;
	GS_CMD_08_10 = GS_CMD_08" | "GS_CMD_09" | "GS_CMD_10;
	GS_CMD_11_12 = GS_CMD_11" | "GS_CMD_12;
	
	GS_CMD_02_10 = GS_CMD_02_04" | "GS_CMD_05_07" | "GS_CMD_08_10;
	GS_CMD_02_12 = GS_CMD_02_10" | "GS_CMD_11_12;
	
}

