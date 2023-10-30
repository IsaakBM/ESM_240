# This code was written by Isaac Brito-Morales (ibrito@conservation.org)
# Please do not distribute this code without permission.
# NO GUARANTEES THAT CODE IS CORRECT
# Caveat Emptor!

library(terra)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(patchwork)
library(dplyr)
library(rnaturalearth)
library(rnaturalearthdata)
library(gganimate)
library(animation)
library(tidyr)
library(transformr)
library(stringr)
library(readr)
library(data.table)
library(units)
library(ggtext)
library(lwgeom)

########################
####### testing
########################
  # List of pacakges that we will be used
    list.of.packages <- c("terra", "sf", "ggplot2", "RColorBrewer", "patchwork", "dplyr", "rnaturalearth", "rnaturalearthdata", "gganimate", 
                          "animation", "tidyr", "transformr", "stringr", "readr", "data.table", "foreach", "gifski", "ggnewscale", "pals")
  # If is not installed, install the pacakge
    new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
    if(length(new.packages)) install.packages(new.packages)
  # Load packages
    lapply(list.of.packages, require, character.only = TRUE)

  # 
    # mzb_island <- readRDS("InputLayers/boundaries/mzb_island.rds")
########################
####### Projections
########################
  #
    LatLon <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs" # nolint
    moll <- "+proj=moll +lon_0=0 +datum=WGS84 +units=m +no_defs" # nolint
    robin <- "+proj=robin +lon_0=0 +datum=WGS84 +units=m +no_defs" # nolint

########################
####### Region
########################
  # Mozambique
    world_sfRob <- ne_countries(scale = "medium", returnclass = "sf") %>%
      st_transform(crs = robin) %>% 
      st_make_valid()
    world_sfRob <- world_sfRob %>% 
      st_crop(xmin = 2671900, ymin = -3743317, xmax = 5654583, ymax = -748663.4)