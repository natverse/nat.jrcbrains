# nat.jrcbrains
<!-- badges: start -->
[![natverse](https://img.shields.io/badge/natverse-Part%20of%20the%20natverse-a241b6)](https://natverse.github.io)
[![Docs](https://img.shields.io/badge/docs-100%25-brightgreen.svg)](https://natverse.github.io/nat.jrcbrains/reference/)
[![Travis build status](https://travis-ci.org/natverse/nat.jrcbrains.svg?branch=master)](https://travis-ci.org/natverse/nat.jrcbrains)
<!-- badges: end -->

nat.jrcbrains allows bridging registrations for Drosophila brains from Janelia Research Campus
to be used with the [NeuroAnatomy Toolbox](https://natverse.github.io/nat/) suite
of R packages.



## Installation

You can install the development version of nat.jrcbrains from GitHub
using the remotes package (part of devtools):

``` r
if (!requireNamespace("remotes")) install.packages("remotes")
remotes::install_github('natverse/nat.jrcbrains')
```

## Example

You must first download the registrations you want from

* https://www.janelia.org/open-science/jrc-2018-brain-templates

This is most easily done as follows:

``` r
library(nat.jrcbrains)
download_saalfeldlab_registrations()
```

To run this example you will need *JRC 2018 Female - JFRC 2010*.

``` r
library(nat.jrcbrains)
library(nat.templatebrains)
# sample neurons in JFRC2 space
pd2a = read.neurons("https://ars.els-cdn.com/content/image/1-s2.0-S0896627318307426-mmc5.zip")
pd2a.fafb14=xform_brain(pd2a, sample=JFRC2, reference="FAFB14")
```
## Registration Formats
By default `nat.jrcbrains` will use registrations in the 
[Saalfeld h5 format](https://github.com/saalfeldlab/template-building/wiki/Hdf5-Deformation-fields).
As an end user, support for these registrations should be installed transparently
when you install `nat.jrcbrains`.

### ANTs format registrations
If you intend to use registrations in `ANTs` format, then you will need to install
the suggested [nat.ants](https://github.com/jefferis/nat.ants) package. 
This is turn has additional dependencies that can be hard to install. See the README for
https://github.com/jefferis/nat.ants for details but essentially doing

```
source("https://neuroconductor.org/neurocLite.R")
neuro_install("ANTsRCore")
remotes::install_github("jefferis/nat.ants")
```

should do the trick.

## See also

This is a thin wrapper for bridging registrations developed by John Bogovic
in [Stephan Saalfeld's lab](https://www.janelia.org/lab/saalfeld-lab) at Janelia.
See:

* https://www.biorxiv.org/content/early/2018/07/25/376384

for details and downloads
