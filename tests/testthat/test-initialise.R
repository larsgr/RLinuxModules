context("RLinuxModules initialise")

modulesHome <- file.path(getwd(), "mock")
empty_env <- c(MODULE_VERSION = NA,
               MODULEPATH     = NA,
               LOADEDMODULES  = NA,
               MODULEHOME     = NA,
               'BASH_FUNC_module%%' = NA,
               'BASH_FUNC_module()' = NA)

test_that("initialise environment", {
  withr::with_envvar(empty_env, {
    moduleInit(modulesHome = modulesHome)

    expect_equivalent(Sys.getenv("MODULESHOME", unset = NA), modulesHome)

    expect_equivalent(Sys.getenv("MODULE_VERSION", unset = NA), "3.2.10")
    expect_equivalent(Sys.getenv("MODULE_VERSION_STACK", unset = NA), "3.2.10")

    expect_equivalent(Sys.getenv("MODULEPATH", unset = NA), "/usr/local/share/modules")

    expect_equivalent(Sys.getenv("LOADEDMODULES", unset = NA), "")
    skip_if_not(shell_is_bash(), message = "shell is not bash")
    expect_false(is.na(Sys.getenv(bash_func_name(), unset = NA)))
  })
})

test_that("version not overwritten", {
  version_set <- empty_env
  version_set[["MODULE_VERSION"]] <- 2000
  withr::with_envvar(version_set, {
    moduleInit(modulesHome = modulesHome)
    expect_equivalent(Sys.getenv("MODULE_VERSION", unset = NA), as.character(version_set[["MODULE_VERSION"]]))
    expect_equivalent(Sys.getenv("MODULE_VERSION_STACK", unset = NA), as.character(version_set[["MODULE_VERSION"]]))
  })
})

test_that("loaded modules not overwritten", {
  loaded_set <- empty_env
  loaded_set[["LOADEDMODULES"]] <- "use.own"
  withr::with_envvar(loaded_set, {
    moduleInit(modulesHome = modulesHome)
    expect_equivalent(Sys.getenv("LOADEDMODULES", unset = NA), loaded_set[["LOADEDMODULES"]])
  })
})

test_that("loaded modules not overwritten", {
  modpath_set <- empty_env
  modpath_set[["MODULEPATH"]] <- "/usr/share/Modules/modulefiles:/opt/share/modulefiles"
  withr::with_envvar(modpath_set, {
    moduleInit(modulesHome = modulesHome)
    expect_equivalent(Sys.getenv("MODULEPATH", unset = NA), modpath_set[["MODULEPATH"]])
  })
})

test_that("checking modulecmd works", {
  withr::with_envvar(empty_env,
      {
        expect_error(moduleInit(modulesHome = "/opt/usr/local/unlikely/1.2.3"),
                     paste("/opt/usr/local/unlikely/1.2.3/bin/modulecmd missing!",
                           "  Module environment init failed!", sep = "\n"))
      })
})



