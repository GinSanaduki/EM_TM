#!/bin/sh
# Command_Check.sh
# sh ./ShellScripts/Command_Check.sh
# bashdb ./ShellScripts/Command_Check.sh

# https://qiita.com/richmikan@github/items/bd4b21cf1fe503ab2e5c
# どの環境でも使えるシェルスクリプトを書くためのメモ ver4.60 - Qiita

. ./ShellScripts/BuiltIn_Check.sh

which which >/dev/null 2>&1 || {
	which() {
		command -v "$1" 2>/dev/null |
		awk 'match($0,/^\//){print; ok=1;}END {if(ok==0){print "which: not found" > "/dev/stderr"; exit 1}}'
	}
}

Which_Check() {
	case "$1" in
		"gawk")
			Error_Messages_01="このスクリプトは$1が必要です。"
			Error_Messages_02="$1をインストールしてから、実行してください。"
			Error_Messages_03="INSTALL : sudo apt-get install $1"
			;;
		"python")
			Error_Messages_01="このスクリプトは$1""3が必要です。"
			Error_Messages_02="$1をインストールしてから、実行してください。"
			Error_Messages_03="INSTALL : sudo apt-get install $1""3.7"
			;;
		"pip")
			Error_Messages_01="このスクリプトは$1が必要です。"
			Error_Messages_02="$1をインストールしてから、実行してください。"
			Error_Messages_03="INSTALL : sudo apt-get install python-$1"
			;;
		"google-chrome")
			Error_Messages_01="このスクリプトはGoogle Chromeが必要です。"
			Error_Messages_02="Google Chromeをインストールしてから、実行してください。"
			Error_Messages_03="INSTALL : sudo dpkg -i google-chrome-stable_current_amd64.deb"
			;;
		"chromedriver")
			;;
		*)
			$ECHO"INVALID ARGUMENT."
			exit 99
	esac
	which $1 > /dev/null 2>&1
	RetCode_Which_Check=$?
	case "$RetCode_Which_Check" in
		"0")
			return 0
			;;
		*)
			case "$1" in
				*)
					$PRINTF'%s\n%s\n%s\n' "$Error_Messages_01" "$Error_Messages_02" "$Error_Messages_03"
					;;
			esac
	esac
	exit 99
}

Freeze_Check() {
	case "$1" in
		"selenium")
			Error_Messages_01="このスクリプトは$1が必要です。"
			Error_Messages_02="$1をインストールしてから、実行してください。"
			Error_Messages_03="INSTALL : pip install $1"
			;;
		*)
			$ECHO"INVALID ARGUMENT."
			exit 99
	esac
	pip freeze | fgrep -q "$1=="
	RetCode_Freeze_Check=$?
	case "$RetCode_Freeze_Check" in
		"0")
			return 0
			;;
		*)
			case "$1" in
				*)
					$PRINTF'%s\n%s\n%s\n' "$Error_Messages_01" "$Error_Messages_02" "$Error_Messages_03"
					;;
			esac
	esac
	exit 99
}

Version_Check() {
	case "$1" in
		"google-chrome")
			;;
		"chromedriver")
			;;
		*)
			$ECHO"INVALID ARGUMENT."
			exit 99
	esac
	COMMAND_VERSION=`$1 --version`
	case "$1" in
		"google-chrome")
			REQUIRED_VERSION="Google Chrome 71.0.3578.80 "
			;;
		"chromedriver")
			REQUIRED_VERSION="ChromeDriver 2.46.628388 (4a34a70827ac54148e092aafb70504c4ea7ae926)"
			;;
	esac
	$TEST "$COMMAND_VERSION" = "$REQUIRED_VERSION"
	RetCode_Version_Check=$?
	case "$RetCode_Version_Check" in
		"0")
			return 0
			;;
		*)
			case "$1" in
				"google-chrome")
					$ECHO"Google Chromeのバージョンを、Google Chrome 71.0.3578.80にしてください。"
					;;
				"chromedriver")
					$ECHO"Chrome Driverのバージョンを、ChromeDriver 2.46.628388にしてください。"
					;;
			esac
	esac
	exit 99
}

Which_Check gawk
Which_Check python

# https://qiita.com/t-iguchi/items/7b664e8d7fe4bb3646ae
# wsl+ubuntu+python+djangoの開発環境を構築する - Qiita
# git clone https://github.com/yyuu/pyenv.git ~/.pyenv
# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
# echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# source ~/.bashrc
# pyenv
# sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev
# sudo apt-get install libffi-dev
# pyenv install 3.7.6
# pyenv global 3.7.6
# pip install --upgrade pip
# pip install pipenv
# python -V
# →Python 3.7.6

Which_Check pip
Freeze_Check selenium
Which_Check google-chrome

# https://qiita.com/ma-tsu-ba-ra/items/25e404387d1726d21cc9
# WindowsとWSLでHeadless Chromeを使ってみよう！ - Qiita
# https://www.slimjet.com/chrome/google-chrome-old-version.php
# Download older versions of Google Chrome for Windows, Linux and Mac

# sudo apt-get install libappindicator1 libappindicator3-1 fonts-liberation

# sudo dpkg -r google-chrome-stable
# wget "https://www.slimjet.com/chrome/download-chrome.php?file=files%2F71.0.3578.80%2Fgoogle-chrome-stable_current_amd64.deb"
# mv "download-chrome.phpfile=files%2F71.0.3578.80%2Fgoogle-chrome-stable_current_amd64.deb" "google-chrome-stable_current_amd64.deb"
# sudo apt --fix-broken install
# sudo apt-get install libappindicator1 libappindicator3-1 fonts-liberation
# sudo dpkg -i google-chrome-stable_current_amd64.deb
# rm -f google-chrome-stable_current_amd64.deb > /dev/null 2>&1
# google-chrome --version
# 半角スペースが末尾についている点に注意
# →Google Chrome 71.0.3578.80 

# 以下の設定をしないと、スクリーンショットが文字化けしていた・・・
# https://qiita.com/snaka/items/db422cff582c7c39eb02
# Ubuntu に apt-get で Chrome 59 インストールして --headless してみた - Qiita

# 日本語関連パッケージインストール
# sudo apt-get -y install language-pack-ja-base language-pack-ja
# システムの文字セットを日本語に変更
# sudo update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
# source /etc/default/locale
# echo $LANG
# フォントパッケージのインストール
# sudo apt-get install fonts-ipafont-gothic fonts-ipafont-mincho

# インストール結果確認
# fc-list
# （IPAゴシック, IPA明朝などが表示される）

Version_Check google-chrome

# https://chromedriver.storage.googleapis.com/index.html?path=2.46/
# https://loumo.jp/wp/archive/20181009120041/
# WSL Ubuntu 18.04 に Headless Chrome を入れて Ruby で操作する | Lonely Mobiler
# curl -O https://chromedriver.storage.googleapis.com/2.46/chromedriver_linux64.zip
# unzip chromedriver_linux64.zip
# rm -f chromedriver_linux64.zip > /dev/null 2>&1
# chmod +x chromedriver
# sudo cp -p chromedriver /usr/local/bin/chromedriver
# rm -f chromedriver > /dev/null 2>&1
# which chromedriver
# →/usr/local/bin/chromedriver
# chromedriver --version
# →ChromeDriver 2.46.628388 (4a34a70827ac54148e092aafb70504c4ea7ae926)

# Updateしてしまうと、勝手に最新版にupdateされてしまうので、
# sudo dpkg -r google-chrome-stableを打ってやり直してください。

Which_Check chromedriver
Version_Check chromedriver

exit 0

