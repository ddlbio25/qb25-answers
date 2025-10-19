---
editor_options: 
  markdown: 
    wrap: 72
---

Step 2.2 OLS maternal age vs maternal DNMs, Mothers:

Question 1: The slope of maternal dnms vs maternal age is 0.37757. The
slope means that for every year the mother ages, the number of de novo
mutations in the germline passed onto their child increases by 0.37757.
It matches the plot because the y intercept is about zero on the plot,
and at 40 years the average number of de novo mutations is less than 20,
which corresponds roughly to the slope predicted by the linear model.

Question 2: The relationship is significant because the P-value for the
Beta 1 coefficient is less than 2.2 e-16. The p-value is the probablity
of observing a beta coefficient at least as large as what was found in
the linear model of maternal dnm count vs maternal age, assuming that
the null hypothesis that the beta coefficient is zero is true.

Step 2.3 OLS paternal age vs paternal DNMs, Fathers:

Question 1: The slope paternal dnms vs paternal age is 1.35384. The
slope means that for every year the father ages, the number of de novo
mutations in the germ line passed onto their child increases by \~1.35.
It matches the plot because on the plot, the y intercept looks likes
it's about 10, and at 50 years old the average number of de novo
mutations is about 70, which matches roughly to 10.32 + 1.35\*50 =
77.82.

Question 2: The relationship is significant because the P-value for the
Beta 1 coefficient is less than 2.2 e-16. The p-value is the probablity
of observing a beta coefficient at least as large as what was found in
the linear model of paternal dnm count vs paternal age, assuming that
the null hypothesis that the beta coefficient is zero is true.

Step 2.4 - Predict for a 50.5 year old father

A 50.5 year old father would have about 79 DNMs, based on a fitted value
78.70 off of the model.

```         
y = B_0 + B_1 * x
dnm_count = 10.32632 + 1.35384 * 50.5
```

#### **Step 2.6 — Statistical test: maternal vs. paternal DNMs per proband**

Question 1:

The average difference between the number of paternal vs maternal DNMs
is 39.23485. This mean's on average, a child will have about 39 more
DNMs on their haplotype from their father than on their haplotype from
their mother. This matches the plot because the center of the maternal
DNM count distribution is about 10, and the paternal distribution about
50, indicating an average distance of 40.

Question 2:

The relationship is significant because the p-value is less than
2.2e-16. The p-value is probability that observing a difference at least
as great as what was observed assuming the null hypothesis, that the
true difference is actually zero, is true.

TIDY DATASETS:

3.1)

I choose week 21, 2025-05-27, [Dungeons and Dragons Monsters
(2024)](https://github.com/rfordatascience/tidytuesday/blob/main/data/2025/2025-05-27/readme.md),

I use the following command to read in the dataframe:

```         
monsters <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-05-27/monsters.csv')
```

3.2)

I plot challenge rating of the monster vs its armor class, average
health, and walking speed to see how the values relate. Challenge rating
is positively correlated with armor class and average health, with
average health appearing to have a non-linear relationship, and walking
speed having no apparent correlation with challenge rating.

3.3)

I propose that average hp and armor rating positively correlate with the
monster's challenge rating, with the walking speed having no correlation
or effect.

I fit the linear model (challenge_rating \~ 1 + armor_class +
average_hp + walking_speed).

The coefficients for armor class (0.207) and average hp (0.050) are
statistically significant, while the Beta_3 for walking speed (0.0004)
was not. This means that both armor class and average hp positively
correlate with the challenge rating of the monster, while walking speed
probably does not correlate with the challenge rating of the monster.
Every extra point in armor class increases the challenge rating by about
0.2, while the every average hp point increases it by about 0.05. This
makes sense, given that monsters with higher armor class and more HP are
more challenging to defeat.
