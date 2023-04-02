##
##
init_mock <- function(modulesHome = file.path(getwd(), "mock"))
{
  init <- file.path(modulesHome, "init")
  if( !dir.exists(init) ) {
    dir.create(init)
  }
  text <- c("# test file",
            "/usr/local/share/modules")
  writeLines(text = text, con = file.path(init, ".modulespath"), sep = "\n")
}

init_mock()
