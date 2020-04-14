#!/usr/bin/gawk -f
# ReplyMessages.awk
# gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeSkipped
# gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeSkipped_IS_255
# gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeSuccess
# gawk -f AWKScripts/ReplyMessages.awk -v Mode=JudgeFinale

{
	YYYYMMDD_HHMMSS = strftime("%Y年%m月%d日 %H時%M分%S秒",systime());
	switch(Mode){
		case "JudgeSkipped":
			RetCode = $1 + 0;
			switch(RetCode){
				case "0":
					Messages = "右記のページを取得します・・・　取得対象ページ番号："$2", 検索キーワード："$3", "YYYYMMDD_HHMMSS;
					print Messages;
					exit 2;
				case "255":
					Messages = "右記のページは既に取得済です。　取得対象ページ番号："$2", 検索キーワード："$3", "YYYYMMDD_HHMMSS;
					print Messages;
					exit 1;
				default:
					exit 99;
			}
		case "JudgeSkipped_IS_255":
			gsub("python ./","");
			gsub(/\s>.*/,"");
			Python_Check = match($0,/.py$/);
			if(Python_Check <= 0){
				exit 99;
			}
			split($0,Python_Arrays,"/");
			Page_Number = Python_Arrays[length(Python_Arrays)];
			delete Python_Arrays;
			split(Page_Number,Python_Arrays,"_");
			Page_Number = Python_Arrays[length(Python_Arrays)];
			Keyword = Python_Arrays[length(Python_Arrays) - 1];
			delete Python_Arrays;
			gsub(".py","",Page_Number);
			Messages = "右記のページは既に取得済です。　取得対象ページ番号："Page_Number", 検索キーワード："Keyword", "YYYYMMDD_HHMMSS;
			print Messages;
			exit;
		case "JudgeSuccess":
			RetCode = $1 + 0;
			switch(RetCode){
				case "0":
					Messages = "右記のページの取得が完了しました。　取得対象ページ番号："$2", 検索キーワード："$3", "YYYYMMDD_HHMMSS;
					print Messages;
					exit 1;
				default:
					Messages = "右記のページの取得に失敗しました。　取得対象ページ番号："$2", 検索キーワード："$3", "YYYYMMDD_HHMMSS;
					print Messages;
					exit 2;
			}
		case "JudgeFinale":
			NextNumber = $1 + 0;
			switch(NextNumber){
				case "1":
					Messages = "最終ページに到達しました。　取得対象ページ番号："$2", 検索キーワード："$3", "YYYYMMDD_HHMMSS;
					print Messages;
					exit 1;
				default:
					Messages = "ページ取得を継続します。　取得対象ページ番号："$1", 検索キーワード："$3", "YYYYMMDD_HHMMSS;
					print Messages;
					exit;
			}
		default:
			exit 99;
	}
}

