#!/bin/sh
# Command_Check.sh
# sh ./ShellScripts/Command_Check.sh

# https://qiita.com/richmikan@github/items/bd4b21cf1fe503ab2e5c
# どの環境でも使えるシェルスクリプトを書くためのメモ ver4.60 - Qiita

which which >/dev/null 2>&1 || {
	which() {
		command -v "$1" 2>/dev/null |
		awk 'match($0,/^\//){print; ok=1;}END {if(ok==0){print "which: not found" > "/dev/stderr"; exit 1}}'
	}
}

which gawk > /dev/null 2>&1
RetCode=$?
test $RetCode -ne 0 && echo "このスクリプトはgawkが必要です。"
test $RetCode -ne 0 && echo "gawkをインストールしてから、実行してください。"
test $RetCode -ne 0 && echo "INSTALL : sudo apt-get install gawk" && exit 99

which python > /dev/null 2>&1
RetCode=$?
test $RetCode -ne 0 && echo "このスクリプトはpython3が必要です。"
test $RetCode -ne 0 && echo "pythonをインストールしてから、実行してください。"
test $RetCode -ne 0 && echo "INSTALL : sudo apt install python3.7" && exit 99

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

which python > /dev/null 2>&1
RetCode=$?
test $RetCode -ne 0 && echo "このスクリプトはpipが必要です。"
test $RetCode -ne 0 && echo "pipをインストールしてから、実行してください。"
test $RetCode -ne 0 && echo "INSTALL :  sudo apt install python-pip" && exit 99

pip freeze | fgrep -q "selenium=="
RetCode=$?
test $RetCode -ne 0 && echo "このスクリプトはseleniumが必要です。"
test $RetCode -ne 0 && echo "seleniumをインストールしてから、実行してください。"
test $RetCode -ne 0 && echo "INSTALL :  pip install selenium" && exit 99

which google-chrome > /dev/null 2>&1
RetCode=$?
test $RetCode -ne 0 && echo "このスクリプトはGoogle Chromeが必要です。"
test $RetCode -ne 0 && echo "Google Chromeをインストールしてから、実行してください。"
test $RetCode -ne 0 && echo "INSTALL :  sudo dpkg -i google-chrome-stable_current_amd64.deb" && exit 99

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

CHROME_VERSION=`google-chrome --version`
REQUIRED_VERSION="Google Chrome 71.0.3578.80 "
test "$CHROME_VERSION" = "$REQUIRED_VERSION"
RetCode=$?
test $RetCode -ne 0 && echo "Google Chromeのバージョンを、Google Chrome 71.0.3578.80にしてください。" && exit 99

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

which chromedriver > /dev/null 2>&1
RetCode=$?
test $RetCode -ne 0 && echo "このスクリプトはChrome Driverが必要です。"
test $RetCode -ne 0 && echo "Chrome Driverをインストールしてから、実行してください。"
test $RetCode -ne 0 && echo "INSTALL :  curl -O https://chromedriver.storage.googleapis.com/2.46/chromedriver_linux64.zip"
test $RetCode -ne 0 && echo "INSTALL :  unzip chromedriver_linux64.zip"
test $RetCode -ne 0 && echo "INSTALL :  rm -f chromedriver_linux64.zip > /dev/null 2>&1"
test $RetCode -ne 0 && echo "INSTALL :  chmod +x chromedriver"
test $RetCode -ne 0 && echo "INSTALL :  sudo cp -p chromedriver /usr/local/bin/chromedriver"
test $RetCode -ne 0 && echo "INSTALL :  rm -f chromedriver > /dev/null 2>&1" && exit 99

DRIVER_VERSION=`chromedriver --version`
DRIVER_REQUIRED_VERSION="ChromeDriver 2.46.628388 (4a34a70827ac54148e092aafb70504c4ea7ae926)"

test "$DRIVER_VERSION" = "$DRIVER_REQUIRED_VERSION"
RetCode=$?
test $RetCode -ne 0 && echo "Chrome Driverのバージョンを、ChromeDriver 2.46.628388にしてください。" && exit 99

exit 0

