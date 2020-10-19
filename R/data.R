#' CSP data for PCA
#'
#' A dataset containing variables on CSP domains, and company characteristics
#' for 238 African companies spanning a period of 5 years (2014 to 2018)
#'
#' Note: some data was used from companies in the period before they
#' were officially listed  on the stock exchange
#'
#' @format A data frame with 1195 rows and 110 variables:
#'
#' \describe{
#'   \item{Sector}{Categorization of industry, 9 categories}
#'   \item{Country}{Listing Country}
#'   \item{n_com_educ}{Education}
#'   \item{n_com_hlth}{Education}
#'   \item{n_com_art}{Whether multinational, binary}
#'   \item{n_com_econ}{Specific industry, 30 categories}
#'   \item{n_com_agric}{Year of report, 2014 - 2018}
#'   \item{n_com_activism}{Year company listed on stock exchange, 1927 - 2018}
#'   \item{n_hr_safety}{Year company incorporated, 1852 - 2012}
#'   \item{n_hr_diversity}{Net profit reported, different various currencies}
#'   \item{n_hr_training}{Reported total assets at end of year, various local currencies}
#'   \item{n_hr_benefits}{Book value of equity, various local currencies}
#'   \item{n_hr_monitoring}{Estimated market value, various local currencies}
#'   \item{n_hr_satisfaction}{Community CSR variables, 22, 5-category variables}
#'   \item{n_prod_info}{Human resource CSR variables, 30, 5-category variables}
#'   \item{n_prod_quality}{... CSR variables, 30, 5-category variables}
#'   \item{n_ene_conservation}{Environmental CSR variables, 30, 5-category variables}
#'   \item{n_ene_policy}{Environmental CSR variables, 30, 5-category variables}
#'   \item{n_emi_policy}{... CSR variables, 30, 5-category variables}
#'   \item{n_emi_practice}{... CSR variables, 10, 5-category variables}
#'   \item{n_env_pollution}{Unclassified CSR variables, 6, 5-category variables}
#'   \item{n_env_conservation}{Existence of a social and evnironmental committee on board, binary}
#'   \item{n_env_policy}{Industrial sector relassification, 3 categories}
#'   \item{n_env_water}{Industrial sector relassification, 3 categories}
#'   \item{n_oth_other}{Industrial sector relassification, 3 categories}
#' }
#'
#' @source Data gathered from published company annual reports
#'
"pca_data"



#' CFP and organizational charactersitics data
#'
#' A dataset containing variables on CFP, CSR, and company characteristics
#' for 238 African companies spanning a period of 5 years (2014 to 2018)
#'
#' Note: some data was used from companies in the period before they
#' were officially listed  on teh stock exchange
#'
#' @format A data frame with 1195 rows and 110 variables:
#'
#' \describe{
#'   \item{Country}{Categorization of industry, 9 categories}
#'   \item{Multinational}{company name}
#'   \item{Sector}{Country of listing}
#'   \item{listing_age}{Whether multinational, binary}
#'   \item{incorp_age}{Specific industry, 30 categories}
#'   \item{lag_return_on_assets}{Year of report, 2014 - 2018}
#'   \item{lag_return_on_equity}{Year company listed on stock exchange, 1927 - 2018}
#'   \item{social_committee}{Year company incorporated, 1852 - 2012}
#'   \item{reporting_year}{Net profit reported, different various currencies}
#' }
#'
#' @source Data gathered from published company annual reports
#'
"reg_data"

#' CFP and organizational charactersitics data
#'
#' A dataset containing variables on CFP, CSR, and company characteristics
#' for 238 African companies spanning a period of 5 years (2014 to 2018)
#'
#' Note: some data was used from companies in the period before they
#' were officially listed  on teh stock exchange
#'
#' @format A data frame with 1195 rows and 110 variables:
#'
#' @source Data gathered from published company annual reports
#'
"pca_ind_scores"
