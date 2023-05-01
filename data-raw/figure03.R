library(tidyverse)

# Import `read_data()`
source(here::here("data-raw", "read_data.R"))

# Path to Figure 3 data
fig03_path <- here::here("data-raw", "fig03")

#
# Figure 3A-LS
#
fig03A_LS_ACh1 <- read_data(file.path(fig03_path, "fig03A-LS-ACh1.csv"))
fig03A_LS_darkcoffee <- read_data(file.path(fig03_path, "fig03A-LS-darkcoffee.csv"))
fig03A_LS_ACh2 <- read_data(file.path(fig03_path, "fig03A-LS-ACh2.csv"))
fig03A_LS_ACh_darkcoffee <- read_data(file.path(fig03_path, "fig03A-LS-ACh-darkcoffee.csv"))
fig03A_LS_ACh3 <- read_data(file.path(fig03_path, "fig03A-LS-ACh3.csv"))

fig03A_LS <-
  bind_rows(
    add_column(fig03A_LS_ACh1, treatment = "ACh1"),
    add_column(fig03A_LS_darkcoffee, treatment = "Dark roast coffee"),
    add_column(fig03A_LS_ACh2, treatment = "ACh2"),
    add_column(fig03A_LS_ACh_darkcoffee, treatment = "Dark roast coffee + ACh"),
    add_column(fig03A_LS_ACh3, treatment = "ACh3")
  ) |>
  group_by(treatment) |>
  group_modify(
    ~ as_tibble(approx(.x$x, .x$y, xout = seq(trunc(min(.x$x)), trunc(max(.x$x)), by = 1)))
  ) |>
  mutate(x = x - first(x), y = y - first(y)) |>
  ungroup() |>
  add_column(receptor = "LS \u03B14(3)\u03B22(2)", .before = 1L) |>
  rename(t = x, current = y)

#
# Figure 3A-HS
#
fig03A_HS_ACh1 <- read_data(file.path(fig03_path, "fig03A-HS-ACh1.csv"))
fig03A_HS_darkcoffee <- read_data(file.path(fig03_path, "fig03A-HS-darkcoffee.csv"))
fig03A_HS_ACh2 <- read_data(file.path(fig03_path, "fig03A-HS-ACh2.csv"))
fig03A_HS_ACh_darkcoffee <- read_data(file.path(fig03_path, "fig03A-HS-ACh-darkcoffee.csv"))
fig03A_HS_ACh3 <- read_data(file.path(fig03_path, "fig03A-HS-ACh3.csv"))

fig03A_HS <-
  bind_rows(
    add_column(fig03A_HS_ACh1, treatment = "ACh1"),
    add_column(fig03A_HS_darkcoffee, treatment = "Dark roast coffee"),
    add_column(fig03A_HS_ACh2, treatment = "ACh2"),
    add_column(fig03A_HS_ACh_darkcoffee, treatment = "Dark roast coffee + ACh"),
    add_column(fig03A_HS_ACh3, treatment = "ACh3")
  ) |>
  group_by(treatment) |>
  group_modify(
    ~ as_tibble(approx(.x$x, .x$y, xout = seq(trunc(min(.x$x)), trunc(max(.x$x)), by = 1)))
  ) |>
  mutate(x = x - first(x), y = y - first(y)) |>
  ungroup() |>
  add_column(receptor = "HS \u03B14(2)\u03B22(3)", .before = 1L) |>
  rename(t = x, current = y)

#
# Figure 3A
#
fig03A <- bind_rows(fig03A_LS, fig03A_HS)

#
# Figure 3B
#
treatments <- c("controls", "DRC", "Ach-2", "DRC + ACh", "ACh-3")
fig03B <- read_data(file.path(fig03_path, "fig03B.csv")) |>
  mutate(treatment = cut(x, 0:5, labels = treatments), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(receptor = "\u03B14(3)\u03B22(2)", coffee = "Dark roast coffee", .before = 1L)

#
# Figure 3C
#
fig03C <- read_data(file.path(fig03_path, "fig03C.csv")) |>
  mutate(treatment = cut(x, 0:5, labels = treatments), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(receptor = "\u03B14(2)\u03B22(3)", coffee = "Dark roast coffee", .before = 1L)

#
# Figure 3D
#
treatments2 <- c("controls", "GBC", "Ach-2", "DRC + ACh", "ACh-3")
fig03D <- read_data(file.path(fig03_path, "fig03D.csv")) |>
  mutate(treatment = cut(x, 0:5, labels = treatments2), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(receptor = "\u03B14(3)\u03B22(2)", coffee = "Green bean coffee", .before = 1L)

#
# Figure 3E
#
fig03E <- read_data(file.path(fig03_path, "fig03E.csv")) |>
  mutate(treatment = cut(x, 0:5, labels = treatments2), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(receptor = "\u03B14(2)\u03B22(3)", coffee = "Green bean coffee", .before = 1L)

usethis::use_data(fig03A, overwrite = TRUE)
usethis::use_data(fig03B, overwrite = TRUE)
usethis::use_data(fig03C, overwrite = TRUE)
usethis::use_data(fig03D, overwrite = TRUE)
usethis::use_data(fig03E, overwrite = TRUE)
