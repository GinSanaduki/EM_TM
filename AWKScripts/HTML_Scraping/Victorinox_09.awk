#!/usr/bin/gawk -f
# Victorinox_09.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_09.awk

# 商品の詳細を抽出
/<meta name="viewport" content=".*?">/,/<div class="default-container ">/{
	print;
}

# 商品の詳細を抽出
/<section class="item-box-container l-single-container">/,/<div class="item-button-container clearfix">/{
	print;
}

# 商品に対するコメントのやり取りを抽出
/<div class="item-detail-message">/,/<ul class="nav-item-link-prev-next clearfix">/{
	print;
}

