#!/usr/bin/gawk -f
# Victorinox_09.awk
# awk -f AWKScripts/HTML_Scraping/Victorinox_09.awk

# ���i�̏ڍׂ𒊏o
/<meta name="viewport" content=".*?">/,/<div class="default-container ">/{
	print;
}

# ���i�̏ڍׂ𒊏o
/<section class="item-box-container l-single-container">/,/<div class="item-button-container clearfix">/{
	print;
}

# ���i�ɑ΂���R�����g�̂����𒊏o
/<div class="item-detail-message">/,/<ul class="nav-item-link-prev-next clearfix">/{
	print;
}

