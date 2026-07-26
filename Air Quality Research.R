pkgs <- c("tidyverse","skimr","GGally","broom","car","mgcv")
installed <- rownames(installed.packages())
to_install <- setdiff(pkgs, installed)
if (length(to_install) > 0) install.packages(to_install)

library(tidyverse)
library(skimr)
library(GGally)
library(broom)
library(car)
library(mgcv)

df <- read_csv("air_quality_health_impact_data.csv", show_col_types = FALSE)

names(df) <- names(df) |>
  str_trim() |>
  str_to_lower() |>
  str_replace_all("[^a-z0-9]+", "_") |>
  str_replace_all("_+$", "")

pollutant_patterns <- "pm2|pm_2|pm2_5|pm10|no2|o3|so2|co|aqi"
health_patterns <- "asthma|copd|er|ed|hospital|admission|mortality|death|cases|visits|rate"
control_patterns <- "temp|temperature|humid|humidity|wind|rain|precip|season|flu|population"

pollutants <- names(df)[str_detect(names(df), pollutant_patterns)]
health_vars <- names(df)[str_detect(names(df), health_patterns)]
controls <- names(df)[str_detect(names(df), control_patterns)]

df <- df %>%
  mutate(across(all_of(unique(c(pollutants, health_vars, controls))),
                ~ readr::parse_number(as.character(.))))

stopifnot(length(pollutants) > 0, length(health_vars) > 0)

health_y <- health_vars[1]

df_model <- df %>%
  select(any_of(c(health_y, pollutants, controls))) %>%
  drop_na()

cor_cols <- df_model %>% select(where(is.numeric)) %>% names()
cor_mat <- cor(df_model[, cor_cols], use = "complete.obs")
print(round(cor_mat, 3))

ggpairs(df_model, columns = unique(c(head(pollutants, 3), health_y)))

for (p in head(pollutants, 4)) {
  ggplot(df_model, aes(x = .data[[p]], y = .data[[health_y]])) +
    geom_point(alpha = 0.4) +
    geom_smooth(method = "lm", se = TRUE) +
    labs(x = p, y = health_y) %>%
    print()
}

rhs_terms <- c(pollutants, controls)
rhs_terms <- rhs_terms[rhs_terms %in% names(df_model)]
lm_fmla <- as.formula(paste(health_y, "~", paste(rhs_terms, col_
