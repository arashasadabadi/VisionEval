% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/initialization.R
\name{processModuleSpecs}
\alias{processModuleSpecs}
\title{Process module specifications to expand items with multiple names.}
\usage{
processModuleSpecs(Spec_ls)
}
\arguments{
\item{Spec_ls}{A specifications list.}
}
\value{
A standard specifications list with expansion of the multiple item
specifications.
}
\description{
\code{processModuleSpecs} a visioneval framework control function that
processes a full module specifications list, expanding all elements in the
Inp, Get, and Set components by parsing the UNITS attributes and duplicating
every specification which has multiple values for the NAME attribute.
}
\details{
This function process a module specification list. If any of the
specifications include multiple listings of data sets (i.e. fields) in a
table, this function expands the listing to establish a separate
specification for each data set.
}
