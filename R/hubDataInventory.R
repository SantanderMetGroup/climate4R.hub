# hubDataInventory.R Get an overview of the contents of a dataset
#
#     Copyright (C) 2016 Santander Meteorology Group (http://www.meteo.unican.es)
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
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' @title Dataset inventory of the Atlas hub datasets
#' @description Function to provide a quick overview of a climate dataset
#'  (either stations or gridded data) stored in the Atlas hub.
#' @param dataset A character string poiting to the target. Either a directory containing the data
#'  in the case of station data in standard ASCII format (see \code{\link{loadStationData}}) for details),
#'  or a target file (a NcML) in the case of other types of gridded data (reanalysis, gridded observations ...,
#'  see \code{\link{loadGridData}} for details).
#' @param return.stats Optional logical flag indicating if summary statistics of the dataset
#'  should be returned with the inventory. Only used for station data.
#' @return A list of components describing the variables and other characteristics of the target dataset.
#' @note The variable names returned correspond to the original names of the variables as stored in the dataset,
#' and not to the standard naming convention defined in the vocabulary.
#' @export
#' @importFrom loadeR dataInventory
#' @author J Baño-Medina 

hubDataInventory <- function(dataset, return.stats = FALSE) {
  lf <- list.files(file.path(find.package("climate4R.hub")), pattern = "datasets.*.txt", full.names = TRUE)
  df <- lapply(lf, function(x) read.csv(x, stringsAsFactors = FALSE))
  df <- do.call("rbind", df)
  ind.row <- which(df$name == dataset)
  path <- df$url[ind.row]

  # LoadGridData
  dataInventory(path, return.stats = return.stats) 
}