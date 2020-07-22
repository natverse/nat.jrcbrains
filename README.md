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

To run this example you will need *JRC 2018 Female - JFRC 2010*, which is
included as one of the downloaded  bridging registrations since 
[v0.3.1](https://github.com/natverse/nat.jrcbrains/commit/ebe1b464200af0440fb582f9fa26f12063629250)

``` r
library(nat.jrcbrains)
library(nat.templatebrains)
# sample neurons in JFRC2 space
pd2a = read.neurons("https://ars.els-cdn.com/content/image/1-s2.0-S0896627318307426-mmc5.zip")
# note use of via argument to insist on higher quality bridging registration
# to FAFB14
pd2a.fafb14=xform_brain(pd2a, sample=JFRC2, reference="FAFB14", via=c("FAFB14um"))
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

## Acknowledgements

This is a thin wrapper to allow convenient download and application of bridging
registrations developed by John Bogovic in [Stephan Saalfeld's lab](https://www.janelia.org/lab/saalfeld-lab) at Janelia.
See:

* https://www.biorxiv.org/content/10.1101/376384v2

*An unbiased template of the Drosophila brain and ventral nerve cord*. John A Bogovic, Hideo Otsuna, Larissa Heinrich, Masayoshi Ito, Jennifer Jeter, Geoffrey Meissner, Aljoscha Nern, Jennifer Colonell, Oz Malkesman, Kei Ito, Stephan Saalfeld
bioRxiv 376384; doi:[10.1101/376384](https://doi.org/10.1101/376384)

for details and additional downloads. **Please cite their paper if you make use of these registrations**.

In addition if you make use of the infrastructure in this and other natverse packages, we would be grateful if you would cite:

*The natverse, a versatile toolbox for combining and analysing neuroanatomical data.* A. S. Bates and J. D. Manton and S. R. Jagannathan and M. Costa and P. Schlegel and T. Rohlfing and G. S. X. E. Jefferis. eLife 9. doi:[10.7554/eLife.53350](https://doi.org/10.7554/eLife.53350)

You can also get citation information from inside R for the natverse
or individual packages like so:

```r
citation('natverse')
citation('nat.jrcbrains')
```

Your citations will help support future tool development by the Saalfeld lab and ourselves.
