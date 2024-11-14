# Use the official Rocker RStudio image as base with specific R version
FROM rocker/rstudio:4.3.2

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
    BiocManager::install(update = FALSE, ask = FALSE); \
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

