library(tidyverse)


# 3.1
# Samples 62, 24, 39, 63, 31, and 27 derive
# from the wine strain due to the high number of
# mismatches found when aligned to the reference
# genome.
# Samples 35, 23, 11, and 09 derive 
# from the lab strain because the reads align
# to the reference without mismatches.

genotypes_df <- read_delim(
  "gt_long.txt",
  delim = "\t",
  col_names = c(
    "sample",
    "chr",
    "pos",
    "genotype"
  )
)

genotypes_df %>%
  mutate(
    genotype = factor(genotype, c(0, 1))
  ) %>% 
  filter(
    sample == "A01_62",
    chr == "chrII"
  ) %>% 
  ggplot(aes(x = pos, color = genotype, fill = genotype)) +
    geom_density()

ggsave("A01_62_chrI_COs.png")

#3.2 
# I see the two telomeric ends of the chr1 are genotype 1 (alternative genotype,
# presumably the wine strain), with region flanked by the 
# two telomeric ends being genotype 0 (reference genotype or lab strain).
# The transitions represent sites of meiotic crossover

genotypes_df %>%
  mutate(
    genotype = factor(genotype, c(0, 1))
  ) %>% 
  ggplot(aes(x = pos, y = sample, color = genotype, fill = genotype)) +
  geom_tile() +
  facet_grid(
    . ~ chr,
    scales = "free_x",
    space = "free_x"
  ) +
  labs(title = "Genotype across chrs and samples") +
  xlab("pos") +
  scale_x_continuous(labels = NULL, breaks = NULL)
# ggsave(
#   "allsamples_genomewide_COs.png"
# )

