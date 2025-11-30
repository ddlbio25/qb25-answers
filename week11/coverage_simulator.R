library(tidyverse)
num_reads <- 10^6

poisson_estimates <- read_tsv(
  "poisson_estimates.tsv",
  col_names = c("x", "pois_prob")
) %>% 
  mutate(
    pois_read_depth = pois_prob * num_reads,
    type = "pois pmf"
  ) %>% 
  select(x, pois_read_depth, type) %>% 
  rename(
    read_depth = pois_read_depth
  )

normal_estimates <- read_tsv(
  "normal_estimates.tsv",
  col_names = c("x", "normal_prob")
) %>% 
  mutate(
    norm_read_depth = normal_prob * num_reads,
    type = "normal pdf"
  ) %>% 
  select(x, norm_read_depth, type) %>% 
  rename(
    read_depth = norm_read_depth
  )

simulated_coverage <- read_tsv(
  "simulated_sequence.tsv",
  col_names = c("pos", "coverage")
)

simulated_coverage %>% 
  summarize(
    sum(coverage)
  )

read_depths <- simulated_coverage %>% 
  group_by(coverage) %>% 
  summarize(
    read_depth = n()
  ) %>% 
  mutate(type = "simulated_sequencing", read_depth = as.numeric(read_depth))



combined_df <- read_depths %>% 
  rename(x = coverage) %>% 
  bind_rows(normal_estimates, poisson_estimates)



# 3x coverage
combined_df %>% 
  ggplot(
    aes(x = x, y = read_depth, fill = type)
  ) +
  geom_histogram(alpha = 0.5, stat = "identity", position = "identity") +
  labs(
    x = "coverage",
    y = "frequency",
  ) +
  labs(
    title = "3x Coverage"
  )
ggsave("ex1_3x_cov.png")

# count 0x occurences
combined_df %>% 
  filter(x == 0 & type == "simulated_sequencing")


#10x coverage

# read in tsvs from python script using 10x coverage

combined_df %>% 
  ggplot(
    aes(x = x, y = read_depth, fill = type)
  ) +
  geom_histogram(alpha = 0.5, stat = "identity", position = "identity") +
  labs(
    x = "coverage",
    y = "frequency",
  ) +
  labs(
    title = "10x Coverage"
  )
ggsave("ex1_10x_cov.png")

# count 0x occurences
combined_df %>% 
  filter(x == 0 & type == "simulated_sequencing")


# 30x coverage
combined_df %>% 
  ggplot(
    aes(x = x, y = read_depth, fill = type)
  ) +
  geom_histogram(alpha = 0.5, stat = "identity", position = "identity") +
  labs(
    x = "coverage",
    y = "frequency",
  ) +
  labs(
    title = "30x Coverage"
  )
ggsave("ex1_30x_cov.png")

combined_df %>% 
  group_by(type) %>% 
  summarize(
    genome_lemngth = sum(read_depth)
  )

# count 0x occurences
combined_df %>% 
  filter(x == 0 & type == "simulated_sequencing")
