#' Initialize Environment Modules interface
#'
#' Initialize linux Environment Modules. Must be called before using \code{\link{module}}
#'
#' @param version The version of the module system that is installed
#' @param modulesHome Path to where the module system is installed
#'
#'
#' @export
moduleInit <- function( version = '3.2.10',
                        modulesHome = '/local/genome/Modules/3.2.10'){

  # Check if modulecmd exists in the
  if(!file.exists( file.path(modulesHome,"bin/modulecmd") )){
    stop(file.path(modulesHome,"bin/modulecmd")," missing!\n",
         "  Module environment init failed!" )
  }


  if( is.na(Sys.getenv('MODULE_VERSION', unset = NA)) ){
    Sys.setenv(MODULE_VERSION_STACK = version,
               MODULE_VERSION = version)
  } else {
    Sys.setenv(MODULE_VERSION_STACK = Sys.getenv('MODULE_VERSION'))
  }

  Sys.setenv(MODULESHOME=modulesHome)

  if( is.na(Sys.getenv('MODULEPATH', unset = NA)) ){
    txt <- readLines(file.path(Sys.getenv('MODULESHOME'),"init/.modulespath"))

    # remove commented lines and trim leading and trailing whitespace
    txt <- gsub("^\\s+|\\s+$", "", sub("#.*$","",txt))
    # paste together
    path <- paste(txt[txt != ""],collapse=":")
    Sys.setenv( MODULEPATH = path )
  }

  if( is.na(Sys.getenv('LOADEDMODULES', unset = NA)) ){
    Sys.setenv( LOADEDMODULES = "" )
  }

}
