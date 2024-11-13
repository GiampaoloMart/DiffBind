# Use the rocker/rstudio image as the base, which includes R and RStudio
FROM rocker/rstudio:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install apt-utils to handle missing package configuration
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils

# Install system dependencies in smaller chunks to catch errors
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libcairo2-dev \
    libxt-dev

RUN apt-get install -y --no-install-recommends \
    libgsl0-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    libpq-dev

# Install TeX Live and pandoc for knitting to PDF
RUN apt-get install -y --no-install-recommends \
    pandoc \
    pandoc-citeproc \
    texlive-base \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra

# Clean up apt cache to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Bioconductor manager
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"

# Install CRAN packages
RUN R -e "install.packages(c('ggplot2', 'dplyr', 'magrittr', 'ggrepel', 'RColorBrewer', 'gplots', 'DGEobj.utils', 'htmlwidgets', 'DT', 'tinytex', 'plotly', 'stringr', 'ggupset', 'tidyverse', 'dendextend', 'circlize', 'ComplexHeatmap', 'ggdendro', 'RColorBrewer'), repos='http://cran.rstudio.com/')"

# Install Bioconductor packages
RUN R -e "BiocManager::install(c('edgeR', 'sva', 'Glimma', 'RUVSeq', 'DiffBind', 'ChIPseeker'))"

# Set permissions for RStudio to work within Docker
RUN usermod -aG staff rstudio

# Expose port for RStudio
EXPOSE 8787

# Add .Rprofile to load libraries automatically
RUN echo "library(edgeR); library(ggplot2); library(dplyr); library(magrittr); library(ggrepel); library(RColorBrewer); library(gplots); library(sva); library(DGEobj.utils); library(htmlwidgets); library(DT); library(tinytex); library(plotly); library(stringr); library(ggupset); library(tidyverse); library(dendextend); library(circlize); library(ComplexHeatmap); library(ggdendro); library(Glimma); library(RUVSeq); library(DiffBind); library(ChIPseeker);" > /home/rstudio/.Rprofile

# Set the default command to start RStudio
CMD ["/init"]

