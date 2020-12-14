#     loadHubData.R Load a user-defined spatio-temporal slice from a gridded dataset
#
#     Copyright (C) 2018 Santander Meteorology Group (http://www.meteo.unican.es)
#
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program. If not, see <http://www.gnu.org/licenses/>.


#' @title Load a grid from a dataset stored in the Atlas hub
#' @description Load a user-defined spatio-temporal slice from a dataset which is stored in the Atlas hub.
#' @template templateParams
#' @param members A vector of integers indicating the members to be loaded.
#'  Default to \code{NULL}, which loads all available members if the dataset contains members (i.e. in case a Ensemble Axis is defined).
#'  For instance, \code{members=1:5} will retrieve the first five members of dataset.
#'   Note that unlike \code{\link{loadSeasonalForecast}}, discontinuous member selections (e.g. \code{members=c(1,5,7)}) are NOT allowed. 
#'   If the requested dataset has no Ensemble Axis (or it is a static field, e.g. orography) it will be ignored.
#' @param dictionary Default to FALSE, if TRUE a dictionary is used and the .dic file is stored in the same path than the
#' dataset. If the .dic file is stored elsewhere, then the argument is the full path to the .dic file (including the extension,
#' e.g.: \code{"/path/to/the/dictionary_file.dic"}). This is the case for instance when the dataset is stored in a remote URL,
#' and we have a locally stored dictionary for that particular dataset. If FALSE no variable homogenization takes place,
#' and the raw variable, as originally stored in the dataset, will be returned. See details for dictionary specification.
#' @param time A character vector indicating the temporal filtering/aggregation 
#' of the output data. Default to \code{"none"}, which returns the original time 
#' series as stored in the dataset. For sub-daily variables, instantantaneous data at 
#' selected verification times can be filtered using one of the character strings 
#' \code{"00"}, \code{"03"}, \code{"06"}, \code{"09"}, \code{"12"}, \code{"15"},
#'  \code{"18"}, \code{"21"},and \code{"00"} when applicable. If daily aggregated data are 
#' required use \code{"DD"}. If the requested variable is static (e.g. orography) it will be ignored. 
#' See the next arguments for time aggregation options.
#' @param aggr.d Character string. Function of aggregation of sub-daily data for daily data calculation. 
#' Currently accepted values are \code{"none"}, \code{"mean"}, \code{"min"}, \code{"max"} and \code{"sum"}.
#' @param aggr.m Same as \code{aggr.d}, bun indicating the aggregation function to compute monthly from daily data.
#' If \code{aggr.m = "none"} (the default), no monthly aggregation is undertaken.
#' @param threshold Optional, only needed if absolute/relative frequencies are required. A float number defining the threshold
#'  used by  \code{condition} (the next argument).
#' @param condition Optional, only needed if absolute/relative frequencies are required. Inequality operator to be applied considering the given threshold.
#'  \code{"GT"} = greater than the value of \code{threshold}, \code{"GE"} = greater or equal,
#'   \code{"LT"} = lower than, \code{"LE"} = lower or equal than
#' @template templateReturnGridData
#' @template templateDicDetails  
#' @template templateTimeAggr
#' @template templateGeolocation
#' @note The function assumes that you are working from the Atlas hub and the user has read permissions to the shared directory.
#' To load data not stored in the Atlas hub, the user should rely on \code{\link[loadeR]{loadGridData}} 
#' @author J Baño-Medina
#' @export
#' @importFrom utils read.csv
#' @importFrom loadeR loadGridData
#' @examples
#' library(loadeR)
#' HUB.datasets()
#' # Example with E-OBS v21
#' HUB.datasets(pattern = "E-OBS.*v21")
#' url <- loadHubData("E-OBS_v21e_0.10regular", years = 2000, var = "pr")

loadHubData <- function(dataset,
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
                        threshold = NULL) {
  lf <- list.files(file.path(find.package("climate4R.hub")), pattern = "datasets.*.txt", full.names = TRUE)
  df <- lapply(lf, function(x) read.csv(x, stringsAsFactors = FALSE))
  df <- do.call("rbind", df)
  ind.row <- which(df$name == dataset)
  path <- df$url[ind.row]
  dic.filename <- df$dic[ind.row]
  dictionary <- file.path(find.package("climate4R.hub"), "dictionaries", dic.filename)
  if (dic.filename == "FALSE") dictionary <- FALSE
  
  # LoadGridData
  loadGridData(dataset = path,
               var = var,
               dictionary = dictionary,
               lonLim = lonLim,
               latLim = latLim,
               season = season,
               years = years,
               members = members,
               time = time,
               aggr.d = aggr.d,
               aggr.m = aggr.m,
               condition = condition,
               threshold = threshold)
}
