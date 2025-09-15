#!/bin/bash

mv ~/Downloads/nhek.bed .
mv ~/Downloads/nhlf.bed .

grep 1_Active nhek.bed > nhek-active.bed
wc -l nhek-active.bed
# 14013 nhek-active.bed
grep 12_Repressed nhek.bed > nhek-repressed.bed
wc -l nhek-repressed.bed
# 32314 nhek-repressed.bed
grep 1_Active nhlf.bed > nhlf-active.bed
wc -l nhlf-active.bed
#    14888 nhlf-active.bed
grep 12_Repressed nhlf.bed > nhlf-repressed.bed
wc -l nhlf-repressed.bed
#    34469 nhlf-repressed.bed

# test if nhek-active.bed and nhek-repressed.bed regions are mutually exclusive
bedtools intersect -a nhek-active.bed -b nhek-repressed.bed
# `zero output`
# test nhlf
bedtools intersect -a nhlf-active.bed -b nhlf-repressed.bed
# `zero output`
# therefore the regions in each tissue are mutually exclusive

# First command, regions active in both nhek and nhlf
bedtools intersect -wa -a nhek-active.bed -b nhlf-active.bed | wc -l
# 12174 features

# Second command, regions active in nhek but not in nhkf
bedtools intersect -v -a nhek-active.bed -b nhlf-active.bed | wc -l 
# 2405

# 12174 + 2405 = 14579 features
# the two outputs do not add up to 14013

# to restrict to one feature no matter how many overlaps, use -u flag
bedtools intersect -u -wa -a nhek-active.bed -b nhlf-active.bed | wc -l
# 11608
# 11608 + 2405 = 14013 features in total in nhek-active.bed

# -f and -F flags

# -f 1
bedtools intersect -a nhek-active.bed -b nhlf-active.bed -f 1 | head
# genome browser, first feature
# I see SYF2, and NHLF 1_Active_Promoter_Region entirely overlaps the active promoter region in NHEK

# -F 1
bedtools intersect -a nhek-active.bed -b nhlf-active.bed -F 1 | head
# genome browser, first feature
# I see that the strech of NHEK active promoter completely overlaps the active promoter region in NHLF

# -F 1 -f 1
bedtools intersect -a nhek-active.bed -b nhlf-active.bed -F 1 -f 1 | head
# genome browser, first feature
# I see C1orf159, and that the 1_Active_Promoter region in both NHEK and NHLF are identical in terms of
# length and position


# Construct three bedtools intersect commands to 
# identify the following types of regions.
# Use UCSC Genome Browser to save one PDF image for each of the three types of regions. 
# Describe the chromatin state across all nine condition

# Active in NHEK, Active in NHLF
# -u for only one feature per overlap and -wa to avoid splitting up regions into different features
bedtools intersect -a nhek-active.bed -b nhlf-active.bed -u -wa | head
# look in genome browser at first feature
# chromatin state across most tissues appears to be active promoters, with some regions
# acting as enhancers or weak promoters in a few tissues

# active in NHEK, repressed in NHLF
bedtools intersect -a nhek-active.bed -b nhlf-repressed.bed -u -wa | head
# look in genome browser at first feature
# gene PRKCZ-DT
# depending on tissue, chromatin is either an active promoter or is repressed,
# with one tissue having a poised promoter
# one tissue annotated as an enhancer
# one having an insulator, etc.

# Repressed in NHEK, Repressed in NHLF
bedtools intersect -a nhek-repressed.bed -b nhlf-repressed.bed -u -wa | head
# look in genome browser at first feature
# no gene appears to be annotated
# chromatin across most tissues are either heterochromatic or are repressed
# insulator or weak enhancer at far boundary

