[![Travis build status](https://travis-ci.org/larsgr/RLinuxModules.svg?branch=master)](https://travis-ci.org/larsgr/RLinuxModules)

# RLinuxModules
R package that makes linux [environment modules](http://modules.sourceforge.net/) available from R.

> Note: Lmod environment module system have support for R so this package is not needed.

## installation
```r
devtools::install_github("larsgr/RLinuxModules")
```

## use example:
```r
library(RLinuxModules)

moduleInit( modulesHome = "yourpathToModulesEnvironment")

module("load samtools") # loads samtools into the environment

system("samtools") # samtools should now be available (if you have that module)
```

## How it works
The Modules Environment does not support R scripting but does support Python. This package works by using the python support and translating the python commands returned from *modulecmd python* into R commands. It has only been tested for version 3.2.10 
