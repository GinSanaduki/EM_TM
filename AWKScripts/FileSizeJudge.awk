#!/bin/sh
# FileSizeJudge.awk
# awk -f AWKScripts/FileSizeJudge.awk -v GeneMercariMode=NORMAL
# awk -f AWKScripts/FileSizeJudge.awk -v GeneMercariMode=HTML

BEGIN{
	switch(GeneMercariMode){
		case "NORMAL":
			break;
		case "HTML":
			break;
		default:
			exit 99;
	}
}

{
	gsub("python ./","");
	gsub(" ","");
	split($0,PythonScriptLines,">")
	PythonScript = PythonScriptLines[1];
	PythonMatch = match(PythonScript,/.py/);
	if(PythonMatch <= 0){
		exit 99;
	}
	# HTMLファイル名と、HTMLファイルに対するハッシュ表ファイル名を切り出す
	KeyWord = "subprocess.run(\\\"sha512sum ";
	cmd = "fgrep -q \""KeyWord"\" \""PythonScript"\"";
	RetCode = system(cmd);
	close(cmd);
	if(RetCode != 0){
		exit 99;
	}
	cmd = "fgrep \""KeyWord"\" \""PythonScript"\"";
	GrepLineArraysCnt = 1;
	HTMLBit = 0;
	ScreenShotBit = 0;
	esc = "";
	while(cmd | getline esc){
		esc_match = match(esc,/--quiet/);
		if(esc_match <= 0){
			HTML_Match = match(esc,/.html/);
			if(HTML_Match >= 1){
				HTMLBit++;
			} else {
				ScreenShotBit++;
			}
			if(HTMLBit == 1){
				GrepLineArrays[GrepLineArraysCnt] = esc;
				GrepLineArraysCnt++;
			} else if(ScreenShotBit == 1){
				GrepLineArrays[GrepLineArraysCnt] = esc;
				GrepLineArraysCnt++;
			}
			if(GrepLineArraysCnt >= 3){
				break;
			}
		}
	}
	close(cmd);
	CheckBit = 0;
	for(i in GrepLineArrays){
		GrepLine = "";
		GrepLine = GrepLineArrays[i];
		gsub(/^.*?subprocess.run\(/,"",GrepLine);
		gsub(", shell = True)","",GrepLine);
		gsub("\"","",GrepLine);
		gsub("\\\\","",GrepLine);
		gsub("sha512sum ","",GrepLine);
		gsub(" ","",GrepLine);
		split(GrepLine, GrepLines, ">");
		FileName = GrepLines[1];
		HashName = GrepLines[2];
		if(CheckBit > 0){
			RM();
		} else {
			HTML_Match = match(FileName,/.html/);
			Mode = "HTML";
			if(HTML_Match >= 1){
				Mode = "HTML";
			} else {
				if(GeneMercariMode == "HTML"){
					exit 99;
				}
				Mode = "ScreenShot";
			}
			# 対象ファイルの存在チェック
			cmd = "sha512sum -c --quiet \""HashName"\" > /dev/null 2>&1";
			RetCode = system(cmd);
			if(RetCode != 0){
				CheckBit = 99;
				RM();
			} else {
				# ファイルサイズ取得
				cmd = "ls -l \""FileName"\" | awk \047{print $5; exit;}\047";
				while(cmd | getline FileSize){
					break;
				}
				close(cmd);
				if(Mode == "HTML"){
					# HTML基準：921,600Byte（1024 * 900KB）
					RegulationFileSize = 921600;
				} else {
					# スクリーンショット基準：563,200Byte（1024 * 550KB）
					RegulationFileSize = 563200;
				}
				if(FileSize < RegulationFileSize){
					CheckBit = 99;
					RM();
				}
			}
		}
	}
	exit CheckBit;
}

function RM(){
	# 問答無用で削除
	cmd = "rm -f \""FileName"\" > /dev/null 2>&1";
	system(cmd);
	close(cmd);
	cmd = "rm -f \""HashName"\" > /dev/null 2>&1";
	system(cmd);
	close(cmd);
}

