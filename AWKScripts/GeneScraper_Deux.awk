#!/usr/bin/gawk -f
# GeneScraper_Deux.awk
# awk -f AWKScripts/GeneScraper_Deux.awk

{
	OutFile = $0;
	sub("/HTML/","/Exhibition_InfoTSV/",OutFile);
	sub(/\.html/,".tsv",OutFile);
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_02.awk "$0" | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_03.awk | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_10.awk | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_11.awk | ");
	printf("%s", "fgrep -v -f ./GrepKeyWord/Pattern_02.txt | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_03.awk | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_12.awk | ");
	printf("%s", "egrep -v -f ./GrepKeyWord/Pattern_03.txt | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_13.awk | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_14.awk | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_15.awk | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_16.awk | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_17.awk | ");
	printf("%s", "sed -e \\\047$d\\\047 | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_03.awk | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_18.awk | ");
	printf("%s", "uniq | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_19.awk | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_20.awk | ");
	printf("%s", "egrep -v -f ./GrepKeyWord/Pattern_04.txt | ");
	printf("%s", "awk -f AWKScripts/HTML_Scraping/Victorinox_21.awk > ");
	printf("%s\n", OutFile);
}

