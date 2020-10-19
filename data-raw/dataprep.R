## code to prepare `DATASET` dataset goes here

# load raw data
rawdata_path <- system.file("extdata", "rawdata.csv", package = "CSPAfricaData")
rawdata <- data.table::fread(rawdata_path)


# categorize sectors
rawdata[, Sector := .(dplyr::recode(sector,
  "Consumer Goods" = "Secondary",
  "Basic Materials" = "Primary",
  "Technology" = "Tertiary",
  "Healthcare" = "Tertiary",
  "Industrials" = "Secondary",
  "Consumer Services" = "Tertiary",
  "Oil and Gas" = "Primary",
  "Utilities" = "Primary",
  "Telecommunications" = "Tertiary"
))]
str(rawdata, list.len = 200)

# remove non-numeric characters from CFP variables and coerce them to numeric
rawdata[, `:=`(
  net_prof = CSPAfricaData::coerce_num_cln(net_prof),
  tot_asst = CSPAfricaData::coerce_num_cln(tot_asst),
  bk_eqt = CSPAfricaData::coerce_num_cln(bk_eqt),
  market_value = CSPAfricaData::coerce_num_cln(market_value)
)]


# calc CFP variables
rawdata[, `:=`(
  return_on_assets = net_prof / tot_asst,
  return_on_equity = net_prof / bk_eqt,
  tobins_q = market_value / tot_asst
)][bk_eqt == 0, return_on_equity := NA][tot_asst == 0, `:=`(
  return_on_assets = NA,
  tobins_q = NA
)][tobins_q == 0, tobins_q := NA]

# # remove infinte values for CSP measures
# rawdata[return_on_assets == Inf | return_on_equity == Inf | tobins_q == Inf,
#         .(net_prof, bk_eqt, market_value, tot_asst,
#           tobins_q, return_on_equity, return_on_assets)]

#
# # check for outliers
# rawdata[return_on_equity > 50 | return_on_equity < -50 |
#           return_on_assets > 50 | return_on_assets < -50, .(company,
#                                                             listing_year,
#                                                             return_on_equity,
#                                                             return_on_assets,
#                                                             tobins_q,
#                                                             net_prof,
#                                                             bk_eqt,
#                                                             market_value)]


# drop outlier values of calculated CFP measures for later investigation
# -50 and 50 chosen as boundaries for outliers
rawdata[return_on_equity > 50 | return_on_equity < -50, return_on_equity := NA][tobins_q > 50 | tobins_q < -50, tobins_q := NA][return_on_assets > 50 | return_on_assets < -50, return_on_assets := NA]

# calc firm age vars
rawdata[, `:=`(
  listing_age = reporting_year - listing_year,
  incorp_age = reporting_year - incorporation_year
)]

# ethics committee
rawdata[, social_committee := ifelse(social_committee == 0, 0, 1)]

# character vars to factors
rawdata[, `:=`(
  Country = factor(listing_country),
  Multinational = factor(locality, labels = c("Yes", "No")),
  Sector = factor(Sector),
  social_committee = factor(social_committee),
  reporting_year = factor(reporting_year)
)]

str(rawdata, list.len = 200)

# create lagged CFP variables
rawdata[order(company, reporting_year)]

library(data.table)
rawdata[, lag_return_on_assets := shift(return_on_assets, 1L, "lag"), by = "company"][, lag_return_on_equity := shift(return_on_equity, 1L, "lag"), by = "company"][, lag_tobins_q := shift(tobins_q, 1L, "lag"), by = "company"]



reg_vars <- c(
  "Country", "Multinational", "Sector",
  "listing_age", "incorp_age",
  "lag_return_on_assets", "lag_return_on_equity",
  "social_committee", "reporting_year"
)


reg_data <- rawdata[, reg_vars, with = F]
str(reg_data)
head(reg_data, n = 20)

# recode CSR variables from 0-5 to 0-2 (1:4 = 1, 5 = 2)
csr_vars <- names(rawdata)[grepl(
  "com_|ene_|prod_|emi_|hr_|env_|oth_",
  names(rawdata)
)]

rawdata <- rawdata[, lapply(.SD, dplyr::recode,
  `1` = 1L, `2` = 1L, `3` = 1L, `4` = 1L, `5` = 2L
),
.SDcols = csr_vars
]

# lapply(rawdata, summary)

# consolidate CSR variables by summing to create combined domains
com <- list(
  n_com_educ = c("1", "2", "3", "9"),
  n_com_hlth = c("4", "5"),
  n_com_art = c("6", "18"),
  n_com_econ = c("7", "8", "16"),
  n_com_agric = c("11", "15", "17"),
  n_com_activism = c("12", "13", "14", "19", "20", "21", "22", "10")
)

hr <- list(
  n_hr_safety = c("1", "2", "3", "4", "5"),
  n_hr_diversity = c("7", "8", "30"),
  n_hr_training = c("9", "10", "11"),
  n_hr_benefits = c(
    "6", "12", "13", "21", "22", "23", "24",
    "26", "27", "28", "29"
  ),
  n_hr_monitoring = c("14", "15", "18", "25"),
  n_hr_satisfaction = c("16", "17", "19", "20")
)

prod <- list(
  n_prod_info = c("1", "6"),
  n_prod_quality = c("2", "3", "4", "5")
)

env <- list(
  n_env_pollution = c("1", "2", "3", "7", "12"),
  n_env_conservation = c("4", "5", "8", "15"),
  n_env_policy = c("6", "9"),
  n_env_water = c("10", "11", "13", "14")
)

ene <- list(
  n_ene_conservation = c("1", "2", "3", "4"),
  n_ene_policy = c("5", "6", "7")
)

emi <- list(
  n_emi_policy = c("1", "3", "4", "5", "6", "7"),
  n_emi_practice = c("2", "8", "9", "10")
)

oth <- list(
  n_oth_other = c(1:6)
)

csr_stems <- c("com", "hr", "prod", "ene", "emi", "env", "oth")

create_list_of_vars <- function(x, y) {
  paste0(x, "_", y)
}

csr_varlist <-
  unlist(lapply(
    csr_stems,
    function(x) {
      lapply(
        get(x),
        function(y) {
          create_list_of_vars(x, y)
        }
      )
    }
  ),
  recursive = F
  )

csr_varnames <- names(csr_varlist)

lapply(csr_varnames, function(x) {
  rawdata[, x := rowSums(.SD), .SDcols = csr_varlist[[x]], with = F]
})


csr_domains <- names(rawdata)[grepl("^n_", names(rawdata))]
csr_domains

pca_data <- (cbind(
  reg_data[, .(Sector, Country)],
  rawdata[, .SD, .SDcols = c(csr_domains)]
))
data.table::setDT(pca_data)

str(pca_data)

# deploy data to be
usethis::use_data(reg_data, overwrite = TRUE)
usethis::use_data(pca_data, overwrite = TRUE)
