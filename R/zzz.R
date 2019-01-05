
cacheEnv <- new.env()

.onLoad <- function(libname, pkgname) { #nocov start #nolint start
  op <- options()
  op_sstk <- list(
    sstk.api.root.url = "https://api.shutterstock.com/",
    sstk.api.version = "v2/"
  )
  toset <- !(names(op_sstk) %in% names(op))
  if(any(toset)) options(op_sstk[toset])

  invisible()
} #nocov end #nolint end
