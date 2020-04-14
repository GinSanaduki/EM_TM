#!/usr/bin/gawk -f
# Victorinox_16.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_16.awk

/^<th>ブランド/,/^<th>発送日の目安/{
	gsub("</th></td>", "\t");
	gsub("</th><td>", "\t");
	gsub("</td>","");
	sub("<th>","");
}

/^<p class="item-description-inner">/{
	sub(/^<p class="item-description-inner">/,"詳細説明\t");
	sub(/<\/p>$/,"");
}

/^<table class="item-detail-table">/{
	sub(/<table class="item-detail-table">/,"");
	sub(/<\/td>$/,"");
	sub("<i class=\"icon-good\">","出品者評価\t良い\t");
	sub("<i class=\"icon-normal\">","出品者評価\t普通\t");
	sub("<i class=\"icon-bad\">","出品者評価\t悪い\t");
	gsub("</i>","");
	gsub("<span>","");
	gsub("</span>","\n");
}

/^<th>カテゴリー<\/th>/{
	sub(/<div>/,"メインカテゴリ\t");
	gsub(/<div class="item-detail-table-sub-category"><i class=".*?"><\/i>/,"サブカテゴリ\t");
	gsub("<a href=\"","\n");
}

{
	print;
}

# <div class="item-detail-message">から最終判定用にセンチネル行を立てる
END{
	print "<SENTINEL>";
}

