% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Make2001NHTSDataset.r
\docType{data}
\name{HhTours_df}
\alias{HhTours_df}
\title{Household tour dataset from the 2001 National Household Travel Survey}
\format{An object of class \code{data.frame} with 154270 rows and 16 columns.}
\usage{
HhTours_df
}
\description{
A dataset of household tours (shared person tours) derived from the 2001
National Household Travel Survey and used in the estimation of several
VisionEval models.
}
\details{
@format A data frame with 154270 rows and 16 columns.
 \describe{
   \item{Houseid}{Unique household ID}
   \item{Distance}{Total distance in miles of the tour}
   \item{TravelTime}{Total time in minutes spent traveling on the tour}
   \item{DwellTime}{Total time in minutes spent at activities on the tour}
   \item{StartHome}{Logical identifying if the tour started at home}
   \item{EndHome}{Logical identifying if the tour ended at home}
   \item{Trips}{Number of trips in the tour}
   \item{Persons}{Number of persons on the tour}
   \item{Vehid}{Unique ID for vehicle in household}
   \item{Trptrans}{Mode of transportation (see 2001 NHTS codebook for TRPTRANS)}
   \item{Vehtype}{Type of vehicle used (see 2001 NHTS codebook for VEHTYPE)}
   \item{HhVehUsed}{Whether household vehicle used (1=yes, 2=no)}
   \item{Whyto}{String contenating successive activity codes at trip end (see 2001 NHTS codebook for WHYTO)}
   \item{Disttowk}{Distance from home to work for the person on the tour who works farthest from home}
   \item{Mode}{Simplified travel mode category (see script for definitions)}
   \item{IncludesWork}{Logical identifying whether tour includes a work activity (codes 10, 11, 12, 13, 14)}
 }
 @source 2001 National Household Travel Survey and Make2001NHTSDataset.R script.
}
\keyword{datasets}
