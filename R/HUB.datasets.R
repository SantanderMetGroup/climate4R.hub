#' @title Show the datasets available on the IPCC hub
#' @description Lists the harmonized datasets that are accessible from the IPCC hub. 
#' @param pattern Optional. Pattern in the dataset name as passed to function \code{\link{grep}} (case-insensitive).
#' @param full.info Default to FALSE. If TRUE, the complete URL is also displayed.
#' @return The datasets table, in the form of a \code{data.frame}
#' @note The function assumes that the user has read permission to the package installation directory
#' @author J Baño-Medina
#' @export
#' @importFrom utils read.csv
#' @examples
#' # Default built-in datasets
#' str(HUB.datasets())
#' (sets <- HUB.datasets())
#' names(sets)
#' sets$OBSERVATIONS
#' # Using argument pattern
#' HUB.datasets(pattern = "E-OBS.*v21")
#' # Showing the full Url of the datasets
#' HUB.datasets(pattern = "E-OBS", full.info = TRUE)

UDG.datasets <- function(pattern = "", full.info = FALSE) {
  lf <- list.files(file.path(find.package("climate4R.hub")), pattern = "datasets.*.txt", full.names = TRUE)
  df <- lapply(lf, function(x) read.csv(x, stringsAsFactors = FALSE)[ ,1:3])
  names(df) <- gsub(lf, pattern = ".*/datasets_|.txt", replacement = "")
  matchlist <- lapply(df, function(x) x[grep(pattern, x$name, ignore.case = TRUE),])
  sublist <- matchlist[unlist(lapply(matchlist, function(x) nrow(x) != 0))]
  if (pattern != "") message("Matches found for: ", paste(names(sublist), collapse = " "))
  if (!full.info) message("Label names are returned, set argument full.info = TRUE to get more information")
  if (full.info) {
    return(sublist)
  } else {
    return(lapply(sublist, function(x) x[["name"]]))
  }
}
