#' Mirror an object in FAFB space using FAFB-JRC2018F registration
#'
#' @param x An object containing 3D vertices (e.g. a neuron, surface, points)
#' @param sample The starting brain space in which \code{x} lives -
#'   \code{FAFB14} by default if it is not otherwise other specified.
#' @param via (optional, for expert use only) Intermediate template brain that
#'   the registration sequence must pass through. See details and \code{\link{xform_brain}}
#'   for more information.
#' @param ... Additional arguments passed to \code{\link{xform_brain}} and
#'   \code{\link{mirror_brain}}
#' @inheritParams nat.templatebrains::xform_brain
#' @inheritParams nat::nlapply
#'
#' @return A mirrored version of the neuron/surface or other 3D object.
#'
#' @details This function works by mapping the input data to \bold{JRC2018F}, a
#'   high quality symmetric female brain template. The data are then flipped
#'   (since \bold{JRC2018F} is symmetric no other action is required) and then
#'   returned to the starting space. In order to ensure that the Bogovic et al
#'   bridging registrations are preferred the via argument will be filled with
#'   the value "FAFB14um" i.e. \bold{FAFB14} calibrated in microns. This works
#'   because the Bogovic registrations were based on a mock synaptic staining
#'   using synapse locations that had been rescaled to microns before calculating
#'   a registration with ANTs to \bold{JRC2018F}.
#'
#' @importFrom nat.templatebrains xform_brain mirror_brain regtemplate
#' @export
#'
#' @examples
#' \donttest{
#' # transform arbitrary location (in nm)
#' mirror_fafb(cbind(388112, 162988, 132840))
#' # same but in units of microns
#' mirror_fafb(cbind(388.112, 162.988, 132.84), sample='FAFB14um')
#
#' # no messages
#' mirror_fafb(cbind(388112, 162988, 132840), Verbose=FALSE)
#'
#' # transform arbitrary location (from and to raw pixel coordinates)
#' voxel.size=c(4,4,40)
#' mirror_fafb(cbind(97028, 40747, 3321)* voxel.size)/c(voxel.size)
#'
#' library(nat.flybrains)
#' if(require('elmr', quietly = TRUE)) {
#' FAFB.surf.m <- mirror_fafb(FAFB14.surf)
#' wire3d(as.mesh3d(FAFB.surf), col='blue')
#' wire3d(as.mesh3d(FAFB.surf.m), col='red')
#' }
#' }
mirror_fafb <- function(x, sample=NULL, subset=NULL, via=NULL, ...) {
  if(is.null(sample))
    sample <- regtemplate(x)
  if(is.null(sample))
    sample='FAFB14'
  if(is.null(via))
    via <- if(isTRUE(as.character(sample)=='FAFB14um')) NULL else 'FAFB14um'

  x.jrc2018 <- xform_brain(x, sample=sample, reference = nat.flybrains::JRC2018F,
                           subset=subset, via=via, ...)
  x.jrc2018.m <- mirror_brain(x.jrc2018, brain=nat.flybrains::JRC2018F,
                              transform = 'flip', subset=subset, ...)
  xt <- xform_brain(x.jrc2018.m, reference = sample, sample=nat.flybrains::JRC2018F,
                    subset=subset, via=via, ...)
  xt
}
