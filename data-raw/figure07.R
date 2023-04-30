library(tidyverse)

# Import `read_data()`
source(here::here("data-raw", "read_data.R"))

# Path to Figure 7 data
fig07_path <- here::here("data-raw", "fig07")

#
# Figure 7A
#
fig07A_reddots <- read_data(file.path(fig07_path, "fig07A-reddots.csv"))
fig07A_whitedots <- read_data(file.path(fig07_path, "fig07A-whitedots.csv"))

fig07A <-
  bind_rows(
    add_column(
      mutate(fig07A_whitedots, x = signif(x, digits = 1)),
      treatment = "ACh",
      .before = 1L
    ),

    add_column(
      mutate(fig07A_reddots, x = signif(x, digits = 1)),
      treatment = "ACh + 100 \u03BCM n-MP",
      .before = 1L
    )
  ) |>
  rename(conc = x, nr_resp = y) |>
  add_column(receptor = "LS \u03B14\u03B22")

#
# Figure 7B
#
fig07B_bluedots <- read_data(file.path(fig07_path, "fig07B-bluedots.csv"))
fig07B_whitedots <- read_data(file.path(fig07_path, "fig07B-whitedots.csv"))

fig07B <-
  bind_rows(
    add_column(
      mutate(fig07B_whitedots, x = signif(x, digits = 1)),
      treatment = "ACh",
      .before = 1L
    ),

    add_column(
      mutate(fig07B_bluedots, x = signif(x, digits = 1)),
      treatment = "ACh + 100 \u03BCM n-MP",
      .before = 1L
    )
  ) |>
  rename(conc = x, nr_resp = y) |>
  add_column(receptor = "HS \u03B14\u03B22")

usethis::use_data(fig07A, overwrite = TRUE)
usethis::use_data(fig07B, overwrite = TRUE)
