#!/usr/bin/gawk -f
# AddFileInfo.awk
# awk -f AWKScripts/AddFileInfo.awk

(FNR == 1){
	split(FILENAME,FnameArrays,"/");
}

{
	# 1 : URL
	# 2 : 売買契約成立状態
	# 3 : 掲示タイトル
	# 4 : 掲載者提示価格
	# 5 : 検索キーワード（半角スペース変換後）
	# 6 : TSVパス
	# 7 : TSV行番号
	# 8 : ページ番号
	TSVPathNumber = FnameArrays[length(FnameArrays)];
	sub(/^.*?_page_/,"",TSVPathNumber);
	sub(/\.tsv$/,"",TSVPathNumber);
	print $0"\t"FnameArrays[5]"\t"FILENAME"\t"FNR"\t"TSVPathNumber;
}

