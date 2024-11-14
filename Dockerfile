# Use the official Rocker RStudio image as base
FROM rocker/rstudio:latest

# Install CRAN packages first
RUN R -e "\
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
    ))"

# Install BiocManager and Bioconductor packages
RUN R -e "\
    if (!require('BiocManager', quietly = TRUE)) \
        install.packages('BiocManager'); \
    BiocManager::install(c( \
        'edgeR', \
        'sva', \
        'DGEobj.utils', \
        'ComplexHeatmap', \
        'Glimma', \
        'RUVSeq', \
        'DiffBind', \
        'ChIPseeker' \
    ), ask = FALSE)"

