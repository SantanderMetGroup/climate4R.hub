% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loadHubData.R
\name{loadHubData}
\alias{loadHubData}
\title{Load a grid from a dataset stored in the Atlas hub}
\usage{
loadHubData(
  dataset,
  var,
  dictionary = FALSE,
  lonLim = NULL,
  latLim = NULL,
  season = NULL,
  years = NULL,
  members = NULL,
  time = "none",
  aggr.d = "none",
  aggr.m = "none",
  condition = NULL,
  threshold = NULL
)
}
\arguments{
\item{dataset}{A character string indicating the database to be accessed. This is usually a path to a local file or a URL 
pointing to a netCDF or NcML file in the case of netCDF and/or gridded datasets. For station data in standard ASCII format,
this is the path to the directory the dataset lives in.}

\item{var}{Variable code (character string). This is the name of the variable according to the R standard naming
(see the next argument). For variables with vertical levels, the vertical level is specified next to the variable name followed
 by the \dQuote{@} symbol (e.g. \code{var = "z@700"} for geopotential heigth at 700 mb isobaric surface pressure level).
 It is also possible to enter the variable name as originally coded in the dataset to skip data homogenization.}

\item{dictionary}{Default to FALSE, if TRUE a dictionary is used and the .dic file is stored in the same path than the
dataset. If the .dic file is stored elsewhere, then the argument is the full path to the .dic file (including the extension,
e.g.: \code{"/path/to/the/dictionary_file.dic"}). This is the case for instance when the dataset is stored in a remote URL,
and we have a locally stored dictionary for that particular dataset. If FALSE no variable homogenization takes place,
and the raw variable, as originally stored in the dataset, will be returned. See details for dictionary specification.}

\item{lonLim}{Vector of length = 2, with minimum and maximum longitude coordinates, in decimal degrees, of the bounding box selected.
For single-point queries, a numeric value with the longitude coordinate. If \code{NULL} (default), the whole longitudinal range
 is selected (Note that this may lead to a large output object size).}

\item{latLim}{Same as \code{lonLim}, but for the selection of the latitudinal range.}

\item{season}{An integer vector specifying the desired season (in months, January = 1 ..., December = 12).
Options include one to several (contiguous) months. Default to \code{NULL}, indicating a full year selection (same as \code{season = 1:12}).}

\item{years}{Optional vector of years to select. Default (\code{NULL}) to all available years. If the requested variable is static (e.g. orography)
it will be ignored.}

\item{members}{A vector of integers indicating the members to be loaded.
Default to \code{NULL}, which loads all available members if the dataset contains members (i.e. in case a Ensemble Axis is defined).
For instance, \code{members=1:5} will retrieve the first five members of dataset.
 Note that unlike \code{\link{loadSeasonalForecast}}, discontinuous member selections (e.g. \code{members=c(1,5,7)}) are NOT allowed. 
 If the requested dataset has no Ensemble Axis (or it is a static field, e.g. orography) it will be ignored.}

\item{time}{A character vector indicating the temporal filtering/aggregation 
of the output data. Default to \code{"none"}, which returns the original time 
series as stored in the dataset. For sub-daily variables, instantantaneous data at 
selected verification times can be filtered using one of the character strings 
\code{"00"}, \code{"03"}, \code{"06"}, \code{"09"}, \code{"12"}, \code{"15"},
 \code{"18"}, \code{"21"},and \code{"00"} when applicable. If daily aggregated data are 
required use \code{"DD"}. If the requested variable is static (e.g. orography) it will be ignored. 
See the next arguments for time aggregation options.}

\item{aggr.d}{Character string. Function of aggregation of sub-daily data for daily data calculation. 
Currently accepted values are \code{"none"}, \code{"mean"}, \code{"min"}, \code{"max"} and \code{"sum"}.}

\item{aggr.m}{Same as \code{aggr.d}, bun indicating the aggregation function to compute monthly from daily data.
If \code{aggr.m = "none"} (the default), no monthly aggregation is undertaken.}

\item{condition}{Optional, only needed if absolute/relative frequencies are required. Inequality operator to be applied considering the given threshold.
\code{"GT"} = greater than the value of \code{threshold}, \code{"GE"} = greater or equal,
 \code{"LT"} = lower than, \code{"LE"} = lower or equal than}

\item{threshold}{Optional, only needed if absolute/relative frequencies are required. A float number defining the threshold
used by  \code{condition} (the next argument).}
}
\value{
A list with the following elements providing the necessary information 
for data representation and analysis:
\item{\code{Variable }}{A list with three elements:}
     \itemize{ 
           \item \code{varName} A character string indicating which is the variable returned. 
           Same as value provided for argument \code{var}
           \item \code{isStandard} Logical value indicating whether the variable returned 
           is standard or not (i.e., wether the dictionary has been used or not.)
           \item \code{level} A numeric value indicating the vertical level of the variable 
           (\code{NULL} for 2D variables)
     }
\item{\code{Data }}{A N-dimensional array. The number of dimensions (N) depends on the 
type of request given that dimensions of length one are dropped. Thus, N can take values 
from 4 (several members for a rectangular domain with different values for longitude, latitude, 
ensemble and time dimensions) to 1 (atomic vector), for single-point and single-member selections, 
for which only the time dimension is required. The dimensions are labelled by the \dQuote{dimnames} attribute. 
Note that the order of the dimensions is not fixed.}
\item{\code{xyCoords }}{A list with \code{x} and \code{y} components, as required by many standard 
mapping functions in R (see \code{\link[grDevices]{xy.coords}}. In addition, the attribute \code{projection} 
provides geo-referencing information as stored in the original dataset.}
\item{\code{Dates }}{A list with two \code{\link[base]{POSIXct}} time elements of the same length as the
 \sQuote{time} dimension in \code{Data}, defining the time boundaries of the time axis coordinates in the
  interval \emph{[start, end)}, or if the loaded field is static, a character string indicating it.}
}
\description{
Load a user-defined spatio-temporal slice from a dataset which is stored in the Atlas hub.
}
\note{
The function assumes that you are working from the Atlas hub and the user has read permissions to the shared directory.
To load data not stored in the Atlas hub, the user should rely on \code{\link[loadeR]{loadGridData}}
}
\section{Variable homogenization}{
 

The different nature of the various databases, models and variables, 
and the idiosyncratic naming and storage conventions often applied by the different 
modelling centres, makes necessary a previous homogeneization across datasets in 
order to implement a truly user-friendly toolbox for data access. 
This package achieves this aim by defining a common \code{vocabulary} to all 
climate datasets. The particular variables of each dataset are translated -and transformed if necessary- 
to the standard variables by means of a dictionary, provided by the argument \code{dictionary}.
In essence, the \file{dictionary} is a csv file particular for each individual dataset, 
containing the necessary information for performing the unit conversions to match the standard variable 
definitions contained in the vocabulary (see \code{\link{C4R.vocabulary}}). This feature is described in more detail
 in the \href{https://github.com/SantanderMetGroup/loadeR/wiki/Harmonization}{loadeR wiki}..
}

\section{Temporal filtering and aggregation}{


The argument \code{time} controls the temporal filtering/aggregation options that may apply for a variable.
    In case of daily mean data, this can be obtained in two different ways:
       \enumerate{
       \item For variables that are already stored as daily means in the dataset, both \code{"DD"} and \code{"none"}
        return the required daily output
      \item In case of subdaily data, if \code{"DD"} is chosen, the function will compute the daily value using the
       aggregation function indicated in the argument \code{aggr.d}, printing an information message on screen.
        This function is normally the \code{"mean"} providing daily averages, although if the variable is a flux 
        (e.g. precipitation or radiation, (\code{var} = \code{"tp"}, \code{"rsds"} or \code{"rlds"} using the standard UDG naming),
         the aggregation function may be \code{"sum"} (i.e., it will return the daily accumulated value).
         In the same way, if the variable is a daily maximum/minimum (i.e., \code{var = "tasmax"} / \code{var = "tasmin"}), 
         the corresponding function (\code{aggr.d = "max"} or \code{aggr.d = "min"}) could be applied to the subdaily outputs
          on a daily basis to obtain absolute maximum/minimum daily values.
          }
}

\section{Geolocation parameters}{


 Regarding the selection of the spatial domain,
 it is possible to select the whole spatial domain of the dataset by defining the arguments \code{lonLim=NULL}
 and \code{latLim=NULL}. More often, rectangular domains are defined by the minimum and maximum coordinates
 in longitude and latitude (for instance \code{lonLim=c(-10,10)} and \code{latLim=c(35,45)} indicates a
 rectangular window centered in the Iberian Peninsula), and single grid-cell values
 (for instance \code{lonLim=-3.21} and \code{latLim=41.087} for retrieving the data in the closest grid
 point to the point coordinate -3.21E, 41.087N. In the last two cases, the function
 operates by finding the nearest (euclidean distance) grid-points to the coordinates introduced.
 
 In the case of station data (\code{\link{loadStationData}}), the logic is the same, taking into account that in the case
 of rectangular domains, all stations falling inside that window will be loaded. For single-point selections,
 the closest station will be chosen, and a note on-screen will inform about the distance from the selected point
 to the chosen station.
 
 In case of irregular grids (e.g. the typical RCM rotated pole projections), the regular coordinates are included in the
 \code{x} and \code{y} elements of the \code{xyCoords} list, while the corresponding geographical coordinates are insode two matrices inside 
 the \code{lon} and \code{lat} elements.
}

\author{
J Baño-Medina
}
