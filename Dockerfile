# Use the official Rocker RStudio image as base
FROM rocker/rstudio:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libfontconfig1-dev \
    && rm -rf /var/lib/apt/lists/*

# Install CRAN packages
RUN R -e "options(repos = c(CRAN = 'https://cloud.r-project.org')); \
    install.packages(c( \
        'ggplot2', \
        'dplyr', \
        'magrittr', \
        'ggrepel', \
        'RColorBrewer', \
        'gplots', \
        'htmlwidgets', \
        'DT', \
        'tinytex', \
        'plotly', \
        'stringr', \
        'ggupset', \
        'tidyverse', \
        'dendextend', \
        'circlize', \
        'ggdendro' \
    ), dependencies=TRUE)"

# Install BiocManager and Bioconductor packages
RUN R -e "\
    if (!require('BiocManager', quietly = TRUE)) \
        install.packages('BiocManager'); \
    BiocManager::install(version = '3.18', ask = FALSE); \
    BiocManager::install(c( \
        'edgeR', \
        'sva', \
        'DGEobj.utils', \
        'ComplexHeatmap', \
        'Glimma', \
        'RUVSeq', \
        'DiffBind', \
        'ChIPseeker' \
    ), update = FALSE, ask = FALSE)"


# Comando di default per avviare RStudio
CMD ["/init"]


