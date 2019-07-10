context("Saalfeld_reg")
require(testthat)

test_that("Check if h5 registration files can be downloaded", {
  skip_on_cran()
  skip_on_travis()
  skip_if_offline()
  skip("Skip it")

  path = getOption('nat.jrcbrains.regfolder')
  #Check if the .h5 files can be downloaded
  download_saalfeldlab_registrations()
  dir_list <- list.dirs(path = path, full.names = FALSE)
  dir_list <- dir_list[nchar(dir_list) != 0]
  for (download_fileidx in 1:length(dir_list)){
    file_name <- list.files(path = file.path(path,dir_list[download_fileidx]))
    expect_equal(file_name,paste0(dir_list[download_fileidx],'.h5'))
  }
})

test_that("Check if h5 registrations can be used", {
  skip_on_cran()
  skip_on_travis()
  skip_if_offline()
  status <- register_saalfeldlab_registrations()
  expect_equal(length(names(status)), length(status == TRUE)) #Check if all transforms were registered

})


prepare_local_registration <- function (){
  local_h5path <- file.path(test_path(),'testdata')
  delete_saalfeldlab_registrations() #delete all the stored .h5 registrations..
  ff = dir(local_h5path, full.names = FALSE)
  exts= tools::file_ext(ff)
  if(any('h5' %in% exts)){
    h5file=ff[exts=='h5']
  }
  matchnames <- stringr::str_match(h5file, paste0("^([^_]+)_([^_]+)",".[0-9]+.h5$"))
  folder_name <- paste0(matchnames[2],'_',matchnames[3])
  folder_path <- file.path(getOption('nat.jrcbrains.regfolder'),folder_name)
  dir.create(folder_path, recursive = FALSE, showWarnings = FALSE)
  result <- file.copy(file.path(local_h5path,h5file),
                      file.path(getOption('nat.jrcbrains.regfolder'),folder_name))
  file.rename(file.path(getOption('nat.jrcbrains.regfolder'),folder_name,h5file),
              file.path(getOption('nat.jrcbrains.regfolder'),folder_name,paste0(folder_name,'.h5')))

}


test_that("Check if the registrations can be used", {
  expect_true(prepare_local_registration())
  status <- register_saalfeldlab_registrations()
  expect_equal(length(names(status)), length(status == TRUE)) #Check if all transforms were registered

  test.pts.fafb <- structure(list(X = c(449042.929125525, 537772.254619149, 609580.446734164,
                                   618141.093485245, 218257.969108248, 359227.003494128),
                             Y = c(385648.121145289,278985.817956557, 355716.61061002,
                                   80382.615578151, 212908.594727386,268977.654558688),
                             Z = c(230660.98195593, 100485.942557651, 4226.57579592504,
                                   95457.4146278942, 73699.6885084663, 147057.15901702),
                             inside = c(FALSE,FALSE, FALSE, FALSE, FALSE, FALSE)), class = "data.frame",
                        row.names = c(NA,-6L))
  #JRC2018F_FAFB
  expect_warning(test.pts.jrc2018f<-nat.templatebrains::xform_brain(test.pts.fafb,
                                              sample=elmr::FAFB,
                                              reference=nat.flybrains::JRC2018F),
                 'using default registration level: 2')
  expect_warning(test.pts.fafb.t <- nat.templatebrains::xform_brain(test.pts.jrc2018f,
                                              sample=nat.flybrains::JRC2018F,
                                              reference=elmr::FAFB,swap=TRUE),
                 'using default registration level: 2')

  test.pts.fafb$inside <- NULL
  test.pts.fafb.t$inside <- NULL
  expect_equal(as.matrix(test.pts.fafb),as.matrix(test.pts.fafb.t),tolerance = 0.0001)

})
