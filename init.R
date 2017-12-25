packages = c(
             "shiny",
             "shinydashboard",
             "shinyjs",
             "tidyverse",
             "DT",
             "rio",
             "jsonlite",
             "httr",
             "urltools",
             "solvebio"
             )


install_if_missing = function(p) {
    if (p %in% rownames(installed.packages()) == FALSE) {
        install.packages(p, dependencies = TRUE)
    }
    else {
        cat(paste("Skipping already installed package:", p, "\n"))
    }
}

invisible(sapply(packages, install_if_missing))

# (optional) Install custom version of solvebio-r

# install.packages('githubinstall', repos='http://cran.us.r-project.org')
# library(githubinstall)
# gh_install_packages('solvebio/solvebio-r', ref='master')
