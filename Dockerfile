# syntax=docker/dockerfile:1.3-labs
FROM docker.io/rocker/shiny:4.2.1

RUN apt update && apt install -y --no-install-recommends \
  libgeos-c1v5 \
  libglpk40 \
  libhdf5-dev \
  libxml2 \
  && rm -rf /var/lib/apt/lists/*

RUN install2.r --skipinstalled \
  data.table \
  DT \
  ggdendro \
  ggplot2 \
  glue \
  gridExtra \
  hdf5r \
  igraph \
  magrittr \
  Matrix \
  RColorBrewer \
  readr \
  reticulate \
  R.utils \
  Seurat \
  shiny \
  shinyhelper

COPY . /tmp/ShinyCell
RUN R CMD INSTALL /tmp/ShinyCell

WORKDIR /srv/shiny-server
RUN rm -rf *
RUN R <<EOF
  library(Seurat)
  library(ShinyCell)
  
  getExampleData()
  seu = readRDS("readySeu_rset.rds")
  scConf = createConfig(seu)
  makeShinyApp(seu, scConf, gene.mapping = TRUE,
               shiny.dir = "shinycell",
               shiny.title = "ShinyCell Quick Start") 
EOF

