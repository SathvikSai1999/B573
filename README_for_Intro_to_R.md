The following r code demonstrates how to a download file of desired format from a specific web_url and get basic insights into the desired filetype (here, "chr1_GL383518v1_alt.fa" file) 
using R Studio, even if you don't know the contents beforehand using commands like str(), head(), summary(). 
•	The str() command gives the structure of the R object created by read.fasta() ad shows many sequences are present and gives some metadata about them.
•	The head() command displays the first few lines of the FASTA file.
•	The summary() command provides basic statistics about sequence lengths within the file

In the first task we will be accessing elements within the file using nested lists i.e., [[]] 
•	For example, in order to access the 25th element within the 1st sequence we use my_fasta[[1][25]]

In the second task we will find the reverse complement of a given string  using reverseComplement() function

In the third task, we have divided the entire fasta file contents into units of 1000 and we displayed their composition (contents of ATGC in them). 
This was done by Extracting base counts for all kilobases into lists  and Converting lists to vectors for efficient data frame creation and finally, 
Creating a list that contains the number of times each letter appears in the downloaded sequence, as a function of which kilobase of the sequence we are looking at.

In the fourth task, we have converted the above results into a DataFrame and added a new column containing the sum of the base pairs for each kilobase unit. 
Finally in the comments section of the fourth task we have explained why the last list sum of base pairs is not 1000 which is bcz, the total elements in our fasta file is #182439 
but we have only 439n elements in the last list, hence the difference in expected and observed results



