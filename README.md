# nat.jrcbrains

nat.jrcbrains allows bridging registrations for Drosophila brains from Janelia Research Campus
to be used with the [NeuroAnatomy Toolbox](https://jefferis.github.io/nat/) suite
of R packages.

## Installation

You can install the development version of nat.jrcbrains from GitHub:

``` r
devtools::install_github('jefferis/nat.jrcbrains')
```
If you get error messages during installtion about `ANTsRCore` then try the following:

```
source("https://neuroconductor.org/neurocLite.R")
neuro_install('ANTsRCore')
```
before installing the *nat.jrcbrains*. See the 
[nat.ants](https://github.com/jefferis/nat.ants) and
[ANTsRCore](https://github.com/ANTsX/ANTsRCore) packages for details.

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
