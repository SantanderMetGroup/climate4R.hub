#' @title Show the datasets available on the IPCC hub
#' @description Lists the harmonized datasets that are accessible from the IPCC hub. 
#' @param label Optional. Pattern in the dataset name as passed to function \code{\link{grep}} (case-insensitive).
#' @return The datasets table, in the form of a \code{data.frame}
#' @note The function assumes that the user has read permission to the package installation directory
#' @author J Baño-Medina
#' @export
#' @importFrom utils read.csv
#' @examples
#' # Example with E-OBS v21
#' # library(loadeR)
#' # url <- loadHubData("E-OBS")
#' # data <- loadGridData(dataset = url, years = 2000)

loadHubData <- function(dataset = label,
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
                        threshold = NULL,
                        spatialTolerance = NULL) {
  lf <- list.files(file.path(find.package("climate4R.hub")), pattern = "datasets.*.txt", full.names = TRUE)
  df <- lapply(lf, function(x) read.csv(x, stringsAsFactors = FALSE))
  df <- do.call("rbind", df)
  ind.row <- which(df$name == label)
  url <- df$url[ind.row]
  dic <- df$dic[ind.row]
  # Meter el diccionario...
  # dic.filename <- df$dic[rev(datasetind)][1]
  # dictionary <- file.path(find.package("climate4R.hub"), "dictionaries", dic.filename)
  # aux.var <- if (!is.null(aux.level$level)) paste0(aux.level$var, "@", aux.level$level, collapse = "")
  # cd <- tryCatch({check.dictionary(dataset, aux.var, dictionary, time)}, error = function(err) {list(shortName = NULL, dic = NULL)})
  # if (is.null(cd[["shortName"]])) cd <- check.dictionary(dataset, var, dictionary, time)
  # if (is.null(cd[["dic"]]) & !is.null(cd[["shortName"]])) {
  #   if (grepl("@", cd[["shortName"]])) {
  #     cd <- check.dictionary(dataset, var, dictionary, time)
  #   }
  # }
  
  # LoadGridData
  loadGridData(dataset = url,
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
               threshold = threshold,
               spatialTolerance = spatialTolerance)
}
