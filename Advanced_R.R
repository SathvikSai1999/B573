# Install required packages
install.packages(c("readxl", "data.table", "ggplot2", "pheatmap"))
library(readxl)
library(data.table)
library(ggplot2)
library(pheatmap)

# 1.a. Load the data
default_path <- "/Users/sathviksai/Downloads/"
xlsx_file <- "Gene_Expression_Data.xlsx"
tsv_file <- "Sample_Information.tsv"
csv_file <- "Gene_Information.csv"

Gene_Expression_Data <- paste0(default_path, xlsx_file)
Sample_Information <- paste0(default_path, tsv_file)
Gene_Information <- paste0(default_path, csv_file)

# Read Gene_Expression_Data_xlsx file
df_xlsx <- as.data.frame(read_excel(Gene_Expression_Data))
print("Gene Expression Data DataFrame:")
print(head(df_xlsx))

# Read Sample_Information_TSV file
df_tsv <- fread(Sample_Information, sep = "\t")
print("\nSample Information DataFrame:")
print(head(df_tsv))

# Read Gene_Information_CSV file
df_csv <- read.csv(Gene_Information)
print("\nGene Information DataFrame:")
print(head(df_csv))

# 1.b. Change the sample names from the "Gene_Expression_Data.xlsx", based upon the phenotype presented in "Sample_Information.tsv"
# Extract Sample_names
Sample_names <- colnames(df_xlsx)[-1]
print("\nSample_names as List:")
print(Sample_names)

# Extract Phenotypes
phenotypes <- df_tsv$group
print("\nPhenotypes")
print(phenotypes)

# Create a renaming dictionary excluding the first entry ('Probe_ID')
mapping_dict <- setNames(phenotypes, Sample_names)

# Rename the column names in the Excel file
colnames(df_xlsx)[-1] <- mapping_dict

# Save the updated Excel file with the file path
updated_file_path <- "/Users/sathviksai/Downloads/Updated_Gene_Expression_Data.xlsx"
write.xlsx(df_xlsx, updated_file_path, row.names = FALSE)

print(head(df_xlsx))

# 1.c. Split the merged data from part c, into to 2 parts, based upon their labeled phenotype (ie. tumor or normal)
# Extract Sample_names
Sample_names <- colnames(df_xlsx)[-1]
print("\nSample_names as List:")
print(Sample_names)

# Extract column names (excluding the first column)
column_names <- colnames(df_xlsx)[-1]

# Initialize empty lists to store column indices
tumor_indices <- which(grepl("tumor", column_names))
normal_indices <- which(grepl("normal", column_names))

# Print the identified indices
print("Tumor column indices:")
print(tumor_indices)
print("Normal column indices:")
print(normal_indices)

# Use column indices to extract data from df_xlsx
df_tumor <- df_xlsx[, c(1, tumor_indices + 1)]
df_normal <- df_xlsx[, c(1, normal_indices + 1)]

print("\ndf_tumor dataset")
print(head(df_tumor))

print("\ndf_normal dataset")
print(head(df_normal))

# Save df_tumor to CSV
write.csv(df_tumor, "df_tumor.csv", row.names = FALSE)

# Save df_normal to CSV
write.csv(df_normal, "df_normal.csv", row.names = FALSE)

# 1.d Compute the average expression for all genes from the 2 data sets from part d
average_tumor_in_df_tumor <- rowMeans(df_tumor[, -1], na.rm = TRUE)
average_normal_in_df_normal <- rowMeans(df_normal[, -1], na.rm = TRUE)

# Print the results
print("Average expression for each gene in df_tumor:")
print(head(average_tumor_in_df_tumor))

print("\nAverage expression for each gene in df_normal:")
print(head(average_normal_in_df_normal))

# Save files
write.csv(average_tumor_in_df_tumor, "average_tumor_in_df_tumor.csv", row.names = FALSE)
write.csv(average_normal_in_df_normal, "average_normal_in_df_normal.csv", row.names = FALSE)

# 1.e. Determine the fold change for each Probe between the two groups ((Tumour – Control) / Control)
fold_change_probes <- (average_tumor_in_df_tumor - average_normal_in_df_normal) / average_normal_in_df_normal

# Print the results
print("Fold change for each Probe between Tumor and Normal:")
print(head(fold_change_probes))

# Save files
write.csv(fold_change_probes, paste0(default_path, "fold_change_probes.csv"), row.names = FALSE)

# 1.f. Use the data from part e and "Gene_Information.csv" to identify all genes fold change magnitude (absolute value) was greater than 5
# Load your gene information
csv_file <- paste0(default_path, "Gene_Information.csv")
df_csv <- read.csv(csv_file)

# Combine into a new DataFrame
merged_df <- cbind(df_csv, fold_change_probes)

# Save the merged DataFrame
write.csv(merged_df, "merged_data.csv", row.names = FALSE)
print(head(merged_df))

column_6 <- merged_df[, 6]
print(head(column_6))

values_greater_than_5 <- column_6[abs(column_6) > 5]
indices_greater_than_5 <- which(abs(column_6) > 5)

result <- data.frame(indices_greater_than_5, values_greater_than_5)
print(result)

# Corresponding genes for the thresholded indices
corresponding_rows <- merged_df[indices_greater_than_5, ]
corresponding_entrez_ids <- corresponding_rows$Entrez_Gene_ID
print(corresponding_entrez_ids)

# 1.g. Add a column to the result of part f to include if the gene was higher expressed in "Normal" or "Tumor" sample
new_column_values <- rep("low expression", nrow(merged_df))
new_column_values[indices_greater_than_5] <- "high expression"
merged_df$Expression_Level <- new_column_values

print(merged_df)
print("\nColumn names are:")
print(merged_df[1, ])

# 2.b. Create a histogram showing the distribution of the number of differentially expressed genes (DEGs) by chromosome
n_degs_per_chromosome <- table(merged_df$Chromosome)
hist(n_degs_per_chromosome, main = "Distribution of DEGs by Chromosome", xlab = "Number of DEGs", ylab = "Chromosome", las = 1)

# 2.c. Make another histogram showing the distribution of DEGs by chromosome segregated by sample type (Normal or Tumor)
threshold <- 5.0
tumor_sample <- merged_df[merged_df[, 6] > threshold, ]
normal_sample <- merged_df[merged_df[, 6] <= threshold, ]

DEGS_tumor <- table(tumor_sample$Chromosome)
DEGS_normal <- table(normal_sample$Chromosome)

par(mfrow = c(1, 2))
hist(DEGS_normal, main = "Normal Data", xlab = "Frequency", ylab = "Chromosome", las = 1)
hist(DEGS_tumor, main = "Tumor Data", xlab = "Frequency", ylab = "Chromosome", las = 1)

# 2.d. Create a bar chart showing the percentages of the DEGs that are upregulated (higher) in Tumor samples and down regulated (lower) in Tumor samples
upregulated_count <- nrow(tumor_sample)
downregulated_count <- nrow(normal_sample)
total <- nrow(merged_df)

upregulated_percent <- (upregulated_count / total) * 100
downregulated_percent <- (downregulated_count /