# gagglr 0.2
* Update `oha_check` to detect SHA when package is isntalled from rOpenSci [2023-01-04]

# gagglr 0.1
* Update logic flow on `oha_check` for startup [2023-01-04]
* Remove stringr dependency [2023-01-03]
* Resolve bug with attach package check to build on rOpenSci [2023-01-03]
* Allow user the option to automatically install outdated/missing packages with `oha_update()` [2023-11-14]
* Provide code to update package from GH when package is out of date [2023-11-14]
* Convert printed messages from `usethis::ui_` to using `cli::cli_alert` [2023-11-14]
* Include `cascade` as a supported package [2023-11-14]
* Include `themask` as a new supported package [2023-10-02]
* Remove extra line printed with X using `library(gagglr)` when all packages are available [2022-08-05]
* Upgrade version to stable [2022-08-15]

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
