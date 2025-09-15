#!/bin/bash

mv ~/Downloads/snps-chr1.bed .

wc -l snps-chr1.bed

# Question, find the gene on chr1 with the most snps
bedtools intersect -a hg19-kc.bed -b snps-chr1.bed -c | sort -t$'\t' -k5 -r -n | head -n 1
# chr1	245912648	246670581	ENST00000490107.6_7	5445
# The gene above has the most snps, 5445

# Question, Describe the gene
# GENCODE ID ENST00000490107.6_7
# gene name SMYD3
# position: hg19 chr1:245,912,648-246,670,581 CURRENTLY ZERO BASED AT START
# size 757,933 bp
# exon count 12
# this gene has the most SNPs because it has extremely long introns, where SNPs can appear without changing
# the protein's coding sequence and (hopefully) without changing overall phenotype

#SNPs outside vs inside a gene

#subset with set seed
bedtools sample -n 20 -seed 42 -i snps-chr1.bed > snps-subset-chr1.bed
bedtools sort -i snps-subset-chr1.bed > snps_sorted.bed
bedtools sort -i hg19-kc.bed > hg19-kc_sorted.bed
bedtools closest -d -t first -a snps_sorted.bed -b hg19-kc_sorted.bed > snps_inside_outside.bed

head -n 1 snps_inside_outside.bed
# chr1	3810505	3810506	rs78397137	0	+	chr1	3805696	3816836	ENST00000361605.4_7	0
# column 11, 0 if snp is inside, not 0 if snp is outside

cut -f 11 snps_inside_outside.bed | sort | uniq -c
#   15 0
#    1 15658
#    1 1664
#    1 22944
#    1 4407
#    1 6336

# how many snps are inside a gene?
# 15 snps

# how many snps are outside a gene?
# 5 snps

# Range of distances for the ones outside a gene
# Range = max - min
# range = 15658 - 1664
# range = 13994 bps