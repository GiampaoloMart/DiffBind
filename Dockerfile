# Use the rocker/rstudio image as the base, which includes R and RStudio
FROM rocker/rstudio:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libcairo2-dev \
    libxt-dev \
    libgsl0-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    libpq-dev \
    pandoc \
    pandoc-citeproc \
    texlive-base \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Bioconductor packages
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"

# Install CRAN packages
RUN R -e "install.packages(c('ggplot2', 'dplyr', 'magrittr', 'ggrepel', 'RColorBrewer', 'gplots', 'DGEobj.utils', 'htmlwidgets', 'DT', 'tinytex', 'plotly', 'stringr', 'ggupset', 'tidyverse', 'dendextend', 'circlize', 'ComplexHeatmap', 'ggdendro', 'RColorBrewer'), repos='http://cran.rstudio.com/')"

# Install Bioconductor packages
RUN R -e "BiocManager::install(c('edgeR', 'sva', 'Glimma', 'RUVSeq', 'DiffBind', 'ChIPseeker'))"

# Set permissions for RStudio to work within Docker
RUN usermod -aG staff rstudio

# Expose port for RStudio
EXPOSE 8787

# Set the default command to start RStudio
CMD ["/init"]

# Note: The default user is "rstudio" with password "rstudio" in the rocker/rstudio image. 
# Change the password or add user customization as needed.
