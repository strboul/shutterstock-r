
# global variables for the package: http://r-pkgs.had.co.nz/r.html

.onLoad <- function(libname, pkgname) {
  op <- options()
  op.shutterstock <- list(
    api.root.url = "https://api.shutterstock.com/v2/"
  )
  toset <- !(names(op.shutterstock) %in% names(op))
  if(any(toset)) options(op.shutterstock[toset])

  invisible()
}
