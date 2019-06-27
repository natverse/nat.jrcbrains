# nat.jrcbrains

nat.jrcbrains allows bridging registrations for Drosophila brains from Janelia Research Campus
to be used with the [NeuroAnatomy Toolbox](https://jefferis.github.io/nat/) suite
of R packages.



## Prerequisites

### ANTs format
If you intend to use registrations in `ANTs` format, then follow the below instructions.
Before the installation of nat.jrcbrains you need to have `ANTsRCore` and its dependencies installed, otherwise you will get an error message about `ANTsRCore` installation. To install `ANTsRCore` try 
`Method 1: with devtools in R` from the following URL.
```
https://github.com/ANTsX/ANTsR#installation-from-source
```
Furthermore also install [nat.ants](https://github.com/jefferis/nat.ants)

## Installation

You can install the development version of nat.jrcbrains from GitHub:

``` r
devtools::install_github('jefferis/nat.jrcbrains')
```

## Example

You must first download the registrations you want from

* https://www.janelia.org/open-science/jrc-2018-brain-templates

To run this example you will need *JRC 2018 Female - JFRC 2010*.

``` r
library(nat.jrcbrains)

# setup
options(nat.jrcbrains.regfolder='/path/to/jrc-2018-brain-templates')
register_saalfeldlab_registrations()

# use
library(nat.templatebrains)
# sample neurons in JFRC2 space
pd2a = read.neurons("https://ars.els-cdn.com/content/image/1-s2.0-S0896627318307426-mmc5.zip")
pd2a.fafb14=xform_brain(pd2a, sample=JFRC2, reference=FAFB14)
```

## See

This is a thin wrapper for bridging registrations developed by John Bogovic
in [Stephan Saalfeld's lab](https://www.janelia.org/lab/saalfeld-lab) at Janelia.
See:

* https://www.biorxiv.org/content/early/2018/07/25/376384

for details and downloads
