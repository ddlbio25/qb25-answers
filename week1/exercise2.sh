#!/bin/bash

# Get hg16 chromosome sizes
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg16/bigZips/hg16.chrom.sizes

#remove unmmaped contigs
grep -v _ hg16.chrom.sizes > hg16-main.chrom.sizes

# make 1 Mb windows

bedtools makewindows -g hg16-main.chrom.sizes -w 1000000 > hg16-1mb.bed
wc -l hg16-1mb.bed

# create hg16-kc.bed with one transcript per gene
mv ~/Downloads/hg16-kc.tsv .
cut -f1-3,5 hg16-kc.tsv > hg16-kc.bed
head hg16-kc.bed

#count how many genes are in each interval

# -c flag counts the number of hits for each window in -a that intersect the transcripts in -b
bedtools intersect -c -a hg16_1mb.bed -b hg16_kc.bed > hg16-kc-count.bed


# Calculation of genes

# How many genes are  in hg19
wc -l hg19-kc.bed
# 80270 hg19-kc.bed


# how many genes in hg19 but not in hg16
bedtools intersect -v -a hg19-kc.bed -b hg16-kc.bed | wc -l
   # 42717

# why are some genes in hg19 but notin hg16
# Answer: The genes in hg19 but not in hg16 were not annotated when hg16 was assembled
# but ended up being annotated when hg19 came about

# How many genes are  in hg16
wc -l hg16-kc.bed
# 21365 hg16-kc.bed

# How many genes in hg16 but not in hg19
bedtools intersect -v -a hg16-kc.bed -b hg19-kc.bed | wc -l
# 3460

# Why are some genes in hg16 but not in hg19

# these could have been misannotated genes in hg16 that were corrected and removed for hg19