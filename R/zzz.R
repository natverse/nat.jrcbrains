.onLoad <- function(libname, pkgname) {

  if (is.null(getOption('nat.jrcbrains.regfolder'))){
    options(nat.jrcbrains.regfolder=rappdirs::user_data_dir('R/nat.jrcbrains'))
  }

  invisible()
}

.onAttach <- function(libname, pkgname) {
  # see if we've got anything that looks like our standard registrations
  havereg=FALSE
  regroot=getOption('nat.jrcbrains.regfolder')
  if(!is.null(regroot) && file.exists(regroot)) {
    # anything inside?
    havereg = length(dir(regroot))>0
  }

  if (interactive() && !havereg) {
    packageStartupMessage(
      "You do not have any Saalfeld lab registrations installed!\n",
      "We recommend getting them with:\n\n",
      "  download_saalfeldlab_registrations()\n\n",
      "If you think you already downloaded them, check the value of options('nat.jrcbrains.regfolder')\n",
      "which is currently set to: ", getOption('nat.jrcbrains.regfolder')
    )
  }
  invisible()
}
