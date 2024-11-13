# Usa l'immagine ufficiale di RStudio e R
FROM rocker/rstudio:latest

# Aggiorna i pacchetti di sistema e installa le dipendenze necessarie, inclusi Git, patch, e libglpk-dev
RUN apt-get update && \
    apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libhdf5-dev \
    zlib1g-dev \
    libhdf5-serial-dev \
    hdf5-tools \
    gfortran \
    libpng-dev \
    libjpeg-dev \
    libnetcdf-dev \
    git \
    patch \
    libglpk-dev && \
    rm -rf /var/lib/apt/lists/*

# Installa BiocManager per gestire i pacchetti Bioconductor
RUN R -e "install.packages('BiocManager')"

# Installa devtools per poter installare pacchetti da GitHub
RUN R -e "install.packages('devtools')"

# Installa il pacchetto hdf5r da GitHub
RUN R -e "devtools::install_github('hhoeflin/hdf5r')" && \
    R -e "install.packages(c('tidyverse', 'viridis', 'gghalves', 'cowplot', 'patchwork', 'gridExtra', 'parallel', 'stringi', 'stringr'))"

# Installa pacchetti Bioconductor aggiuntivi, tra cui edgeR, sva, Glimma, RUVSeq, DiffBind, ChIPseeker
RUN R -e "BiocManager::install(c('edgeR', 'sva', 'Glimma', 'RUVSeq', 'DiffBind', 'ChIPseeker', 'Seurat', 'SeuratObject', 'scran', 'scater', 'scDblFinder', 'SoupX', 'BiocGenerics', 'harmony'))"

# Installa pacchetti CRAN aggiuntivi mancanti
RUN R -e "install.packages(c('ggplot2', 'dplyr', 'magrittr', 'ggrepel', 'RColorBrewer', 'gplots', 'DGEobj.utils', 'htmlwidgets', 'DT', 'tinytex', 'plotly', 'ggupset', 'dendextend', 'circlize', 'ComplexHeatmap', 'ggdendro'))"

# Crea un utente per l'accesso a RStudio
RUN useradd -m -s /bin/bash rstudio_user && \
    echo "rstudio_user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Assegna la proprietà della directory all'utente rstudio_user
RUN chown -R rstudio_user:rstudio_user /home/rstudio_user

# Espone la porta 8787 per l'accesso a RStudio Server
EXPOSE 8787

# Esegui RStudio come utente rstudio_user
USER rstudio_user


# Comando di default per avviare RStudio
CMD ["/init"]


