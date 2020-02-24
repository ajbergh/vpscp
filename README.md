# vpscp
Veeam Parallel scp Script

Usage: vpscp.sh <source dir> <target server> <target dir> <number of threads> 		
Example: vpscp.sh /docs server2 /docs 8												
																				    	
This script is designed to increase file copy throughput when syncing large			
file tree structures.																																												
Known issues: 																		
Any files with spaces or special characters will be skipped							
Job could fail if too many threads are used			
