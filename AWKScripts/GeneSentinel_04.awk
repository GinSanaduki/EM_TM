#!/usr/bin/gawk -f
# GeneSentinel_04.awk
# gawk -f AWKScripts/GeneSentinel_04.awk $MainDir/Sentinel_03_CSV.csv

# ------------------------------------------------------------------

BEGIN{
	FS = ",";
	cmd = "gawk -f AWKScripts/ReplyDirTime.awk -v Mode=02";
	while(cmd | getline MainDir){
		break;
	}
	close(cmd);
	OUTCSV = MainDir"/Sentinel_04_CSV.csv";
}

/./{
	switch($7){
		case "NOT FOUND":
			print $0",1" > OUTCSV;
			break;
		case "1":
			print "検索キーワード　：　"$1"は、検索結果が1ページのみでした。";
			print $0",1" > OUTCSV;
			break;
		case "0":
			print "検索キーワード　：　"$1"は、検索結果が2ページ以上存在します。";
			print "処理を継続します。";
			cmd = "sh ./ShellScripts/SearchNextPage.sh \""$4"\"";
			while(cmd | getline NextPageNumber){
				break;
			}
			close(cmd);
			print $0","NextPageNumber > OUTCSV;
			break;
		default:
			exit 99;
	}
}

