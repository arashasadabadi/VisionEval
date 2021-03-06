% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CreateEstimationDatasets.R
\docType{data}
\name{Hh_df}
\alias{Hh_df}
\title{Household data from Census PUMS}
\format{A data frame with 65988 rows and 17 variables (there may be a
different number of rows if PUMS datasets are used for different areas):
\describe{
  \item{Age0to14}{number of persons in 0 to 14 age group}
  \item{Age15to19}{number of persons in 15 to 19 age group}
  \item{Age20to29}{number of persons in 20 to 29 age group}
  \item{Age30to54}{number of persons in 30 to 54 age group}
  \item{Age55to64}{number of persons in 55 to 64 age group}
  \item{Age65Plus}{number of persons 65 years or older}
  \item{Wkr15to19}{number of workers in 15 to 19 age group}
  \item{Wkr20to29}{number of workers in 20 to 29 age group}
  \item{Wkr30to54}{number of workers in 30 to 54 age group}
  \item{Wkr55to64}{number of workers in 55 to 64 age group}
  \item{Wkr65Plus}{number of workers 65 years or older}
  \item{AvePerCapInc}{average per capita income of PUMA, nominal $}
  \item{HouseType}{housing type (SF = single family, MF = multifamily)}
  \item{Income}{annual household income, nominal 1999$}
  \item{HhSize}{number of persons in household}
  \item{HhType}{household type (Reg = regular household, Grp = group quarters)}
  \item{HhWeight}{household sample weight}
}}
\source{
CreateEstimationDatasets.R script.
}
\usage{
Hh_df
}
\description{
A household dataset containing the data used for estimating the
CreateHouseholds, PredictWorkers, PredictLifeCycle, PredictIncome, and
PredictHouseType modules derived from from year 2000 PUMS data for Oregon.
}
\keyword{datasets}
