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

# Update Bioconductor to the latest version
RUN R -e "if (!require('BiocManager', quietly = TRUE)) install.packages('BiocManager'); BiocManager::install(version = 'devel')"

# Install essential Bioconductor dependencies first
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
        'Rsamtools', \
        'GenomicAlignments', \
        'BSgenome' \
    ), ask = FALSE)"

# Install remaining Bioconductor packages
RUN R -e "\
    BiocManager::install(c( \
        'GO.db', \
        'KEGGREST', \
        'DESeq2', \
        'edgeR', \
        'sva', \
        'DGEobj.utils', \
        'ComplexHeatmap', \
        'Glimma', \
        'RUVSeq', \
        'DiffBind', \
        'ChIPseeker', \
        'rtracklayer', \
        'GenomicFeatures', \
        'systemPipeR', \
        'TxDb.Hsapiens.UCSC.hg19.knownGene' \
    ), ask = FALSE)"


