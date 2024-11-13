# Usa l'immagine di base RStudio con R preinstallato
FROM rocker/rstudio:latest

# Setta le variabili di ambiente per evitare richieste interattive
ENV DEBIAN_FRONTEND=noninteractive

# Aggiorna apt e installa alcune librerie di sistema necessarie
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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installa il pacchetto BiocManager da CRAN
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"

# Installa pacchetti CRAN richiesti
RUN R -e "install.packages(c('ggplot2', 'dplyr', 'magrittr', 'ggrepel', 'RColorBrewer', 'gplots', 'DGEobj.utils', 'htmlwidgets', 'DT', 'tinytex', 'plotly', 'stringr', 'ggupset', 'tidyverse', 'dendextend', 'circlize', 'ComplexHeatmap', 'ggdendro'), repos='http://cran.rstudio.com/')"

# Installa pacchetti Bioconductor richiesti
RUN R -e "BiocManager::install(c('edgeR', 'sva', 'Glimma', 'RUVSeq', 'DiffBind', 'ChIPseeker'))"

# Imposta permessi per RStudio
RUN usermod -aG staff rstudio

# Espone la porta 8787 per RStudio
EXPOSE 8787

# Comando di default per avviare RStudio
CMD ["/init"]


