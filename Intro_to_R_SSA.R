getwd()
setwd("/Users/sathviksai/Downloads") 
#alternately we can use   list.files(pattern = "*.fa") 
list.files(pattern = "chr1_GL383518v1_alt.fa")  # list.files(pattern = "chr1_*.fa") why isnt his working??

#seqinr package
#Exploratory data analysis and data visualization for biological sequence (DNA and protein) data. 
BiocManager::install(c("seqinr", "Biostrings"))
library(seqinr)
library(Biostrings)

my_fasta <- read.fasta(file = "chr1_GL383518v1_alt.fa", seqtype = c("DNA"))

#EDA
head(my_fasta)

summary(my_fasta)
length(my_fasta) #1 i.e., only 1 sequence

class(my_fasta) # list
nchar(my_fasta) #gives how long the sequence is 

strtrim(my_fasta, 30)

------------#TASK1------------------------------------------

letter_10 <- my_fasta[[1]][10]   #1st sequence letter_10
print(paste("The 10th letter is:", letter_10))
letter_758 <- my_fasta[[1]][758]   #1st sequence letter_758
print(paste("The 758th letter is:", letter_758))

------------#TASK2------------------------------------------
sequence <- my_fasta[[1]]
#Using Biostrings
dna_sequences <- DNAStringSet(sequence)
rev_comp <- reverseComplement(dna_sequences)
reverse_complement()
rev_comp

#verification on an example
#seq = "GATCATTAG"
#dna_seq <- DNAStringSet(seq)
#rev_comp <- reverseComplement(dna_seq)
#rev_comp #CTAATGATC

--------#TASK3---------------------------------------------
sequence <- my_fasta[[1]]
seq_length <- length(sequence) #182439
num_kilobases <- ceiling(seq_length / 1000) 

# Create an empty list to store base frequencies of each kilobase
kilobase_counts <- list()

# Loop to calculate counts for each kilobase
for (i in 1:num_kilobases) {
  start_index <- (i - 1) * 1000 + 1
  end_index <- i * 1000 
  kilobase_counts[[i]] <- table(sequence[start_index:end_index])
}

print(kilobase_counts)

-------#TASK 444.A--------------------------------------------------
#Create lists to store the counts for each base
counts_A <- list()
counts_C <- list()
counts_G <- list()
counts_T <- list()


#Extracting counts for each base in the First kilobase
counts_A[[1]] <- kilobase_counts[[1]]['a'] 
counts_C[[1]] <- kilobase_counts[[1]]['c'] 
counts_G[[1]] <- kilobase_counts[[1]]['g'] 
counts_T[[1]] <- kilobase_counts[[1]]['t'] 

#Converting lists of counts to vectors
counts_A <- unlist(counts_A)
counts_C <- unlist(counts_C)
counts_G <- unlist(counts_G)
counts_T <- unlist(counts_T)

## Creating the data frame
df <- data.frame(
  kilobase = 1,
  A = counts_A,
  C = counts_C,
  G = counts_G,
  T = counts_T
)

df


-------#TASK 4.B--------------------------------------------------
# Create lists to store the counts for each base
counts_A <- list()
counts_C <- list()
counts_G <- list()
counts_T <- list()

# Extract counts for each base across kilobases
for (i in 1:num_kilobases) {
  counts_A[[i]] <- kilobase_counts[[i]]['a'] 
  counts_C[[i]] <- kilobase_counts[[i]]['c'] 
  counts_G[[i]] <- kilobase_counts[[i]]['g'] 
  counts_T[[i]] <- kilobase_counts[[i]]['t'] 
}

#Converting lists of counts to vectors
counts_A <- unlist(counts_A)
counts_C <- unlist(counts_C)
counts_G <- unlist(counts_G)
counts_T <- unlist(counts_T)

#Creating data frame
df_OG <- data.frame(
  kilobase = 1:num_kilobases,
  A = counts_A,
  C = counts_C,
  G = counts_G,
  T = counts_T
)

df_OG #Viewing the data frame
tail(df_OG)

-------#TASK 4.C  & 4.D--------------------------------------------------

df_OG$total_bp <- rowSums(df_OG[, 2:5])  # Calculate sums across columns 2 to 5

#save as new df called df_OG_modified
df_OG_modified <- df_OG  
tail(df_OG_modified)

-------#TASK4.E--------------------------------------------------

#1.Q: What is the expected sum for each list?
#1.A: 1000 is the expected sum for each list except for the last one since the total elements in our fasta file is #182439 and 182439 is not exactly divisible. by 1000

#2.Q: Are there any lists whose sums are not equal to the expected value?
#2.A: the last list 183 kilobasepairs sum is 439, since the total elements in our fasta file is #182439
  
#3.Q:Provide a general explanation for the differences in your expected results and your observed results.
#3.A: we expect every list to contain 1000 since we spli the fats file into units of 1000 each, but since the total elements in our fasta file is #182439
# we have only 439n elements in the last list
--------------------------------------------------------------

#questions
#nchar() and length() difference ; they are giving different results on the fasta file
#table()and count() difference while retrieving base composition
#complememnt() and rev() not working ; not sure why




