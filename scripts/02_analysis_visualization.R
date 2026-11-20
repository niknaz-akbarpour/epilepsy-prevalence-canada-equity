# Epilepsy in Canada: descriptive analysis and visualizations
# Run after scripts/01_download_prepare.R

options(stringsAsFactors = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

trend <- read.csv("data/processed/life_prevalence_trend.csv")
active <- read.csv("data/processed/active_prevalence_trend.csv")
age_data <- read.csv("data/processed/life_prevalence_age_distribution.csv")
standardized <- read.csv("data/processed/life_prevalence_age_standardized.csv")

latest_year <- "2023–2024"

national_latest <- subset(
  trend,
  geography == "Canada" & sex == "Both sexes" & fiscal_year == latest_year
)
active_latest <- subset(
  active,
  geography == "Canada" & sex == "Both sexes" & fiscal_year == latest_year
)

latest_summary <- data.frame(
  measure = c("Ever identified epilepsy", "Active epilepsy"),
  fiscal_year = latest_year,
  prevalence_percent = c(
    national_latest$prevalence_percent,
    active_latest$prevalence_percent
  ),
  case_counts = c(national_latest$case_counts, active_latest$case_counts),
  population_age_1_plus = c(national_latest$population, active_latest$population)
)
write.csv(latest_summary, "outputs/national_latest_summary.csv", row.names = FALSE)

national_trend <- subset(trend, geography == "Canada" & age_group == "1+")
write.csv(national_trend, "outputs/national_trend_by_sex.csv", row.names = FALSE)

age_order <- c("1–19", "20–34", "35–49", "50–64", "65–79", "80+")
latest_age <- subset(
  age_data,
  geography == "Canada" & sex == "Both sexes" &
    age_group_type == "Life course" & fiscal_year == latest_year
)
latest_age$age_group <- factor(latest_age$age_group, levels = age_order)
latest_age <- latest_age[order(latest_age$age_group), ]
write.csv(latest_age, "outputs/latest_age_distribution.csv", row.names = FALSE)

province_latest <- subset(
  standardized,
  geography != "Canada" & sex == "Both sexes" & fiscal_year == latest_year
)
province_latest <- province_latest[order(province_latest$prevalence_percent), ]
write.csv(
  province_latest,
  "outputs/latest_geographic_comparison_age_standardized.csv",
  row.names = FALSE
)

# Figure 1: national prevalence trend by sex
png("outputs/figures/national_epilepsy_prevalence_trend.png",
    width = 1800, height = 1100, res = 170)
sex_colours <- c("Both sexes" = "#5B3F8C", "Females" = "#C26A8D", "Males" = "#347C98")
years <- unique(national_trend$fiscal_year)
plot(
  seq_along(years), rep(NA, length(years)),
  ylim = range(national_trend$prevalence_percent, na.rm = TRUE) + c(-0.03, 0.05),
  xaxt = "n", xlab = "Fiscal year", ylab = "Prevalence (%)",
  main = "Epilepsy prevalence in Canada, 2005–2006 to 2023–2024"
)
axis(1, at = seq_along(years), labels = years, las = 2, cex.axis = 0.75)
grid(col = "#E7E2EC")
for (group in names(sex_colours)) {
  d <- national_trend[national_trend$sex == group, ]
  lines(seq_along(years), d$prevalence_percent, type = "o", lwd = 2.3,
        pch = 16, col = sex_colours[group])
}
legend("topleft", legend = names(sex_colours), col = sex_colours,
       lwd = 2.3, pch = 16, bty = "n")
mtext("Source: Public Health Agency of Canada, CCDSS 2025. Ever-identified epilepsy; age 1+.",
      side = 1, line = 6.4, cex = 0.72)
dev.off()

# Figure 2: latest life-course age distribution
png("outputs/figures/epilepsy_prevalence_by_age_2023_24.png",
    width = 1600, height = 1000, res = 170)
barplot(
  latest_age$prevalence_percent,
  names.arg = latest_age$age_group,
  col = "#7C64A8", border = NA,
  xlab = "Age group", ylab = "Prevalence (%)",
  main = "Epilepsy prevalence by age group, Canada, 2023–2024"
)
grid(nx = NA, ny = NULL, col = "#E7E2EC")
mtext("Source: Public Health Agency of Canada, CCDSS 2025. Both sexes; ever-identified epilepsy.",
      side = 1, line = 4, cex = 0.72)
dev.off()

message("Descriptive tables and figures created successfully.")

