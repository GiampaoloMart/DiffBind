# Use the official Rocker RStudio image as base
FROM rocker/rstudio:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libfontconfig1-dev \
    && rm -rf /var/lib/apt/lists/*

# Install BiocManager
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"

# Install required R packages
RUN R -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); \
    BiocManager::install(update = FALSE, ask = FALSE); \
    packages <- c( \
    'edgeR', \
    'ggplot2', \
    'dplyr', \
    'magrittr', \
    'ggrepel', \
    'RColorBrewer', \
    'gplots', \
    'sva', \
    'DGEobj.utils', \
    'htmlwidgets', \
    'DT', \
    'tinytex', \
    'plotly', \
    'stringr', \
    'ggupset', \
    'tidyverse', \
    'dendextend', \
    'circlize', \
    'ComplexHeatmap', \
    'ggdendro', \
    'Glimma', \
    'RUVSeq', \
    'DiffBind', \
    'ChIPseeker' \
    ); \
    for (pkg in packages) { \
        tryCatch( \
            { \
                if (!require(pkg, character.only = TRUE)) { \
                    BiocManager::install(pkg, update = FALSE, ask = FALSE) \
                } \
            }, \
            error = function(e) { \
                message(sprintf('Error installing %s: %s', pkg, e$message)) \
            } \
        ) \
    }"

# The rocker/rstudio image already exposes port 8787 and sets up the necessary users


# Comando di default per avviare RStudio
CMD ["/init"]


