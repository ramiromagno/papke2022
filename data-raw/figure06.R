library(tidyverse)

# Import `read_data()`
source(here::here("data-raw", "read_data.R"))

# Path to Figure 6 data
fig06_path <- here::here("data-raw", "fig06")

#
# Figure 6
#
treatment <- rep(c("Caf", "Trg", "Tau", "Agm", "Spr", "2AP", "Lut", "nMP", "dMP"), each = 2)
sensitivity <-rep_len(c("LS", "HS"), length.out = length(treatment))

fig06 <- read_data(file.path(fig06_path, "fig06.csv")) |>
  mutate(
    treatment = cut(x, 0:18, labels = treatment),
    sensitivity = cut(x, 0:18, labels = sensitivity),
    .before = 2L
  ) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  mutate(signif = if_else(treatment %in% c("nMP", "dMP") & sensitivity %in% c("HS", "HS"), "**", ""))

usethis::use_data(fig06, overwrite = TRUE)
