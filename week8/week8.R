library(tidyverse)
library(DESeq2)
library(broom)
setwd("~/qb25-answers/week8/")

#Exercise 1
# Step 1.1
metadata_df <- read_delim("gtex_metadata_downsample.txt") %>% 
  column_to_rownames(var = "SUBJECT_ID")

counts_df <- read_delim("gtex_whole_blood_counts_downsample.txt") %>% 
  column_to_rownames(var = "GENE_NAME")

# check dfs
counts_df[1:5, 1:5]
metadata_df[1:5, ]


# Step 1.2

# double check sample names between two objects

confirm_sample_names <- (colnames(counts_df) == rownames(metadata_df))
confirm_sample_names[FALSE]


# create DESeq2 dataset
dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = counts_df,
  colData = metadata_df,
  design = ~ SEX + AGE + DTHHRDY
)



# Step 1.3

# variance stabilziing transformation
vsd <- vst(dds)


# PCA plots
plotPCA(vsd, intgroup = c("DTHHRDY"))
ggsave("death_PCA.png")

plotPCA(vsd, intgroup = "SEX")
ggsave("sex_PCA.png")

plotPCA(vsd, intgroup = "AGE")
ggsave("age_PCA.png")

# answers
# the first two PCs explain 55% of the variance

# PC1 seems to be largely associated with the manner of death of the donor, and
# a much smaller association with the age of the donors
# PC2 doesn't seem to associate with any of the covariates


# 2.1

# homemade deg analysis
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()
vsd_df <- bind_cols(metadata_df, vsd_df)


#WASH7P Differential analysis
m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df) 
 

m1 %>% 
  summary %>% 
  tidy()

# WASH7P does not show signficiant evidence of sex-differential expression. The beta coefficient for 
# sex covariate in the lm of WASH7P is 0.279, which does not allow us to reject the 
# null hypothesis and conclude that the beta coefficient is not equal to 0 for sex.

#SLC25A47
m2 <- lm(
  formula = SLC25A47 ~ 1 + DTHHRDY + AGE + SEX, data = vsd_df
)

m2 %>% 
  summary() %>% 
  tidy()

# SLC25A47 has male-biased expression, with males having 0.518 more normalized counts
# of SLC25A47 than females. The Beta coefficient for SEX (female = 0, male = 1) is 0.518
# with a p value of 0.0257, allowing us to reject the null hypothesis that the 
# beta coefficent is zero and conclude that there is indeed male biased expression of SLC25A47

dds <- DESeq(
  object = dds
)

res <- results(
  dds,
  name = "SEX_male_vs_female"
) %>% 
  as_tibble(rownames = "GENE_NAME")


res %>% 
  filter(padj < 0.1) %>% 
  nrow()

# 262 genes are differentially expressed at FDR of 10%

gene_locations <- read_delim("gene_locations.txt")

deg_chrom <- gene_locations %>% 
  right_join(
    res,
    by = join_by("GENE_NAME" == "GENE_NAME")
  ) %>% 
  arrange(padj)

# Genes on the Y chromosome are more strongly upregulated in males, as expected, since usually only phenotypic males have a Y chromosome
# and phenotypic females typically lack a Y chromosome
# The genes that that are more strongly upregulated in females are found on the X chromosome. This make sense because
# most females have 2 X chromosomes whereas males only have 1 X chromosome. Any X genes that are expressed from
# or modulated by the inactive X chromosome will result in higher gene expression in females vs males.

deg_chrom %>% 
  filter(GENE_NAME == "WASH7P")
# WASH7P does not have a significant log fold change, with q-value of 0.899, consistent with the single hypothesis test
# done previously

# deg_chrom %>% 
deg_chrom %>% 
  filter(GENE_NAME == "SLC25A47")
# SLC24A47 has male-biased expression wtih a significant log2 fold change of 3.06, with a very small q-value, consistent wit hte single hypothesis
# test done previously

# Reflection

# The analysis at 10% FDR cutoff shows a trade-off between type I/false positive error rate and 
# type II/false negative rate. Setting a 1% FDR lowers the amount of false positives, but alos increases the chance for false negatives
# Setting a 20% FDR lowers the amount of false negatives, but raises the chance of false positives, equal to 20%.
# Higher sample size can increase the power, and lower the rate of false negatives. However, it shouldn't affect the proportion of false positives.
# Higher effect size can also make it less likely to get false negatives, since for each hypothesis
# you are more likely to be a signficiant DEG

deth <- results(
  dds,
  name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes"
)

deth_df <- deth %>% 
  as_tibble(
    rownames = "GENE_NAME"
  ) %>% 
  arrange(padj) %>% 
  filter(padj < 0.1)

nrow(deth_df)

# 16069 genes differentially expressed due to death classification at 10% FDR


# PERMUTATION, Step 2.5

permuted_metadata <- metadata_df

permuted_metadata$SEX <- sample(metadata_df$SEX, replace = FALSE)

nrow(permuted_metadata)

merge(
  metadata_df,
  permuted_metadata,
  by = "row.names"
) %>% 
  filter(SEX.x == SEX.y) %>% 
  nrow()
# looks like it successfully shuffled

dds_permuted <- DESeq2::DESeqDataSetFromMatrix(
  countData = counts_df,
  colData = permuted_metadata,
  design = ~ SEX + AGE + DTHHRDY
)

res_permutated <- DESeq(
  dds_permuted
)

actual_res_permutated <- results(
  res_permutated,
  name = "SEX_male_vs_female"
) %>% 
  as_tibble(
    rownames = "GENE_NAME"
  )

actual_res_permutated %>% 
  filter(padj < 0.1) %>% 
  nrow()
# 46 significant genes with FDR 10%

res %>% 
  filter(padj < 0.1) %>% 
  nrow()

# 46 hits in the permuted analysis vs
# 262 hits in the real analysis. 
# this shows that the FDR threshold controls pretty well the number
# of false postiives. The permuted analysis suggests that the
# out of the 262 hits that pass 10% FDR, around 47 of them were false positives,
# which somewhat matches the 10% FDR cutoff (46/262 = 17%). This shows that the
# controlling the FDR is pretty accurate way of limiting false positives.

# Exercise 3

res %>% 
  mutate(
    signifcant = case_when(
      padj < 0.1 & abs(log2FoldChange) > 1 ~ TRUE,
      TRUE ~ FALSE
    ),
    "-log10(padj)" = -log(padj, 10)
  ) %>% 
  ggplot(
    aes(x = log2FoldChange, y = `-log10(padj)`, color = signifcant)
  ) +
  geom_point()
ggsave("volcano_plot.png")




