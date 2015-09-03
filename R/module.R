#' Linux Environment Modules interface
#'
#' Access the linux Environment Modules which provides for the dynamic modification of a user's
#' environment via modulefiles.
#'
#' Each modulefile contains the information needed to configure the shell for an application.
#' Once the RLinuxModules package is initialized (with \code{\link{moduleInit}}), the environment can
#' be modified on a per-module basis using the module command which interprets modulefiles. Typically
#' modulefiles instruct the module command to alter or set shell environment variables such as PATH,
#' MANPATH, etc. modulefiles may be shared by many users on a system and users may have their own
#' collection to supplement or replace the shared modulefiles.
#'
#' @param Arguments "[ switches ] [ subcommand ] [ subcommand-args ]" See examples
#' @return Output messages will be sent to stderr
#'
#' @examples
#' module("avail") # shows available modules
#'
#' module("--help") # show available sub-commands and switches
#'
#' module("load samtools") # loads the module "samtools"
#' system("which samtools") # check that samtools is loaded in the environment
#'
#' module("list") # list loaded modules
#'
#' module("unload samtools") # unload the samtools module
#'
#' module("load samtools/1.0") # loads a specific version of the module "samtools"
#' system("which samtools") # check that the correct samtools is loaded in the environment
#'
#' @export
module <- function( Arguments ){

  # check if arguments are corrext type
  if( !(class(Arguments) == "character" && length(Arguments)==1)){
    stop("Arguments must be a character vector of length 1")
  }

  # check if module environment has been initialized
  if( is.na(Sys.getenv('MODULESHOME', unset = NA)) ){
    stop("Environment variable MODULESHOME missing!\n",
         "  Run moduleInit() to initialize module envionment" )
  }

  moduleCmd <- file.path(Sys.getenv('MODULESHOME'),"bin/modulecmd")
  # check if modulecmd exists
  if(!file.exists( moduleCmd) ){
    stop(moduleCmd," missing!\n",
         "  Module environment not properly set up!" )
  }

  # use the python interface
  pythonCmds <- system(paste(moduleCmd,"python",Arguments),intern=T)


  # Check if all python commands are recognizable
  validPythonCmd <- grepl("os\\.chdir\\('([^']*)'\\)",pythonCmds) |
                    grepl("os\\.environ\\['([^']*)'] = '([^']*)'",pythonCmds) |
                    grepl("del os\\.environ\\['([^']*)'\\]",pythonCmds)
  if( !all(validPythonCmd) ){
    stop("modulecmd returned unknown command(s):\n", paste(pythonCmds[!validPythonCmd],collapse = "\n"))
  }

  # convert python commands to R commands
  RCmds <- sub("os\\.chdir\\('([^']*)'\\)","setwd(dir = '\\1')",pythonCmds,perl=T)
  RCmds <- sub("os\\.environ\\['([^']*)'] = '([^']*)'","Sys.setenv('\\1' = '\\2')",RCmds,perl=T)
  RCmds <- sub("del os\\.environ\\['([^']*)'\\]","Sys.unsetenv('\\1')",RCmds,perl=T)

  # execute R commands
  invisible( eval( parse(text = RCmds) ) )
}
