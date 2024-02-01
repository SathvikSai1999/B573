
pwd
cd ~

#remove any previous half downloaded files, if any because of previous unsuccessful attempts (for recursive removal withouit confirmation use "-rf")
rm -rf Informtics_573

#create a new directory 
mkdir Informatics_573

##using wget command along "accept command enusres, only files with the following file names/file extensions get downloaded
#using wget command along "reject command enusres, files with the following file names/file extensions dont get downloaded
#   P.S. make sure to reject 11,12,13,14,15,16,17,18,19 chromosomers also
#-noparent command prevents ascending of -recursive command to parent directories and no directories" and 
#-nodirectory command prevents the creation of nested directories i.e., creation of directorial hierarchy wilen downloading files.
#rejects files with the following file names/file extensions 
wget -r -np -nd -A "chr1*.fa.gz" --reject="chr1.fa.gz,chr10*,chr11*,chr12*,chr13*,chr14*,chr15*,chr16*,chr17*,chr18*,chr19*" https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/

#Unzip all of the downloaded chromosome 1 assemblies
gunzip chr1*.fa.gz

# Step 5: Create a new empty file called "data_summary.txt"
touch data_summary.txt

# Step 6: Append detailed information to "data_summary.txt" (file name, size, permissions)
ls -l chr1*.fa >> data_summary.txt

# Step 7: Append the first 10 lines of each chromosome 1 assembly to "data_summary.txt"
for file in chr1*.fa; do
    echo "=== $file ===" >> data_summary.txt
    head -n 10 "$file" >> data_summary.txt
done

# Step 8: Append the name of each assembly and the total number of lines to "data_summary.txt"
for file in chr1*.fa; do
    echo "=== $file ===" >> data_summary.txt
    wc -l "$file" >> data_summary.txt
done

chmod +x HW1_SSA_Informatics_573.sh
