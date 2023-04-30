library(tidyverse)

# Import `read_data()`
source(here::here("data-raw", "read_data.R"))

nMP <- c("ACh", "ACh", rep("ACh + n-MP", 7L), "ACh", "ACh", "ACh")

create_sd <- function(df) {
  df |>
  mutate(sd = abs(lead(y) - y)) |>
  filter(rep(c(TRUE, FALSE), n() / 2)) |>
  select(-"y")
}

create_data_series <- function(df_mean, df_sd, bath) {


  left_join(
    df_mean |>
      mutate(x = as.integer(round(x))) |>
      rename(mean = y),

    df_sd |>
      create_sd() |>
      mutate(x = as.integer(round(x))),
    by = "x"
  ) |>
    mutate(x = nMP[x], .before = 1L) |>
    mutate(x_i = seq_len(n()), .before = "x") |>
    add_column(bath = bath, .before = 1L)
}

# Path to Figure 8 data
fig08_path <- here::here("data-raw", "fig08")

#
# Figure 8
#
fig08_blue_mean <- read_data(file.path(fig08_path, "fig08-blue-mean.csv"))
fig08_blue_sd <- read_data(file.path(fig08_path, "fig08-blue-sd.csv"))

fig08_darkblue_mean <- read_data(file.path(fig08_path, "fig08-darkblue-mean.csv"))
fig08_darkblue_sd <- read_data(file.path(fig08_path, "fig08-darkblue-sd.csv"))

fig08_lightblue_mean <- read_data(file.path(fig08_path, "fig08-lightblue-mean.csv"))
fig08_lightblue_sd <- read_data(file.path(fig08_path, "fig08-lightblue-sd.csv"))

fig08_pink_mean <- read_data(file.path(fig08_path, "fig08-pink-mean.csv"))
fig08_pink_sd <- read_data(file.path(fig08_path, "fig08-pink-sd.csv"))

fig08_purple_mean <- read_data(file.path(fig08_path, "fig08-purple-mean.csv"))
fig08_purple_sd <- read_data(file.path(fig08_path, "fig08-purple-sd.csv"))

fig08_red_mean <- read_data(file.path(fig08_path, "fig08-red-mean.csv"))
fig08_red_sd <- read_data(file.path(fig08_path, "fig08-red-sd.csv"))

fig08 <-
  bind_rows(
    create_data_series(fig08_blue_mean, fig08_blue_sd, "LS 100 \u03BCM n-MP"),
    create_data_series(fig08_darkblue_mean, fig08_darkblue_sd, "LS 300 \u03BCM n-MP"),
    create_data_series(fig08_lightblue_mean, fig08_lightblue_sd, "LS 30 \u03BCM n-MP"),
    create_data_series(fig08_pink_mean, fig08_pink_sd, "HS 30 \u03BCM n-MP"),
    create_data_series(fig08_purple_mean, fig08_purple_sd, "HS 100 \u03BCM n-MP"),
    create_data_series(fig08_red_mean, fig08_red_sd, "HS 300 \u03BCM n-MP")
  ) |>
  mutate(signif = if_else(x == "ACh + n-MP" & grepl("^HS", bath), "**", "")) |>
  mutate(signif = if_else(x_i %in% c(11L, 12L) & grepl("LS 300", bath), "*", signif))

usethis::use_data(fig08, overwrite = TRUE)

# bath_colours <- c(
#   "LS 100 \u03BCM n-MP" = "#51aff5",
#   "LS 300 \u03BCM n-MP" = "#1f6bff",
#   "LS 30 \u03BCM n-MP" = "#4fefff",
#   "HS 30 \u03BCM n-MP" = "#f0bed9",
#   "HS 100 \u03BCM n-MP" = "#d880d4",
#   "HS 300 \u03BCM n-MP" = "#fe0d6c"
# )
#
# bath_shapes <- c(
#   "LS 100 \u03BCM n-MP" = 21L,
#   "LS 300 \u03BCM n-MP" = 21L,
#   "LS 30 \u03BCM n-MP" = 21L,
#   "HS 30 \u03BCM n-MP" = 22L,
#   "HS 100 \u03BCM n-MP" = 22L,
#   "HS 300 \u03BCM n-MP" = 22L
# )
#
# fig08 |>
#   ggplot(aes(x = x_i, y = mean, group = bath)) +
#   geom_line(linewidth = 0.25) +
#   geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),
#                 width = 0.1, linewidth = 0.25) +
#   geom_point(aes(fill = bath, shape = if_else(grepl("^LS", bath), 21L, 22L)), size = 3) +
#   scale_shape_identity() +
#   scale_fill_manual(values = bath_colours) +
#   geom_text(aes(y = mean + sd, label = signif), size = 5, nudge_y = 0.01) +
#   scale_x_continuous(breaks = 1:12, labels = nMP) +
#   scale_y_continuous(breaks = seq(0, 1.8, 0.2)) +
#   ylab("Normalized response") +
#   theme_light() +
#   theme(
#     axis.text.x = element_text(face = "bold", angle = 90),
#     axis.title.x = element_blank(),
#     plot.title = element_text(hjust = 0.5),
#     plot.subtitle = element_text(hjust = 0.5)) +
#   ggtitle("ACh responses with bath application of n-MP", sub = "n-MP")
#
#
#
