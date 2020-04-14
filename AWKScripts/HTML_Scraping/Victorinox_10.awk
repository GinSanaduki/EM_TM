#!/usr/bin/gawk -f
# Victorinox_10.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_10.awk

/<!DOCTYPE html>/,/<meta name="viewport" content=".*?">/{
	next;
}

/<meta property="al:ios:app_name".*?">/,/<meta name="twitter:site".*?">/{
	next;
}

/<meta name="twitter:image" content="https:\/\/static.mercdn.net\/item\/detail\/orig\/photos\/.*?">/,/<link rel="alternate" href=".*?" \/>/{
	next;
}

/<i class=".*?"><\/i> <span>カテゴリーから探す<\/span>/,/<a href=".*?">ブランド一覧<\/a>/{
	next;
}

/<i class="icon-balloon"><\/i>/,/<\/html>/{
	next;
}

{
	print;
}

