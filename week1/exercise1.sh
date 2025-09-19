#!/bin/bash

# Get hg19 chromosome sizes
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/hg19.chrom.sizes

#less
less hg19.chrom.sizes

#remove unmmaped contigs and rename chrM to chrMT
grep -v _ hg19.chrom.sizes | sed 's/M/MT/' > hg19-main.chrom.sizes

# make 1 Mb windows

bedtools makewindows -g hg19-main.chrom.sizes -w 1000000 > hg19-1mb.bed
wc -l hg19-1mb.bed
#     3114 hg19-1mb.bed

# create hg19-kc.bed with one transcript per gene
mv ~/Downloads/hg19-kc.tsv .
wc -l hg19-kc.tsv
#   80270 hg19-kc.tsv
cut -f1-3,5 hg19-kc.tsv > hg19-kc.bed
head hg19-kc.bed

#count how many genes are in each interval

# -c flag counts the number of hits for each window in -a that intersect the transcripts in -b
bedtools intersect -c -a hg19_1mb.bed -b hg19_kc.bed > hg19-kc-count.bed
wc -l hg19-kc-count.bed
# 3114 hg19-kc-count.bed