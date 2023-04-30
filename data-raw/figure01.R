library(tidyverse)

# Import `read_data()`
source(here::here("data-raw", "read_data.R"))

# Path to Figure 1 data
fig01_path <- here::here("data-raw", "fig01")

fig01A_ACh <- read_data(file.path(fig01_path, "fig01A-ACh.csv"))
fig01A_coffee <- read_data(file.path(fig01_path, "fig01A-coffee.csv"))
fig01A_ACh2 <- read_data(file.path(fig01_path, "fig01A-ACh2.csv"))
fig01A_coffee_PNU <- read_data(file.path(fig01_path, "fig01A-coffee-PNU.csv"))

fig01A <-
  bind_rows(
    add_column(fig01A_ACh, treatment = "ACh1"),
    add_column(fig01A_coffee, treatment = "Coffee"),
    add_column(fig01A_ACh2, treatment = "ACh2"),
    add_column(fig01A_coffee_PNU, treatment = "Coffee + PNU")
  ) |>
  group_by(treatment) |>
  group_modify(
    ~ as_tibble(approx(.x$x, .x$y, xout = seq(trunc(min(.x$x)), trunc(max(.x$x)), by = 1)))
  ) |>
  mutate(x = x - first(x), y = y - first(y)) |>
  ungroup() |>
  add_column(coffee = "Dark Roasted Coffee", .before = 1L) |>
  rename(t = x, current = y)

fig01B_ACh <- read_data(file.path(fig01_path, "fig01B-ACh.csv"))
fig01B_coffee <- read_data(file.path(fig01_path, "fig01B-coffee.csv"))
fig01B_ACh2 <- read_data(file.path(fig01_path, "fig01B-ACh2.csv"))
fig01B_coffee_PNU <- read_data(file.path(fig01_path, "fig01B-coffee-PNU.csv"))

fig01B <-
  bind_rows(
    add_column(fig01B_ACh, treatment = "ACh1"),
    add_column(fig01B_coffee, treatment = "Coffee"),
    add_column(fig01B_ACh2, treatment = "ACh2"),
    add_column(fig01B_coffee_PNU, treatment = "Coffee + PNU")
  ) |>
  group_by(treatment) |>
  group_modify(
    ~ as_tibble(approx(.x$x, .x$y, xout = seq(trunc(min(.x$x)), trunc(max(.x$x)), by = 1)))
  ) |>
  mutate(x = x - first(x), y = y - first(y)) |>
  ungroup() |>
  add_column(coffee = "Green Bean Coffee", .before = 1L) |>
  rename(t = x, current = y)


  add_column(bind_rows(
    add_column(fig01B_ACh, treatment = "ACh1"),
    add_column(fig01B_coffee, treatment = "Coffee"),
    add_column(fig01B_ACh2, treatment = "ACh2"),
    add_column(fig01B_coffee_PNU, treatment = "Coffee + PNU"),
  ),
  coffee = "Green Bean Coffee")

treatments <- c("controls", "DRC", "ACh after DRC", "DRC + PNU")
fig01A_dark_roast_coffee <-
  read_data(file.path(fig01_path, "fig01A-dark-roast-coffee.csv")) |>
  mutate(treatment = cut(x, 0:4, labels = treatments), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(coffee = "Dark Roasted Coffee", .before = 1L)

fig01B_green_bean_coffee <-
  read_data(file.path(fig01_path, "fig01B-green-bean-coffee.csv")) |>
  mutate(treatment = cut(x, 0:4, labels = treatments), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y) |>
  add_column(coffee = "Green Bean Coffee", .before = 1L)

fig01A1 <- fig01A
fig01A2 <- fig01A_dark_roast_coffee
fig01B1 <- fig01B
fig01B2 <- fig01B_green_bean_coffee

usethis::use_data(fig01A1, overwrite = TRUE)
usethis::use_data(fig01A2, overwrite = TRUE)
usethis::use_data(fig01B1, overwrite = TRUE)
usethis::use_data(fig01B2, overwrite = TRUE)
