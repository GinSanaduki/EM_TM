#!/bin/sh
# AlertMessages.awk
# gawk -f AWKScripts/AlertMessages.awk -v MESSAGE=COMP_HTML -v PAGENUMBER=PAGENUMBER -v SEARCHWORD=SEARCHWORD -v OUTFILENAME=OUTFILENAME -v HASHLIST=HASHLIST -v GENE_MERCARIMODE=NORMAL
# gawk -f AWKScripts/AlertMessages.awk -v MESSAGE=COMP_HTML -v PAGENUMBER=PAGENUMBER -v SEARCHWORD=SEARCHWORD -v OUTFILENAME=OUTFILENAME -v HASHLIST=HASHLIST -v GENE_MERCARIMODE=HTML
# gawk -f AWKScripts/AlertMessages.awk -v MESSAGE=COMP_PNG -v PAGENUMBER=PAGENUMBER -v SEARCHWORD=SEARCHWORD -v OUTFILENAME=OUTFILENAME -v HASHLIST=HASHLIST -v GENE_MERCARIMODE=NORMAL
# gawk -f AWKScripts/AlertMessages.awk -v MESSAGE=COMP_PNG -v PAGENUMBER=PAGENUMBER -v SEARCHWORD=SEARCHWORD -v OUTFILENAME=OUTFILENAME -v HASHLIST=HASHLIST -v GENE_MERCARIMODE=HTML
# gawk -f AWKScripts/AlertMessages.awk -v MESSAGE=SKIPPED -v PAGENUMBER=PAGENUMBER -v SEARCHWORD=SEARCHWORD -v OUTFILENAME_01=OUTFILENAME -v OUTFILENAME_02=OUTFILENAME -v HASHLIST_01=HASHLIST -v HASHLIST_02=HASHLIST -v GENE_MERCARIMODE=NORMAL
# gawk -f AWKScripts/AlertMessages.awk -v MESSAGE=SKIPPED -v PAGENUMBER=PAGENUMBER -v SEARCHWORD=SEARCHWORD -v OUTFILENAME_01=OUTFILENAME -v OUTFILENAME_02=OUTFILENAME -v HASHLIST_01=HASHLIST -v HASHLIST_02=HASHLIST -v GENE_MERCARIMODE=HTML

BEGIN{
	switch(GENE_MERCARIMODE){
		case "NORMAL":
			break;
		case "HTML":
			break;
		default:
			exit 99;
	}
	switch(MESSAGE){
		case "COMP_HTML":
			PageCheck();
			SWCheck();
			OFCheck();
			# 引数で渡す際には+変換後になっているため
			gsub("+", " ", SEARCHWORD);
			BuildMessages = "HTML取得が完了しました。　";
			BuildMessages = BuildMessages"取得ページ番号："PAGENUMBER", ";
			BuildMessages = BuildMessages"検索キーワード："SEARCHWORD", ";
			BuildMessages = BuildMessages"HTMLファイル："OUTFILENAME", ";
			NowTime = strftime("%Y年%m月%d日 %H時%M分%S秒", systime());
			BuildMessages = BuildMessages NowTime;
			print BuildMessages > "/dev/stderr";
			exit;
		case "COMP_PNG":
			switch(GENE_MERCARIMODE){
				case "HTML":
					exit 99;
			}
			PageCheck();
			SWCheck();
			OFCheck();
			# 引数で渡す際には+変換後になっているため
			gsub("+", " ", SEARCHWORD);
			BuildMessages = "スクリーンショット取得が完了しました。　";
			BuildMessages = BuildMessages"取得ページ番号："PAGENUMBER", ";
			BuildMessages = BuildMessages"検索キーワード："SEARCHWORD", ";
			BuildMessages = BuildMessages"スクリーンショットファイル："OUTFILENAME", ";
			NowTime = strftime("%Y年%m月%d日 %H時%M分%S秒", systime());
			BuildMessages = BuildMessages NowTime;
			print BuildMessages > "/dev/stderr";
			exit;
		case "SKIPPED":
			PageCheck();
			SWCheck();
			OFCheck_02();
			# 引数で渡す際には+変換後になっているため
			gsub("+", " ", SEARCHWORD);
			switch(GENE_MERCARIMODE){
				case "NORMAL":
					BuildMessages = "HTMLファイルとスクリーンショットファイルを取得済のため、処理をスキップします。　";
					break;
				case "HTML":
					BuildMessages = "HTMLファイルを取得済のため、処理をスキップします。　";
					break;
			}
			BuildMessages = BuildMessages"取得ページ番号："PAGENUMBER", ";
			BuildMessages = BuildMessages"検索キーワード："SEARCHWORD", ";
			BuildMessages = BuildMessages"HTMLファイル："OUTFILENAME_01", ";
			switch(GENE_MERCARIMODE){
				case "NORMAL":
					BuildMessages = BuildMessages"スクリーンショットファイル："OUTFILENAME_02", ";
					break;
			}
			NowTime = strftime("%Y年%m月%d日 %H時%M分%S秒", systime());
			BuildMessages = BuildMessages NowTime;
			print BuildMessages > "/dev/stderr";
			exit;
		default:
			exit 99;
	}
}


function PageCheck(){
	PAGENUMBER = PAGENUMBER + 0;
	if(PAGENUMBER < 1){
		exit 99;
	}
}

function SWCheck(){
	SEARCHWORD = SEARCHWORD"";
	if(SEARCHWORD == ""){
		exit 99;
	}
}

function OFCheck(){
	cmd = "sha512sum -c --quiet "HASHLIST" > /dev/null 2>&1";
	RetCmd = system(cmd);
	close(cmd);
	if(RetCmd != 0){
		exit 99;
	}
}

function OFCheck_02(){
	cmd = "sha512sum -c --quiet "HASHLIST_01" > /dev/null 2>&1";
	RetCmd = system(cmd);
	close(cmd);
	if(RetCmd != 0){
		exit 99;
	}
	switch(GENE_MERCARIMODE){
		case "HTML":
			return;
	}
	cmd = "sha512sum -c --quiet "HASHLIST_02" > /dev/null 2>&1";
	RetCmd = system(cmd);
	close(cmd);
	if(RetCmd != 0){
		exit 99;
	}
}

