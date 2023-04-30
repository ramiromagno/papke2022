library(tidyverse)

# Import `read_data()`
source(here::here("data-raw", "read_data.R"))

# Path to Figure 5 data
fig05_path <- here::here("data-raw", "fig05")

#
# Figure 5B
#
treatments_short <- c("Veh", "Caf", "Trg", "Tau", "Agm", "Spr", "2AP", "Lut", "nMP", "dMP")
treatments_long <- c("vehicle", "caffeine", "trigonelline", "taurine", "agmatine", "spermine", "1-(2-aminoethyl)pyrrolidine", "lutidine", "1-methylpyridinium", "1,1-dimethylpiperidium")
fig05B <- read_data(file.path(fig05_path, "fig05B.csv")) |>
  mutate(
    treatment_short = cut(x, 0:10, labels = treatments_short),
    treatment_long = cut(x, 0:10, labels = treatments_long),
    .before = 2L
    ) |>
  select(-"x") |>
  rename(nr_resp = y)

usethis::use_data(fig05B, overwrite = TRUE)
