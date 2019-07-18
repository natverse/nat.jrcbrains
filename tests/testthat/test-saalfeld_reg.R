context("Saalfeld_reg")
require(testthat)
library(nat)


########## Local functions for aiding test cases ####################

#local function for sampling points from a bounding box
sample_points_in_bb <- function(bb, n){
  mm=mapply(runif, min=bb[1,], max=bb[2,], n = n)
  colnames(mm)=c("X","Y","Z")
  mm
}

set.seed(42)
#Sample points to be used in test cases later
# dput(boundingbox(elmr::FAFB.surf))
fafb.bb = makeboundingbox(c(213175.6, 840529, 77531.3, 388177.9, 799.2, 269583.7))
test.pts.fafb <- sample_points_in_bb(fafb.bb,100)



########## h5 registration related test cases ####################
test_that("Check if h5 registration files can be downloaded", {

  skip("Skip it")
  skip_on_cran()
  skip_on_travis()
  skip_if_offline()


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


test_that("Check if high resolution h5 registrations can be used", {
  skip("Skip it")
  skip_on_cran()
  skip_on_travis()
  skip_if_offline()

  status <- register_saalfeldlab_registrations(type='.h5')
  skip_if_not()
  expect_equal(length(names(status)), length(status == TRUE)) #Check if all transforms were registered

})


context("Downsampled h5 tests")
test_that("Check if downsampled h5 registrations can be used", {

  testregfolder='testdata/downsampledreg'
  op <- options(nat.jrcbrains.regfolder=file.path(getwd(),test_path(),testregfolder))
  on.exit(options(op))

  message("Reg folder is: ", getOption('nat.jrcbrains.regfolder'))

  status <- register_saalfeldlab_registrations()
  #Check if all transforms were registered
  expect_true(all(status))

  #JRC2018F_FAFB
  expect_warning(
    test.pts.jrc2018f <- nat.templatebrains::xform_brain(
      test.pts.fafb,
      sample = 'FAFB14',
      reference = nat.flybrains::JRC2018F),
    'using default registration level: 2')
  expect_warning(
    test.pts.fafb.t <- nat.templatebrains::xform_brain(test.pts.jrc2018f,
                                                       sample=nat.flybrains::JRC2018F,
                                                       reference='FAFB14',swap=TRUE),
                 'using default registration level: 2')

  expect_equal(as.matrix(test.pts.fafb),as.matrix(test.pts.fafb.t),tolerance = 0.0001)
})

message("Reg folder is: ", getOption('nat.jrcbrains.regfolder'))

########## nii registration related test cases ####################

#Start afresh
# delete_saalfeldlab_registrations()

test_that("Check if nii registration files can be downloaded", {
  skip('Not now ...')
  skip_on_cran()
  skip_on_travis()
  skip_if_offline()

  path = getOption('nat.jrcbrains.regfolder')
  #Check if the .nii files can be downloaded
  download_saalfeldlab_registrations(fileformat = '.nii')
  dir_list <- list.dirs(path = path, full.names = FALSE)
  dir_list <- dir_list[nchar(dir_list) != 0]
  pattern <- "[_]*[0]*[_]*GenericAffine.mat$"
  for (download_fileidx in 1:length(dir_list)){
    affinefile <- list.files(path = file.path(path,dir_list[download_fileidx]), pattern = pattern)
    expect_false(isTRUE(all.equal(affinefile, character(0))))
  }

})


test_that("Check if the nii registrations can be used", {
  skip('Not now ...')
  status <- register_saalfeldlab_registrations()
  expect_equal(length(names(status)), length(status == TRUE)) #Check if all transforms were registered

  #JRC2018F_FAFB
  test.pts.jrc2018f<-nat.templatebrains::xform_brain(test.pts.fafb,
                                                                    sample=elmr::FAFB,
                                                                    reference=nat.flybrains::JRC2018F)
  test.pts.fafb.t <- nat.templatebrains::xform_brain(test.pts.jrc2018f,
                                                                    sample=nat.flybrains::JRC2018F,
                                                                    reference=elmr::FAFB,swap=TRUE)

  test.pts.fafb.t$inside <- NULL
  expect_equal(as.matrix(test.pts.fafb),as.matrix(test.pts.fafb.t),tolerance = 0.0001)

})
