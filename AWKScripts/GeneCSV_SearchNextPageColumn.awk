#!/usr/bin/gawk -f
# GeneCSV_SearchNextPageColumn.awk
# awk -f AWKScripts/GeneCSV_SearchNextPageColumn.awk $MainDir/Sorted_Result_Exec_SearchRightArrow.csv

# ------------------------------------------------------------------

BEGIN{
	FS = ",";
	cmd = "gawk -f AWKScripts/ReplyDirTime.awk -v Mode=02";
	while(cmd | getline MainDir){
		break;
	}
	close(cmd);
	ResultCSV = MainDir"/Sentinel_02_CSV.csv";
	ContinueCnt = 1;
	ErrorBit = 0;
}

/./{
	switch($8){
		case "NOT FOUND":
			print $0",1" > ResultCSV;
			break;
		case "1":
			print "検索キーワード　：　"$2"　は、検索結果が1ページのみでした。";
			print $0",1" > ResultCSV;
			break;
		case "0":
			print "検索キーワード　：　"$2"　は、検索結果が2ページ以上存在します。";
			print "処理を継続します。";
			cmd = "sh ./ShellScripts/SearchNextPage.sh \""$5"\"";
			while(cmd | getline NextPageNumber){
				break;
			}
			close(cmd);
			print $0","NextPageNumber > ResultCSV;
			ContinueCnt++;
			break;
		default:
			ErrorBit++;
			exit 99;
	}
}

END{
	if(ErrorBit != 0){
		exit 99;
	}
	if(ContinueCnt == 1){
		exit 1;
	}
}

