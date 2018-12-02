
PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename "$(PWD)")

#### TESTING PACKAGE
spelling: lintr
  R -q -e "spelling::spell_check_package()"

lintr: covr
	R -q -e "lintr::lint_package()"

covr: test
	R -q -e "covr::package_coverage()"

test:
	R -q -e "devtools::test()"

#### R CMD check:
check:
	R -q -e "devtools::check()"

#### BUILD PACKAGE
.SILENT: clean

clean: install
	$(RM) -r *.Rcheck/ ;\
	$(RM) -r $(PKGNAME)_$(PKGVERS).tar.gz

install: docs
	R -q -e "devtools::install()"

docs: build
	R -q -e "devtools::document(roclets=c('rd', 'collate', 'namespace'))"

build:
	R -q -e "devtools::build()"
