#!/usr/bin/gawk -f
# HTML_Special_Charactor_Encoder.awk
# awk -f AWKScripts/HTML_Scraping/HTML_Special_Charactor_Encoder.awk

{
	# http://www.shurey.com/js/labo/character.html
	# HTML特殊文字コード表
	# 注意すべき文字のみ対応
	
	# 小なりの記号
	gsub("<","\\&lt;");
	# 大なりの記号
	gsub(">","\\&gt;");
	# アンパサンド
	# https://stackoverflow.com/questions/17241725/sed-and-awk-escaping-ampersands
	# regex - Sed and Awk Escaping Ampersands (&) - Stack Overflow
	gsub("\\&","\\&amp;");
	# ノーブレークスペース
	gsub("\\s","\\&nbsp;");
	
	# フォントサイズの半分のスペース、
	# フォントサイズのスペースについては除外
	
	# フォントサイズ半分のダッシュ
	gsub("–","\\&ndash;");
	# フォントサイズのダッシュ
	gsub("—","\\&mdash;");
	print;
}

