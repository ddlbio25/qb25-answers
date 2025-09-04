#!/bin/bash

#Question 1a How many features
wc -l ce11_genes.bed
# 53935 ce11genes.bed
# 53935 features in this bed file

#Question 1b, how many features per chromosome
sort ce11_genes.bed | cut -f 1 | uniq -c
# 5460 chrI
# 6299 chrII
# 4849 chrIII
#21418 chrIV
# 12 chrM
# 9057 chrV
# 6840 chrX

#Question 1c, how many features per strand
cut -f 6 ce11_genes.bed | sort | uniq -c
# 26626 -
# 27309 +

#Question 3a
cut -f 7 GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | sort | uniq -c | sort | tail -n 3    
#  867 Lung
# 1132 Muscle - Skeletal
# 3288 Whole Blood

#Question 3b
grep RNA GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | wc -l   
#    20017

#Question 3c
    grep RNA -v GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | wc -l
#     2935

#Question 5a
grep \# -v ~/Data/References/hg38/gencode.v46.basic.annotation.gtf | cut -f 3 | sort | uniq -c
# 664771 CDS
# 865650 exon
# 63086 gene
# 107 Selenocysteine
# 64970 start_codon
# 64806 stop_codon
# 18625 transcript
# 182871 UTR

#question 5b
grep lncRNA ~/Data/References/hg38/gencode.v46.basic.annotation.gtf | cut -f 1 | sort | uniq -c

# 13469 chr1
# 6251 chr10
# 6464 chr11
# 7867 chr12
# 4405 chr13
# 5684 chr14
# 7428 chr15
# 6937 chr16
# 6720 chr17
# 4092 chr18
# 5515 chr19
# 12332 chr2
# 3961 chr20
# 3284 chr21
# 3275 chr22
# 9268 chr3
# 7677 chr4
# 8385 chr5
# 8483 chr6
# 7627 chr7
# 7598 chr8
# 5398 chr9
# 3365 chrX
# 1176 chrY
