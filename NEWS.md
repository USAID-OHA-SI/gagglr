# gagglr 0.1.0

# gagglr 0.0.0.9000
* Update `oha_check` to run `oha_sitrep` if no package is specified.
* Setup onAttach to load core OHA packages when `gagglr` is loaded.
* Add `oha_update` to provide user with code to update package from GitHub
* Add `oha_sitrep` to provide a list of all OHA packages and indicates whether
 the local package version (sha) matches latest version (sha) on GitHub
* Add `oha_packages` to load all OHA packages (from Remotes in DESCRIPTION)
* Add `oha_check` to allow user/package to check if a local package version 
 matches what is on GitHub
* Build site.
* Add GitHub Action for CI.
* Add logo and lifecycle badge.
* Add `magrittr` to imports.
* Add `README.md` file to provide an overview of the package and act as landing page.
* Added a `NEWS.md` file to track changes to the package.
