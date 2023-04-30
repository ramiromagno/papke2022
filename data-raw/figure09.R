library(tidyverse)

# Import `read_data()`
source(here::here("data-raw", "read_data.R"))

# Path to Figure 9 data
fig09_path <- here::here("data-raw", "fig09")

#
# Figure 9
#
fig09A <- read_data(file.path(fig09_path, "fig09A.csv"))
fig09B <- read_data(file.path(fig09_path, "fig09B.csv"))

fig09A_x <- c("\u03B14\u03B22\u03B15", "\u03B23\u03B14\u03B22\u03B16\u03B22")
fig09B_x <- c("\u03B13\u03B22 5:1", "\u03B13\u03B22 1:5", "\u03B13\u03B24 5:1", "\u03B13\u03B24 1:5")
fig09B_x2 <- c("\u03B13\u03B22", "\u03B13\u03B22", "\u03B13\u03B24", "\u03B13\u03B24")

fig09 <-
  bind_rows(
    mutate(
      fig09A,
      nAChR = cut(x, 0:2, labels = fig09A_x),
      .before = 2L
    ) |>
      select(-"x") |>
      rename(peak_current = y) |>
      add_column(nMP_conc = 100L, .before = 1L),

    mutate(
      fig09B,
      nAChR = cut(x, 0:4, labels = fig09B_x2),
      nAChR_stoich = cut(x, 0:4, labels = fig09B_x),
      .before = 2L
    ) |>
      select(-"x") |>
      rename(peak_current = y) |>
      add_column(nMP_conc = 300L, .before = 1L)
  )

usethis::use_data(fig09, overwrite = TRUE)

# #
# # Figure 9A
# #
# fig09 |>
#   filter(nMP_conc == 100L) |>
#   ggplot(aes(x = nAChR, y = peak_current)) +
#   geom_jitter() +
#   geom_hline(yintercept = 1, linetype = "dashed") +
#   scale_y_continuous(
#     name = "Peak currents relative to ACh alone",
#     breaks = seq(0, 1.4, 0.2),
#     limits = c(0, 1.4),
#     expand=c(0,0)
#   ) +
#   theme_classic() +
#   theme(
#     axis.ticks.length = unit(-0.25, "cm"),
#     axis.title.x = element_blank(),
#     plot.title = element_text(face = "bold", hjust = 0.5)
#   ) +
#   ggtitle("Effects of 100 \u03BCM n-MP")
#
#
# #
# # Figure 9A
# #
# fig09 |>
#   filter(nMP_conc == 300L) |>
#   ggplot(aes(x = nAChR_stoich, y = peak_current)) +
#   geom_jitter() +
#   geom_hline(yintercept = 1, linetype = "dashed") +
#   scale_y_continuous(
#     name = "Peak currents relative to ACh alone",
#     breaks = seq(0, 3, 0.2),
#     limits = c(0, 3),
#     expand=c(0,0)
#   ) +
#   theme_classic() +
#   theme(
#     axis.ticks.length = unit(-0.25, "cm"),
#     axis.title.x = element_blank(),
#     plot.title = element_text(face = "bold", hjust = 0.5)
#   ) +
#   ggtitle("Effects of 300 \u03BCM n-MP on alpha3 nAChR")
