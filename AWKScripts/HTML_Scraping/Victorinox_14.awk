#!/usr/bin/gawk -f
# Victorinox_14.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_14.awk

/<table class="item-detail-table">/,/<\/table>/{
	if($0 == "</table>"){
		print;
	} else {
		printf("%s", $0);
	}
	next;
}

/^<p class="item-description-inner">/,/<\/p>/{
	if($0 == "</p>"){
		print;
	} else {
		printf("%s%s", $0,"<LineFeed_LF_LineFeed>");
	}
	next;
}

/class="item-button item-button-report clearfix">/,/<span>あんしん・あんぜんへの取り組み<\/span>/{
	next;
}

/<span>いいね!<\/span>/{
	getline;
	sub("<span data-num=\"like\">","");
	sub("</span>","");
	print "いいね\t"$0;
	next;
}

{
	print;
}

