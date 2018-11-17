
# global variables for the package: http://r-pkgs.had.co.nz/r.html

.onLoad <- function(libname, pkgname) {
  op <- options()
  op_sstk <- list(
    sstk.api.root.url = "https://api.shutterstock.com/"
  )
  toset <- !(names(op_sstk) %in% names(op))
  if(any(toset)) options(op_sstk[toset])

  invisible()
}
