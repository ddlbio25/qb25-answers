#!/bin/bash

for sample in A01_01 A01_02 A01_03 A01_04 A01_05 A01_06
do
    # to use a variable, prefix it with a $
    echo "***" $sample
    #ls -l ~/Data/BYxRM/fastq/$sample.fq.gz
    bowtie2 -p 4 -x ../genomes/sacCer3 -U ~/Data/BYxRM/fastq/$sample.fq.gz > $sample.sam
    samtools sort -o $sample.bam $sample.sam
    samtools index $sample.bam
    samtools idxstats $sample.bam > $sample.idxstats

done
# Samples 1, 3, and 4 are haplotype R while samples 2, 5, and 6 
# are haplotype B on the chr1 stretch of 27000 to 32000.

# On IGV, the visualization shows many colors for mismatches
# to the reference on samples 1, 3, 4 from chr1:27000-3200 on both the 
# coverage plots and aligned reads, while samples 2, 5, and 6 don't have as many
# mismatches to the reference in this chromosome region. 
# Therefore, the reference genome for S. cerevisiae sacCer3 is based on haplotype B.