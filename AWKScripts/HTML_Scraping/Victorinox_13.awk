#!/usr/bin/gawk -f
# Victorinox_13.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_13.awk

BEGIN{
	ImageCnt = 1;
}

{
	Tex = "";
	Tex = $0;
}

/^<title>.*?<\/title>$/{
	sub(/^<title>/,"",Tex);
	sub(/<\/title>$/,"",Tex);
	print "HTML Title\t"Tex;
	next;
}

/^section class/,/<\/section>/{
	next;
}

/^"url": /{
	sub("url","",Tex);
	sub(":","",Tex);
	gsub("\"","",Tex);
	gsub(",","",Tex);
	print "URL\t"Tex;
	next;
}

/^"name": /{
	sub("name","",Tex);
	sub(":","",Tex);
	gsub("\"","",Tex);
	gsub(",","",Tex);
	print "商品添付イメージファイル名\t"Tex;
	next;
}

/^"priceCurrency": /{
	sub("priceCurrency","",Tex);
	sub(":","",Tex);
	gsub("\"","",Tex);
	gsub(",","",Tex);
	print "取引通貨\t"Tex;
	next;
}

/^"price": /{
	sub("price","",Tex);
	sub(":","",Tex);
	gsub("\"","",Tex);
	gsub(",","",Tex);
	print "価格\t"Tex;
	next;
}

/<span class="item-tax">/{
	sub("<span class=\"item-tax\">","",Tex);
	sub("</span>","",Tex);
	gsub(" ","",Tex);
	sub("\\(","",Tex);
	sub("\\)","",Tex);
	print "税種別\t"Tex;
	next;
}

/<span class="item-shipping-fee">/{
	sub("<span class=\"item-shipping-fee\">","",Tex);
	sub("</span>","",Tex);
	print "送料種別\t"Tex;
	next;
}

/^<img data-src=".*?" alt=".*?" class=".*?">$/{
	sub(/alt.*/,"",Tex);
	sub("<img data-src=","",Tex);
	gsub("\"","",Tex);
	print "商品添付イメージ\t"ImageCnt"\t"Tex;
	ImageCnt++;
	next;
}

# <div class="item-sold-out-badge">の場合、関係ない商品にも含まれるケースがあるので、
# 主商品にしか含まれない要素で判定している
/^<div class="item-buy-btn disabled">/{
	print "売買契約\t成立済";
	next;
}

/^<th>出品者<\/th>$/{
	next;
}

{
	print;
}

