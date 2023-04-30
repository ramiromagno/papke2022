library(tidyverse)

# Import `read_data()`
source(here::here("data-raw", "read_data.R"))

# Path to Figure 2 data
fig02_path <- here::here("data-raw", "fig02")

#
# Figure 2A
#
fig02A_ACh <- read_data(file.path(fig02_path, "fig02A-ACh.csv"))
fig02A_darkcoffee_PNU <- read_data(file.path(fig02_path, "fig02A-darkcoffee-PNU.csv"))
fig02A_ACh2 <- read_data(file.path(fig02_path, "fig02A-ACh2.csv"))
fig02A_greencoffee_PNU <- read_data(file.path(fig02_path, "fig02A-greencoffee-PNU.csv"))

fig02A <-
  bind_rows(
    add_column(fig02A_ACh, treatment = "ACh1"),
    add_column(fig02A_darkcoffee_PNU, treatment = "LMW Dark roast coffee + 10 \u03BCM PNU-120596"),
    add_column(fig02A_ACh2, treatment = "ACh2"),
    add_column(fig02A_greencoffee_PNU, treatment = "LMW Green bean coffee + 10 \u03BCM PNU-120596")
  ) |>
  group_by(treatment) |>
  group_modify(
    ~ as_tibble(approx(.x$x, .x$y, xout = seq(trunc(min(.x$x)), trunc(max(.x$x)), by = 1)))
  ) |>
  mutate(x = x - first(x), y = y - first(y)) |>
  ungroup() |>
  rename(t = x, current = y) |>
  drop_na()

#
# Figure 2B
#
fig02B_ACh <- read_data(file.path(fig02_path, "fig02B-ACh.csv"))
fig02B_choline_PNU <- read_data(file.path(fig02_path, "fig02B-Choline-PNU.csv"))

fig02B <-
  bind_rows(
    add_column(fig02B_ACh, treatment = "ACh"),
    add_column(fig02B_choline_PNU, treatment = "100 \u03BCM Choline + 10 \u03BCM PNU-120596"),
  ) |>
  group_by(treatment) |>
  group_modify(
    ~ as_tibble(approx(.x$x, .x$y, xout = seq(trunc(min(.x$x)), trunc(max(.x$x)), by = 1)))
  ) |>
  mutate(x = x - first(x), y = y - first(y)) |>
  ungroup() |>
  rename(t = x, current = y) |>
  drop_na()

#
# Figure 2C
#
fig02C_bd_mean <- read_data(file.path(fig02_path, "fig02C-blackdot-mean.csv"))
fig02C_rd_mean <- read_data(file.path(fig02_path, "fig02C-reddot-mean.csv"))
fig02C_bd_sem <- read_data(file.path(fig02_path, "fig02C-blackdot-sem.csv"))
fig02C_rd_sem <- read_data(file.path(fig02_path, "fig02C-reddot-sem.csv"))
fig02C_x <- c(10, 30, 100, 300, 1000, 3000, 10000)

fig02C <-
bind_rows(
  add_column(
    left_join(
      fig02C_bd_mean |>
        mutate(x = fig02C_x),

      fig02C_bd_sem |>
        mutate(sem = abs(lead(y) - y)) |>
        filter(rep(c(TRUE, FALSE), n() / 2)) |>
        mutate(x = fig02C_x) |>
        select(-"y"),
      by = "x"
    ),
    treatment = "response",
    .before = 1L
  ),

  add_column(
    left_join(
      fig02C_rd_mean |>
        mutate(x = fig02C_x),

      fig02C_rd_sem |>
        mutate(sem = abs(lead(y) - y)) |>
        filter(rep(c(TRUE, FALSE), n() / 2)) |>
        mutate(x = fig02C_x) |>
        select(-"y"),
      by = "x"
    ),
    treatment = "response + PNU",
    .before = 1L
  )
) |>
  rename(conc = x, mean = y)

#
# Figure 2D
#
treatments <- c("controls", "LMW DRC", "LMW GBC", "Choline")
fig02D <- read_data(file.path(fig02_path, "fig02D.csv")) |>
  mutate(treatment = cut(x, 0:4, labels = treatments), .before = 2L) |>
  select(-"x") |>
  rename(nr_resp = y)

usethis::use_data(fig02A, overwrite = TRUE)
usethis::use_data(fig02B, overwrite = TRUE)
usethis::use_data(fig02C, overwrite = TRUE)
usethis::use_data(fig02D, overwrite = TRUE)
