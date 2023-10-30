# This code was written by Isaac Brito-Morales (ibrito@conservation.org)
# Please do not distribute this code without permission.
# NO GUARANTEES THAT CODE IS CORRECT
# Caveat Emptor!

# ncell_rs
# 0.10 == ncol3600, nrow1800
# 0.01 == ncol36000, nrow18000
# 0.025 == ncol14400,nrow7200

equal_area_grid <- function(n_col, n_row, area_km2, outdir) {
 
  library(terra)
  library(sf)
  library(rnaturalearth)
  library(ggplot2)  
  
# projections for general use
  LatLon <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  moll <- "+proj=moll +lon_0=0 +datum=WGS84 +units=m +no_defs"
  robin <- "+proj=robin +lon_0=0 +datum=WGS84 +units=m +no_defs"
  
# Create empty raster
  world_borders_sf <- ne_countries(scale = "medium", returnclass = "sf")
  world_borders_rs <- as(world_borders_sf, "SpatVector")
  rs <- terra::rast(ncol = n_col, nrow = n_row, extent = ext(c(-180, 180, -90, 90)))
  rs[] <- 1:(n_col*n_row)
# Invert the raster to get ocean and then project it
  b <- terra::rasterize(world_borders_rs, rs)
  b[] <- ifelse(is.na(b[]), 2, NA)
  b2 <- terra::project(b, y = robin)
  # From raster to SF spatial object
    c <- terra::as.polygons(b2)
    c <- st_as_sf(c)
  
# Area of each polygon from the grid
  CellArea <- area_km2 # in km2
  h_diameter <- 2 * sqrt((CellArea*1e6)/((3*sqrt(3)/2))) * sqrt(3)/2 # Diameter in m
  s_diameter <- sqrt(CellArea*1e6) # Diameter in m
# Creating an equal-area grid
  PUs <- st_make_grid(c,
                      square = F,
                      cellsize = c(h_diameter, h_diameter),
                      what = "polygons",
                      crs = st_crs(c)) %>%
    st_sf()
# Get rid of "land" polygons
  logi_PUs <- st_centroid(PUs) %>%
    st_intersects(c) %>% 
    lengths > 0 # Get logical vector instead of sparse geometry binary
  PUs1 <- PUs[logi_PUs == TRUE, ]
# Write the final object
  nms <- paste0("equal_grid_", area_km2, "km2")
  st_write(obj = PUs1, dsn = outdir, layer = nms, driver = "ESRI Shapefile")
  
# Create and export a test plot
  sphere <- ne_download(category = "physical", type = "wgs84_bounding_box", returnclass = "sf")
  sphere_robin <- st_transform(sphere, crs = robin)
  
  g1 <- ggplot() +
    geom_sf(data = sphere_robin, size = 0.05) +
    geom_sf(data = PUs1, size = 0.05) +
    geom_sf(data = world_borders_sf, size = 0.05, fill = "grey20") +
    theme_bw()
  ggsave(paste0(outdir, nms, ".png"), plot = g1, width = 40, height = 30, dpi = 600, limitsize = FALSE)
 
  return(PUs1) 
}

test01 <- equal_area_grid(n_col = 3600, n_row = 1800, area_km2 = 100000, outdir = "zscripts/")
test01 <- equal_area_grid(n_col = 3600, n_row = 1800, area_km2 = 100000, outdir = "/scratch/sparc/")
