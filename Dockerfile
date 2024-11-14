# Use the official Rocker RStudio image as base
FROM rocker/rstudio:latest

# Install system libraries (if needed for Bioconductor packages)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libpcre2-dev \
    && rm -rf /var/lib/apt/lists/*

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

# Install BiocManager and set Bioconductor to version 3.20 (compatible with R 4.4)
RUN R -e "if (!require('BiocManager', quietly = TRUE)) install.packages('BiocManager'); BiocManager::install(version = '3.20')"

# Step 1: Install foundational Bioconductor dependencies
RUN R -e "\
    BiocManager::install(c( \
        'AnnotationDbi', \
        'BiocGenerics', \
        'IRanges', \
        'S4Vectors', \
        'XVector', \
        'Biostrings', \
        'GenomicRanges', \
        'SummarizedExperiment', \
        'DelayedArray', \
        'Rhtslib', \
        'Rsamtools' \
    ), ask = FALSE)"

# Step 2: Install additional core packages required by complex packages
RUN R -e "\
    BiocManager::install(c( \
        'GenomicAlignments', \
        'GO.db', \
        'GenomicFeatures', \
        'genefilter', \
        'ShortRead', \
        'edgeR' \
    ), ask = FALSE)"

# Step 3: Install packages with dependencies on core libraries
RUN R -e "\
    BiocManager::install(c( \
        'biomaRt', \
        'annotate', \
        'GOSemSim', \
        'DOSE', \
        'ComplexHeatmap', \
        'BSgenome', \
        'rtracklayer' \
    ), ask = FALSE)"

# Step 4: Install remaining packages
RUN R -e "\
    BiocManager::install(c( \
        'systemPipeR', \
        'TxDb.Hsapiens.UCSC.hg19.knownGene', \
        'GreyListChIP', \
        'EDASeq', \
        'apeglm', \
        'DiffBind', \
        'RUVSeq', \
        'enrichplot', \
        'DGEobj.utils', \
        'DESeq2' \
    ), ask = FALSE)"





