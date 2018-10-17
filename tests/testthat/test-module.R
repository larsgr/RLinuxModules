context("RLinuxModules command")

modulesHome <- file.path(getwd(), "mock")
empty_env <- c(MODULE_VERSION = NA,
               MODULEPATH     = NA,
               LOADEDMODULES  = NA,
               MODULEHOME     = NA,
               'BASH_FUNC_module%%' = NA,
               'BASH_FUNC_module()' = NA)

test_that("module commands", {
  withr::with_envvar(empty_env,
    {
      moduleInit(modulesHome = modulesHome)
      expect_error(module(), "argument \"Arguments\" is missing, with no default")

      module("load samtools")
      expect_equivalent(Sys.getenv("PATH"),
                        "/genome/samtools/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin")
      expect_equivalent(Sys.getenv("SAMTOOLS_VERSION"), "1.7")

      module("unload samtools")
      expect_equivalent(Sys.getenv("PATH"),
                        "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin")
      expect_true(is.na(Sys.getenv("SAMTOOLS_VERSION", unset = NA)))
      })
})

test_that("module commands in system", {
  skip_if_not(shell_is_bash(), message = "shell is not bash")
  withr::with_envvar(empty_env,
    {
      moduleInit(modulesHome = modulesHome)
      expect_equal(system("type -t module", intern = TRUE), "function",
                   label = "'module' is a function in shell")

      expect_equivalent(system("module load samtools; echo $PATH", intern = TRUE),
                        "/genome/samtools/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
                        label = "PATH variable")
    })
})
