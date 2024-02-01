# B573
Assignments of the course  "Programming for Science Informatics - Spring 2024"

Interesting observations from Assignmemnt1:
1. usage of the following command funnily downloaded all the chromosomes starting with1 for instance 11,12,13,14,....19 etc. So, I had to mention them too in reject section in the code
wget -r -np -nd -A 'chr1*' --reject="chr1.fa.gz" https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/

2. Surprisingly, the reject first , accept later pattern of command is faster while executing wget than accept first and reject later command


