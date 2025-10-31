library(tidyverse)
library(matrixStats)

# norm_read_counts <- read_tsv(
#   "norm_readcounts_data/read_matrix.tsv",
#   skip = 1,
#   col_names = c(seq(1, 21, 1))
# ) %>%
#   select(-1) %>%
#   as.matrix()
#

# Exercise 1
norm_read_counts <- read.table(
  "norm_readcounts_data/read_matrix.tsv",
) %>% 
  as.matrix()

sample_names <- read_tsv(
  "norm_readcounts_data/read_matrix.tsv",
  col_names = seq(1, 21, 1)
) %>% 
  head(1) %>% unlist()



norm_read_counts_500 <- norm_read_counts[order(rowSds(norm_read_counts), decreasing = TRUE), ]

norm_read_counts_500 <- norm_read_counts_500[1:500, ]

pca_500 <- prcomp(t(norm_read_counts_500))
pca_500$x
summary(pca_500)

#Step 1.3
sample_names <- base::colnames(norm_read_counts_500)
pca_df <- cbind(
  sample_names,
  pca_500$x[, 1],
  pca_500$x[, 2]
) %>% 
  as_tibble() %>% 
  rename(
    sample_name = sample_names,
    pc1 = V2,
    pc2 = V3
  ) %>% 
  mutate(
    tissue = str_split_i(string = sample_name, pattern = "_", i = 1),
    replicate = str_split_i(string = sample_name, pattern = "_", i = 2)
  )

pca_df %>% 
  ggplot(
    aes(x = pc1, y = pc2, color = tissue, shape = replicate)
  ) +
  geom_point(size = 3) +
  theme(
    axis.text.y = element_blank(),
    axis.text.x = element_blank()
  )
ggsave("week7_pca_plot_unfixed.png")


# fix mislabel
sample_names
sample_names[11] <- "Fe_Rep2"
sample_names[14] <- "LFC.Fe_Rep2"
sample_names

fixed_norm_read_counts_500 <- norm_read_counts_500

base::colnames(fixed_norm_read_counts_500) <- sample_names

# make bar chart of PC variance amount
pc_variation <- tibble(
  pc = 1:21,
  sd = pca_500$sdev
) %>% 
  mutate(
    norm_var = sd^2 / sum(sd^2)
  )

pc_variation %>% 
  ggplot(aes(x = pc, y = norm_var)) +
  geom_line() +
  labs(
    title = "Scree Plot",
    x = "Principal Component",
    y = "Normalized Variance"
  )
ggsave("scree.png")


# Exercise 2
data <- fixed_norm_read_counts_500

combined = data[,seq(1, 21, 3)]
combined = combined + data[,seq(2, 21, 3)]
combined = combined + data[,seq(3, 21, 3)]
combined = combined / 3

combined_filtered <- combined[rowSds(combined) > 1, ]

rowSds(combined)

#k means clustering

set.seed(42)
k_means_results <- kmeans(
  scale(combined_filtered),
  centers = 12,
  nstart = 100
)


k_means_results %>% summary()

# test <- rbind(
#   c(1,2,3),
#   c(4,5,6),
#   c(7,8,9)
# )
# order(test)


combined_filtered_sorted <- combined_filtered[order(k_means_results$cluster), ]

ordering <- order(k_means_results$cluster)
png("gene_cluster_heatmap.png")
heatmap(combined_filtered_sorted, Rowv=NA, Colv=NA, RowSideColors=RColorBrewer::brewer.pal(12,"Paired")[k_means_results$cluster[ordering]], ylab="Gene")
dev.off()

# Exercise 3


cluster_1 <- k_means_results$cluster[k_means_results$cluster == 1] %>% names()
cat(trimws(cluster_1), sep = "\n")

cluster_3 <- k_means_results$cluster[k_means_results$cluster == 3] %>% names()
cat(trimws(cluster_3), sep = "\n")
