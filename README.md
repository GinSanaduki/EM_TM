<p align="center">
    <a href="https://opensource.org/licenses/BSD-3-Clause"><img src="https://img.shields.io/badge/license-bsd-orange.svg" alt="Licenses"></a>
</p>

# EM_TM
Exhibition monitoring Targetting Mercari.

* Download  
https://github.com/GinSanaduki/EM_TM/releases/download/V1.0.0/EM_TM.7z  
https://github.com/GinSanaduki/EM_TM/releases/download/V1.0.0/EM_TM.zip  

# Introduction
Copyright 2020 The EM_TM Project Authors, GinSanaduki.
All rights reserved.
TB3DS Scripts provides a function to obtain a list of Exhibition monitoring Targetting Mercari.  
Works on Android(on Termux, UserLAnd, and other...) / Windows(WSL, Windows Subsystem for Linux) / UNIX(Unix-like, as *nix. Example Linux, AIX, HP-UX...) / Mac OS X.

# Needs Commands and Browser
* GAWK(the GNU implementation of the AWK programming language) version 4.0 or later.
  * Recommended version : GNU Awk 4.1.4, API: 1.1 (GNU MPFR 4.0.1, GNU MP 6.1.2) or GNU Awk 5.0.1, API: 2.0
* Python(Python is an interpreted, high-level, general-purpose programming language. Created by Guido van Rossum.)
  * Recommended version : Python 3.7.6
* pip
    * Selenium installed in pip.
    ```bash
    $ pip freeze | fgrep "selenium=="
    selenium==3.141.0
    $
    ```
* google-chrome
    * Need Version : Google Chrome 71.0.3578.80 
* chromedriver
    * Need Version : ChromeDriver 2.46.628388  

# There is also a version conflict with google chrome, which is a headless browser.
# so other than this fixed version will not work.

# Usage
* Get even screenshots in action
```bash
sh ./ShellScripts/GeneMercari.sh NORMAL
```
# It is not recommended because it takes a long time to process and the size of the file to be acquired is orders of magnitude larger.
* Get only HTML
```bash
sh ./ShellScripts/GeneMercari.sh HTML
```
# This is the recommended operating mode.

# Be sure to enter the keyword you want to search in Define_SearchWord.conf before executing.

# Licenses
This program is under the terms of the BSD 3-Clause License.  
See https://opensource.org/licenses/BSD-3-Clause.  

