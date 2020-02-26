#!/bin/bash
#################################################################################################
#	        		Veeam Parallel scp Script					#
#			        (c)2019 adam.bergh@veeam.com					#
#												#
#  	Usage: vpscp.sh <source dir> <target server> <target dir> <number of threads> 		#
#	Example: vpscp.sh /docs server2 /docs 8							#
#												#
#	This script is designed to increase file copy throughput when syncing large		#
#	file tree structures.									#
#												#
#												#
#	Performance Tuning: On destination host edit MaxSessions in /etc/ssh/sshd_config 	#
#	(specifies the maximum number of open sessions permitted per network connection		#
#	the default is set at 10) - Increase to thread count max. 				#
#												#
#	Known issues: 										#
#	Any files with spaces or special characters will be skipped				#
#	Job could fail if too many threads are used						#
#												#	
#												#
#												#
#												#
#################################################################################################

trap ctrl_c INT

function ctrl_c() {

	echo "Canceling Job! Stopping all rsync processes"
	killall rsync
	killall scp
	killall sshpass
	exit 1

}	
	
if [ -z $1 ] || [ -z $4 ]
then

	echo "vpscp.sh (c) 2019 Veeam Software adam.bergh@veeam.com"
	echo ""
	echo "usage: vpscp.sh <source d1rectory> <target server> <target directory> <number of threads>"
	echo "This script runs parallel scp operation from source to destination"
	echo "This script is comes with not support and no warranty"
	exit
fi
 
sourcedir=$1
targetsrv=$2
targetdir=$3
threads=$4
 


dirsize=$(du -s $sourcedir | awk '{print $1}')
#dirsize=$(($dirsize+512))
gbsize=$(($dirsize/1024/1024))

echo "Total size of this copy job is $gbsize GB."
read -p "Press [Enter] key to start transfer, otherwise hit ctrl+c..."
echo ""
echo ""
echo "Starting copy at $(date +%y/%m/%d) at $(date +%H:%M:%S). Please Wait...."
#echo "Starting Copy... please wait"

#Capture Start Time of Copy
start=`date +%s`

# RSYNC DIRECTORY STRUCTURE
##############################################################
rsync -zr -f"+ */" -f"- *" $sourcedir/ $targetsrv:$targetdir/ \


# FIND ALL FILES AND PASS THEM TO MULTIPLE SCP PROCESSES
##############################################################
#cd $sourcedir  &&  find . ! -type d -print0 | xargs -0 -n1 -P$threads -I% rsync -va % $targetsrv:$targetdir/%
cd $sourcedir  &&  find . ! -type d -print0 | xargs -0 -n1 -P$threads -I% scp -o Cipher=arcfour % $targetsrv:$targetdir/% 
 

 
#Capture end time of script
end=`date +%s`
runtime=$((end-start))
throughput=$(($gbsize*1024/$runtime))

echo "#########################################################################################"
echo "Done! Copy finished at $(date +%y/%m/%d) at $(date +%H:%M:%S) - Thanks for using Veeam!"
echo "It took $runtime seconds to complete this job"
echo "Average throughput was $throughput MB/s"
echo "#########################################################################################"

exit 1




