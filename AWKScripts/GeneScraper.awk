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
	# HTMLの検出された商品部を切り出す
	GS_CMD_02 = "awk -f AWKScripts/HTML_Scraping/Victorinox_01.awk";
	# 先頭に存在する連続する半角スペース、またはタブ文字を除去
	GS_CMD_03 = "awk -f AWKScripts/HTML_Scraping/Victorinox_02.awk";
	# 空行を除外
	GS_CMD_04 = "awk -f AWKScripts/HTML_Scraping/Victorinox_03.awk";
	# 「><」、「</div>」に改行を入れる
	GS_CMD_05 = "awk -f AWKScripts/HTML_Scraping/Victorinox_04.awk";
	GS_CMD_06 = GS_CMD_04;
	# 不要部分を除去
	GS_CMD_07 = "fgrep -v -f GrepKeyWord/Pattern_01.txt";
	# 売買契約が締結済みか否かを判断
	GS_CMD_08 = "awk -f AWKScripts/HTML_Scraping/Victorinox_05.awk";
	# タグ部分の調整
	GS_CMD_09 = "awk -f AWKScripts/HTML_Scraping/Victorinox_06.awk";
	# 4行をタブ区切りで1行にする
	GS_CMD_10 = "awk -f AWKScripts/HTML_Scraping/Victorinox_07.awk";
	# サニタイズされたHTML特殊文字をデコードする
	GS_CMD_11 = "awk -f AWKScripts/HTML_Scraping/HTML_Special_Charactor_Decoder.awk";
	# 金額の不要部分を削除
	GS_CMD_12 = "gawk -f AWKScripts/HTML_Scraping/Victorinox_08.awk";
	
	GS_CMD_02_04 = GS_CMD_02" | "GS_CMD_03" | "GS_CMD_04;
	GS_CMD_05_07 = GS_CMD_05" | "GS_CMD_06" | "GS_CMD_07;
	GS_CMD_08_10 = GS_CMD_08" | "GS_CMD_09" | "GS_CMD_10;
	GS_CMD_11_12 = GS_CMD_11" | "GS_CMD_12;
	
	GS_CMD_02_10 = GS_CMD_02_04" | "GS_CMD_05_07" | "GS_CMD_08_10;
	GS_CMD_02_12 = GS_CMD_02_10" | "GS_CMD_11_12;
	
}

