#!/usr/bin/gawk -f
# ParallelCnt.awk
# awk -f AWKScripts/ParallelCnt.awk

BEGIN{
	cmd = "uname -a";
	while(cmd | getline esc){
		break;
	}
	close(cmd);
	split(esc,escArrays);
	OS_Name = escArrays[length(escArrays)];
	if(OS_Name == "Android"){
		cmd = "cat /proc/cpuinfo | fgrep 'CPU part' | wc -l";
		while(cmd | getline PhysicalCPU){
			break;
		}
		close(cmd);
		exit PhysicalCPU - 1;
	} else {
		cmd = "cat /proc/cpuinfo | fgrep 'cpu cores' | uniq";
		while(cmd | getline PhysicalCores){
			break;
		}
		close(cmd);
		split(PhysicalCores,PhysicalCoresArrays,":");
		PhysicalCores = PhysicalCoresArrays[2];
		gsub(" ","",PhysicalCores);
		cmd = "cat /proc/cpuinfo | fgrep 'physical id' | sort | uniq | wc -l";
		while(cmd | getline PhysicalCPU){
			break;
		}
		close(cmd);
		exit PhysicalCores * PhysicalCPU + 1;
	}
}

