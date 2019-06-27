download_saalfeldlab_registrations <- function(fileformat = '.h5') {

  if (fileformat == '.nii'){
    download_url <- "https://ndownloader.figshare.com/files/12919949?private_link=85b2f2e4f479c94441f2"
    download_filename <- 'download_reg.zip'
    search_pattern <- "0GenericAffine.mat$"
  } else if (fileformat == '.h5'){
    download_url <- "https://ndownloader.figshare.com/files/14362754?private_link=3a8b1d84c5e197edc97c"
    download_filename <- 'JRC2018F_FAFB.h5'
    search_pattern <- ".h5$"
  }

  #Step1: Check if options for folder path are set, if not set it here..
  if (is.null(getOption('nat.jrcbrains.regfolder'))){
      options(nat.jrcbrains.regfolder='/GD/projects/JFRC/JohnBogovic/jrc-2018-brain-templates')}
  #Step2: check if folder path exists..
  if (!dir.exists(options('nat.jrcbrains.regfolder')[[1]])){
      #Create the folder path now..
      dir.create(options('nat.jrcbrains.regfolder')[[1]], recursive = TRUE, showWarnings = TRUE)
  }
  #Step3: Download the file to the folder..
  utils::download.file(download_url,file.path(options('nat.jrcbrains.regfolder')[[1]], download_filename))
  if (download_filename == 'download_reg.zip'){
      utils::unzip(file.path(options('nat.jrcbrains.regfolder')[[1]], download_filename),
                    exdir = options('nat.jrcbrains.regfolder')[[1]])
      unlink(file.path(options('nat.jrcbrains.regfolder')[[1]], download_filename))}

  #Step4: Put them in a specific project folder..
  file_name <- list.files(path = options('nat.jrcbrains.regfolder')[[1]],
                         pattern = search_pattern, recursive = TRUE)
  matchnames <- stringr::str_match(file_name, paste0("^([^_]+)_([^_]+)",search_pattern))
  folder_name <- paste0(matchnames[2],'_',matchnames[3])
  folder_path <- file.path(options('nat.jrcbrains.regfolder')[[1]],folder_name)
  dir.create(folder_path, recursive = FALSE, showWarnings = TRUE)

  files_target <- setdiff(list.files(options('nat.jrcbrains.regfolder')[[1]],folder_name),
                          folder_name)
  result <- file.copy(file.path(options('nat.jrcbrains.regfolder')[[1]],files_target),
            file.path(options('nat.jrcbrains.regfolder')[[1]],folder_name))
  unlink(file.path(options('nat.jrcbrains.regfolder')[[1]],files_target))

}

#' Register Saalfeld Lab registrations with nat.templatebrains
#'
#' @details You must manually download the registrations from
#'   \url{https://www.janelia.org/open-science/jrc-2018-brain-templates} to a
#'   single folder. You may wish to set \code{nat.jrcbrains.regfolder} to point
#'   to this folder in your \code{\link{Rprofile}}.
#' @param x A folder containing downloaded Saalfeld lab registrations
#' @param ... Additional arguments passed to
#'   \code{\link{add_saalfeldlab_reglist}} and eventually to
#'   \code{\link{add_reglist}}
#'
#' @return A named logical vector indicating which of the subfolders was
#'   successfully registered with \code{\link{nat.templatebrains}}
#' @export
#'
#' @examples
#' \dontrun{
#' options(nat.jrcbrains.regfolder='/GD/projects/JFRC/JohnBogovic/jrc-2018-brain-templates')
#' register_saalfeldlab_registrations()
#' }
#' @references See Bogovic et al. (2018) \url{https://doi.org/10.1101/376384}
register_saalfeldlab_registrations <- function(x=getOption('nat.jrcbrains.regfolder'),
                                               ...) {
  if(is.null(x)) stop("You must pass a folder containing registrations or set\n",
                      "options(nat.jrcbrains.regfolder='/path/to/reg/folder')")

  dirs=list.dirs(x, recursive = F)
  sapply(dirs, add_saalfeldlab_reglist, ...)
}

#' Register single ANTs registration folder
#'
#' @param x Path to a single ANTs registration folder named according to
#'   Saalfeld conventions
#' @param ... Additional arguments passed to \code{\link{add_reglist}}
#'
#' @importFrom nat reglist
#' @importFrom nat.templatebrains add_reglist
#' @importFrom nat.ants as.antsreg
add_saalfeldlab_reglist <- function(x, ...) {
  ar = try(as.antsreg(x), silent = TRUE)
  if (inherits(ar, 'try-error')) {
    warning(x, " does not seem to be an ANTs registration folder!")
    return(FALSE)
  }
  bx = basename(x)
  brainnames = stringr::str_match(bx, "^([^_]+)_([^_]+)$")
  if (any(is.na(brainnames))) {
    warning("Unable to identify the brain spaces linked by: ", bx)
    return(FALSE)
  }

  # These registrations all assume that FAFB is calibrate in microns,
  # whereas FAFB14 registration
  if (any(brainnames == 'FAFB')) {
    brainnames[brainnames == "FAFB"] = 'FAFB14um'
    add_reglist(reglist(diag(c(1e3, 1e3, 1e3, 1))),
                reference = "FAFB14",
                sample = "FAFB14um")
  }

  # Bogovic et al seem to have a difference in Z calibration
  if (any(brainnames == 'JFRC2010')) {
    add_reglist(reglist(diag(c(1, 1, 1/0.6220880, 1))),
                reference = "JFRC2010",
                sample = "JFRC2")
  }

  add_reglist(reglist(ar),
              reference = brainnames[2],
              sample = brainnames[3], ...)
  ar2 = try(as.antsreg(x, inverse = TRUE), silent = TRUE)
  if (inherits(ar2, 'try-error')) {
    warning(x, " does not seem to contain a valid inverse ANTs registration!")
    return(FALSE)
  }
  add_reglist(reglist(ar2),
              reference = brainnames[3],
              sample = brainnames[2],
              ...)
  TRUE
}
#
