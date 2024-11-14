# Use Ubuntu as base image
FROM ubuntu:22.04

# Avoid timezone prompt during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Rome

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gdebi-core \
    wget \
    r-base \
    r-base-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libcairo2-dev \
    libxt-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Download and install RStudio Server
RUN wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.12.0-369-amd64.deb && \
    gdebi -n rstudio-server-2023.12.0-369-amd64.deb && \
    rm rstudio-server-2023.12.0-369-amd64.deb

# Install BiocManager
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"

# Install required R packages
RUN R -e "BiocManager::install(c( \
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
))"

# Install orca for plotly static image export
RUN wget https://github.com/plotly/orca/releases/download/v1.3.1/orca-1.3.1.AppImage -O /usr/local/bin/orca && \
    chmod +x /usr/local/bin/orca

# Expose RStudio Server port
EXPOSE 8787

# Set default user password for RStudio
ENV PASSWORD=rstudio

# Start RStudio Server
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0", "--auth-none=1"]


# Comando di default per avviare RStudio
CMD ["/init"]


