#' Download Saalfeld Lab registrations
#'
#' @param fileformat whether to download h5 (Saalfeld) or nii (ANTs) format
#'   registrations (defaults to h5).
#'
#' @details Registrations will be downloaded from
#'   \url{https://www.janelia.org/open-science/jrc-2018-brain-templates}. They
#'   will be downloaded to a folder defined by the package option
#'   \code{nat.templatebrains.regdirs} (see examples).
#'
#'   The h5 registration format typically provides a multi-resolution forward
#'   and inverse transformations in an efficiently compressed format. See
#'   \url{https://github.com/saalfeldlab/template-building/wiki/Hdf5-Deformation-fields}
#'    for further details.
#'
#'   The nii (NIfTI) files are the raw output format of the ANTs registration
#'   package. Their disadvantages are that they are 1) large files and the whole
#'   >500 Mb registration file must be loaded completely into memory before any
#'   transformations are possible, 2) that they depend on a more complex set of
#'   packages that can be hard to install, 3) is not simple to downsample to
#'   make smaller files. They do have the advantage of support for transforming
#'   image data as well as 3D points.
#'
#'
#' @export
#' @importFrom rappdirs user_data_dir
#' @importFrom curl curl_download
#' @seealso \code{\link{register_saalfeldlab_registrations}}
#' @examples
#' regroot=getOption('nat.templatebrains.regdirs')
#' dir(regroot)
download_saalfeldlab_registrations <- function(fileformat = c('.h5', '.nii')) {
  fileformat=match.arg(fileformat)

  if (fileformat == '.nii'){
    check_ants()
    #Support for JRC2018F_FAFB, JRC2018F_JFRC2013, JRC2018F_FCWB
    download_urls <-
      paste0(
        "https://ndownloader.figshare.com/files/",
        c(
          "12919949?private_link=85b2f2e4f479c94441f2",
          "12919832?private_link=a15a5cc56770ec340366",
          "12919868?private_link=6702242e17c564229874"
        )
      )

    download_filename <- rep('download_reg.zip', length(download_urls))
    search_pattern <- c("0GenericAffine.mat$","GenericAffine.mat$","0GenericAffine.mat$")
    regexpattern <- c("^([^_]+)_([^_]+)",
                      "^([^_]+)_([^_]+)_",
                      "^([^_]+)_([^_]+)_")
  } else if (fileformat == '.h5'){
    #Support for JRC2018F_FAFB, JRC2018F_JFRC2013, JRC2018F_FCWB
    download_urls <- paste0(
      "https://ndownloader.figshare.com/files/",
      c(
        "14362754?private_link=3a8b1d84c5e197edc97c",
        "14368703?private_link=2a684586d5014e31076c",
        "14369093?private_link=d5965dad295e46241ae1",
        "21749535?private_link=ca603876efb33fdf3028"
      )
    )

    download_filename <-
      c(
        'JRC2018F_FAFB.h5',
        'JRC2018F_JFRC2013.h5',
        'JRC2018F_FCWB.h5',
        'JRC2018F_JRCFIB2018F.h5'
      )
    search_pattern <- rep(".h5$", length(download_urls))
    regexpattern <- rep("^([^_]+)_([^_]+)", length(download_urls))
  }

  #Step 1: check if folder path exists..
  if (!dir.exists(getOption('nat.jrcbrains.regfolder'))){
    message("Creating folder: ", getOption('nat.jrcbrains.regfolder'))
    dir.create(getOption('nat.jrcbrains.regfolder'), recursive = TRUE, showWarnings = FALSE)
  }

  #Step 2: Download the files to the folder..
  if(length(download_urls))
    message("Downloading files to: ", getOption('nat.jrcbrains.regfolder'))
  for (download_fileidx in 1:length(download_urls)){
    message("Processing: ", download_filename[download_fileidx],
            " (file ", download_fileidx, "/", length(download_urls), ")")
    curl_download(download_urls[download_fileidx],
                  file.path(getOption('nat.jrcbrains.regfolder'),
                            download_filename[download_fileidx]),
                  quiet=FALSE)
    if (download_filename[download_fileidx] == 'download_reg.zip') {
      utils::unzip(file.path(getOption('nat.jrcbrains.regfolder'),
                             download_filename[download_fileidx]),
                   exdir = getOption('nat.jrcbrains.regfolder'))
      unlink(file.path(getOption('nat.jrcbrains.regfolder'),
                       download_filename[download_fileidx]))
    }

    file_name <- list.files(path = getOption('nat.jrcbrains.regfolder'),
                            pattern = search_pattern[download_fileidx], recursive = FALSE)
    matchnames <- stringr::str_match(file_name, paste0(regexpattern[download_fileidx],
                                                       search_pattern[download_fileidx]))
    folder_name <- paste0(matchnames[2],'_',matchnames[3])
    folder_path <- file.path(getOption('nat.jrcbrains.regfolder'),folder_name)
    dir.create(folder_path, recursive = FALSE, showWarnings = FALSE)

    files_target <- setdiff(list.files(getOption('nat.jrcbrains.regfolder'),folder_name),
                            folder_name)
    result <- file.copy(file.path(getOption('nat.jrcbrains.regfolder'),files_target),
              file.path(getOption('nat.jrcbrains.regfolder'),folder_name))
    unlink(file.path(getOption('nat.jrcbrains.regfolder'),files_target))
  }
}

#' Register Saalfeld Lab registrations with nat.templatebrains
#'
#' @details You must download the registrations from
#'   \url{https://www.janelia.org/open-science/jrc-2018-brain-templates} using
#'   \code{\link{download_saalfeldlab_registrations}}. If you prefer you may
#'   also download them manually to to a single folder, setting
#'   \code{options(nat.jrcbrains.regfolder)} to point to this folder in your
#'   \code{\link{Rprofile}}.
#' @param x A folder containing downloaded Saalfeld lab registrations
#' @param ... Additional arguments passed to
#'   \code{\link{add_saalfeldlab_reglist}} and eventually to
#'   \code{\link{add_reglist}}
#'
#' @return A named logical vector indicating which of the subfolders was
#'   successfully registered with \code{\link{nat.templatebrains}}
#' @seealso \code{\link{download_saalfeldlab_registrations}}
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

  dirs=list_saalfeldlab_registrations(x)
  sapply(dirs, add_saalfeldlab_reglist, ...)
}

list_saalfeldlab_registrations <- function(x=getOption('nat.jrcbrains.regfolder')) {
  list.dirs(x, recursive = F)
}

#' Register single ANTs registration folder
#'
#' @param x Path to a single ANTs registration folder named according to
#'   Saalfeld conventions
#' @param ... Additional arguments passed to \code{\link{add_reglist}}
#'
#' @importFrom nat reglist
#' @importFrom nat.templatebrains add_reglist
add_saalfeldlab_reglist <- function(x, ...) {
  reg=foldertoreg(x)
  bx = basename(x)
  status <-  FALSE
  brainnames = stringr::str_match(bx, "^([^_]+)_([^_]+)$")
  if (any(is.na(brainnames))) {
    warning("Unable to identify the brain spaces linked by: ", bx)
    return(status)
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

  add_reglist(reglist(reg),
              reference = brainnames[2],
              sample = brainnames[3], ...)
  message("Adding ",class(reg) ," in " , "forward direction")
  reg2=foldertoreg(x, inverse = TRUE)

  add_reglist(reglist(reg2),
              reference = brainnames[3],
              sample = brainnames[2],
              ...)
  message("Adding ",class(reg2) ," in " , "reverse direction")
  status <-  TRUE
}
#

foldertoreg <- function(folder, inverse=FALSE){
  ff = dir(folder, full.names = TRUE)
  exts= tools::file_ext(ff)
  if(any('h5' %in% exts)){
    h5file=ff[exts=='h5']

    if(length(h5file) >1)
      message("More than one .h5 file is present in ", folder)
    reg=nat.h5reg::h5reg(h5file, swap=inverse)
  } else {
    check_ants()
    reg = try(nat.ants::as.antsreg(folder, inverse=inverse), silent = TRUE)
    if (inherits(reg, 'try-error')) {
      stop(folder, " does not seem to be a valid",
           ifelse(inverse, "inverse", "forward"),
           "ANTs registration folder!")
    }
  }
  reg
}

check_ants <- function() {
  if(!requireNamespace('nat.ants', quietly = TRUE))
    stop("You must install the nat.ants package in order to use ANTs (nii) format registrations!\n",
         "Please see https://github.com/jefferis/nat.ants for details")
}

delete_saalfeldlab_registrations <- function(){
  x=getOption('nat.jrcbrains.regfolder')
  unlink(file.path(x,'.'),recursive = TRUE)
}
