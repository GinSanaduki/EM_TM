#!/usr/bin/gawk -f
# Victorinox_11.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_11.awk

/<meta property="og:type" content=".*?">/,/<meta name="twitter:description" content=".*?">/{
	next;
}

/<body class="">/,/<section class="item-box-container l-single-container">/{
	next;
}

/^<div$/,/^>$/{
	next;
}

/^\{$/{
	next;
}

/^\}$/{
	next;
}


{
	gsub("</div>","\n</div>");
	print;
}

