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

# Set Bioconductor to version 3.20 (compatible with R 4.4)
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

# Step 2: Install packages that depend on core libraries
RUN R -e "\
    BiocManager::install(c( \
        'GenomicAlignments', \
        'BSgenome', \
        'rtracklayer', \
        'GO.db', \
        'GenomicFeatures', \
        'DESeq2', \
        'genefilter', \
        'edgeR' \
    ), ask = FALSE)"

# Step 3: Install higher-level packages that rely on previous installations
RUN R -e "\
    BiocManager::install(c( \
        'biomaRt', \
        'annotate', \
        'GOSemSim', \
        'DOSE', \
        'Glimma', \
        'sva', \
        'ComplexHeatmap', \
        'RUVSeq', \
        'DiffBind', \
        'systemPipeR', \
        'TxDb.Hsapiens.UCSC.hg19.knownGene' \
    ), ask = FALSE)"

# Step 4: Install additional packages with complex dependencies
RUN R -e "\
    BiocManager::install(c( \
        'ChIPseeker', \
        'GreyListChIP', \
        'ShortRead', \
        'EDASeq', \
        'apeglm', \
        'enrichplot', \
        'DGEobj.utils' \
    ), ask = FALSE)"



