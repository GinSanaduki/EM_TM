#!/usr/bin/gawk -f
# ADD_OutHTML.awk
# awk -f AWKScripts/ADD_OutHTML.awk

BEGIN{
	FS = "\t";
}

{
	split($6,Arrays,"/");
	Arrays[4] = "HTML";
	sub(/\.tsv$/,"",Arrays[length(Arrays)]);
	Arrays[length(Arrays)] = Arrays[length(Arrays)]"_"$7".html";
	HashFile = "HashList_"Arrays[length(Arrays)]".txt";
	OutHTML_Path = Arrays[1]"/"Arrays[2]"/"Arrays[3]"/"Arrays[4]"/"Arrays[5]"/"Arrays[6];
	OutHashFile_Path = Arrays[1]"/"Arrays[2]"/"Arrays[3]"/"Arrays[4]"/"Arrays[5]"/"HashFile;
	delete Arrays;
	print $0"\t"OutHTML_Path"\t"OutHashFile_Path;
}

