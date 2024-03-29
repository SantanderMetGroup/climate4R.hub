% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hubDataInventory.R
\name{hubDataInventory}
\alias{hubDataInventory}
\title{Dataset inventory of the Atlas hub datasets}
\usage{
hubDataInventory(dataset, return.stats = FALSE)
}
\arguments{
\item{dataset}{A character string poiting to the target. Either a directory containing the data
in the case of station data in standard ASCII format (see \code{\link{loadStationData}}) for details),
or a target file (a NcML) in the case of other types of gridded data (reanalysis, gridded observations ...,
see \code{\link{loadGridData}} for details).}

\item{return.stats}{Optional logical flag indicating if summary statistics of the dataset
should be returned with the inventory. Only used for station data.}
}
\value{
A list of components describing the variables and other characteristics of the target dataset.
}
\description{
Function to provide a quick overview of a climate dataset
 (either stations or gridded data) stored in the Atlas hub.
}
\note{
The variable names returned correspond to the original names of the variables as stored in the dataset,
and not to the standard naming convention defined in the vocabulary.
}
\author{
J Baño-Medina
}
