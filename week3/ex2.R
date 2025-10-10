library(tidyverse)

df_af <- read_delim("AF.txt", delim = "\n", col_names = "allele_freq")

df_dp <- read_delim("DP.txt", delim = "\n", col_names = "read_depth")

df_af %>% 
  ggplot(aes(x = allele_freq)) +
  geom_histogram(bins = 11) +
  labs(
    title = "Allele Frequencies of SNPs",
  ) +
  xlab("Allele Frequency")
  ggsave("AF.png")

#question answers

# 1.1
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

# 2.1
# This figure shows the average and median allele frequency is about 0.5.
# It looks as expected because a diploid with two different alleles for each snp
# would be expected to produce haploid sproulants that have a 50% chance
# of getting either allele.
# This is likely a normal distribution.

df_dp %>% 
  ggplot(aes(x = read_depth)) +
  geom_histogram(bins = 21) +
  labs(
    title = "Read Depths per variant per sample",
  ) +
  xlab("Read Depth") +
  xlim(0, 20)
ggsave("DP.png")

# 2.2
# The distribution of read depths is right skewed, with a mode of about 3.5. This shows that
# the majority of SNPs in the samples have read depth around 3 to 4, but some SNPs in some
# samples have very high read depths.
# This looks like a poisson distribution.

# 3.1
# Samples 62, 24, 39, 63, 31, and 27 derive
# from the wine strain due to the high number of
# mismatches found when aligned to the reference
# genome.
# Samples 35, 23, 11, and 09 derive 
# from the lab strain because the reads align
# to the reference without mismatches.

#3.2 
# I see the two telomeric ends of the chr1 are genotype 1 (alternative genotype,
# presumably the wine strain), with region flanked by the 
# two telomeric ends being genotype 0 (reference genotype or lab strain).
# The transitions represent sites of meiotic crossover

