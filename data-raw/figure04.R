library(tidyverse)

# Import `read_data()`
source(here::here("data-raw", "read_data.R"))

# Path to Figure 4 data
fig04_path <- here::here("data-raw", "fig04")

treatments <- c("Controls", "LMW DRC", "Ach-2", "DRC + LMW ACh", "ACh-3")
#
# Figure 4A
#
fig04A <- read_data(file.path(fig04_path, "fig04A.csv")) |>
  mutate(treatment = cut(x, 0:5, labels = treatments), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(receptor = "LS \u03B14(3)\u03B22(2)", coffee = "Dark roast coffee", .before = 1L)

#
# Figure 4B
#
fig04B <- read_data(file.path(fig04_path, "fig04B.csv")) |>
  mutate(treatment = cut(x, 0:5, labels = treatments), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(receptor = "HS \u03B14(2)\u03B22(3)", coffee = "Dark roast coffee", .before = 1L)

#
# Figure 4C
#
fig04C <- read_data(file.path(fig04_path, "fig04C.csv")) |>
  mutate(treatment = cut(x, 0:5, labels = treatments), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(receptor = "HS \u03B14(3)\u03B22(2)", coffee = "Green bean coffee", .before = 1L)

#
# Figure 4D
#
fig04D <- read_data(file.path(fig04_path, "fig04D.csv")) |>
  mutate(treatment = cut(x, 0:5, labels = treatments), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(receptor = "HS \u03B14(2)\u03B22(3)", coffee = "Green bean coffee", .before = 1L)

#
# Figure 4E
#
lwm_prep <- c("LS ACh + DRC", "HS ACh + DRC", "LS ACh + GBC", "HS ACh + GBC")
fig04E <- read_data(file.path(fig04_path, "fig04E.csv")) |>
  mutate(treatment = cut(x, 0:4, labels = lwm_prep), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y)

usethis::use_data(fig04A, overwrite = TRUE)
usethis::use_data(fig04B, overwrite = TRUE)
usethis::use_data(fig04C, overwrite = TRUE)
usethis::use_data(fig04D, overwrite = TRUE)
usethis::use_data(fig04E, overwrite = TRUE)
