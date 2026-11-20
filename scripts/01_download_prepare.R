# Epilepsy in Canada: download and prepare official CCDSS data
# Author: Niknaz Akbarpour
# Source: Public Health Agency of Canada, CCDSS 2025

options(stringsAsFactors = FALSE, timeout = 300)

dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs", recursive = TRUE, showWarnings = FALSE)

sources <- data.frame(
  dataset = c(
    "life_prevalence_trend",
    "active_prevalence_trend",
    "life_prevalence_age_distribution",
    "life_prevalence_age_standardized"
  ),
  url = c(
    "https://health-infobase.canada.ca/ccdss/Download.aspx?i=17&s=5&b=t&l=eng",
    "https://health-infobase.canada.ca/ccdss/Download.aspx?i=18&s=5&b=t&l=eng",
    "https://health-infobase.canada.ca/ccdss/Download.aspx?i=17&s=5&b=d&l=eng",
    "https://health-infobase.canada.ca/ccdss/Download.aspx?i=17&s=2&b=t&l=eng"
  ),
  stringsAsFactors = FALSE
)

clean_name <- function(x) {
  x <- iconv(x, from = "", to = "ASCII//TRANSLIT")
  x <- tolower(x)
  x <- gsub("95%_ci", "95_ci", x, fixed = TRUE)
  x <- gsub("%", "percent", x, fixed = TRUE)
  x <- gsub("[^a-z0-9]+", "_", x)
  gsub("^_|_$", "", x)
}

read_ccdss_download <- function(path) {
  lines <- readLines(path, encoding = "latin1", warn = FALSE)
  header <- grep('^"Geography","Sex"', lines)[1]
  if (is.na(header)) stop("CCDSS table header not found in ", path)

  table_text <- paste(lines[header:length(lines)], collapse = "\n")
  dat <- read.csv(text = table_text, fill = TRUE, check.names = FALSE,
                  na.strings = c("", "NA"))
  dat <- dat[dat$Sex %in% c("Both sexes", "Females", "Males"), , drop = FALSE]
  dat <- dat[, seq_len(12), drop = FALSE]
  names(dat) <- clean_name(names(dat))

  dat$fiscal_year <- sub("\\*$", "", dat$fiscal_year)
  numeric_columns <- c(
    "prevalence_percent", "standard_error", "lower_95_ci",
    "upper_95_ci", "prevalence_cv_percent", "case_counts", "population"
  )
  for (column in numeric_columns) dat[[column]] <- as.numeric(dat[[column]])
  dat
}

for (i in seq_len(nrow(sources))) {
  raw_path <- file.path("data/raw", paste0(sources$dataset[i], ".txt"))
  processed_path <- file.path("data/processed", paste0(sources$dataset[i], ".csv"))

  if (!file.exists(raw_path)) {
    download.file(sources$url[i], raw_path, mode = "wb", quiet = FALSE)
  }

  prepared <- read_ccdss_download(raw_path)
  write.csv(prepared, processed_path, row.names = FALSE, na = "")
}

write.csv(sources, "outputs/source_manifest.csv", row.names = FALSE)
writeLines(capture.output(sessionInfo()), "outputs/session_info.txt")
message("CCDSS epilepsy datasets downloaded and prepared successfully.")

