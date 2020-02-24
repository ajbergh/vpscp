# vpscp
Veeam Parallel scp Script

Usage: vpscp.sh <source dir> <target server> <target dir> <number of threads> 		
Example: vpscp.sh /docs server2 /docs 8												
																				    	
This script is designed to increase file copy throughput when syncing large			
file tree structures.																
																					
Performance Tuning: On destination host edit MaxSessions in /etc/ssh/sshd_config 	
(specifies the maximum number of open sessions permitted per network connection		
the default is set at 10) - Increase to thread count max. 							
																					
Known issues: 																		
Any files with spaces or special characters will be skipped							
Job could fail if too many threads are used			
