#!/bin/bash
samtools index -M *.bam
for bam in BYxRM_bam/*.bam; do samtools view -c $bam; done > read_counts.txt
for file in BYxRM_bam/*.bam; do echo $file; done > bamListFile.txt


freebayes -f ../../week2/genomes/sacCer3.fa -L bamListFile.txt --genotype-qualities -p 1 > unfiltered.vcf 

vcffilter -f "QUAL > 20" -f "AN > 9" unfiltered.vcf > filtered.vcf

# this command doesnt work on my machine and I'm too lazy to figure out how to download it
vcfallelicprimitives -kg filtered.vcf > decomposed.vcf

vcfbreakmulti decomposed.vcf > biallelic.vcf

# question 1.1
# the read counts for each bam file are as follows
# 669548
# 656245
# 708732
# 797385
# 602404
# 610360
# 803554
# 713726
# 816639
# 620829