#install.packages("tidyverse") #contains dplyr, ggplot2, readr, etc.
library(tidyverse)
#install.packages("devtools")
library(devtools)
devtools::install_github("ptompalski/lidRmetrics")
library(lidRmetrics)

library(lidR)


LASfile <- system.file("extdata", "Megaplot.laz", package="lidR")
las <- readLAS(LASfile, select = "*", filter = "-keep_random_fraction 0.5")

# you can run any metrics_* function with cloud_metrics()
m1 <- cloud_metrics(las, ~metrics_basic(Z))

#install.packages("Lmoments")
library(Lmoments)
#or you can run one of the metric sets in pixel_metrics()
m2 <- pixel_metrics(las, ~metrics_set2(Z, ReturnNumber, NumberOfReturns), res = 20)

#install.packages("geometry")
library(geometry)
# each metrics_* function has a convenient shortcut to run it with default parameters: 
m3 <- pixel_metrics(las, .metrics_set3, res = 20)

#group 2
#load tile, thin it for speed while we practice
las = readLAS('NEON_lidar_tile.laz', filter='-keep_random_fraction 0.5') 

# remove any points pre-classified by vendor as noise 18, 7
las = filter_poi(las, !Classification %in% c(18,7)) 

# Normalize heights, (zero out terrain)
las = normalize_height(las, algorithm=tin())

plot(las)


#4 or 5 rasters, stack in branch
library(lidRmetrics)
?metrics_lad
?zentropy
?metrics_dispersion()
max(las@data$Z)

vertical_structure <- pixel_metrics(las, ~metrics_dispersion(z = Z, dz = 2, zmax = 32.586), res = 10)
vertical_structure
plot(vertical_structure)

VCI <- vertical_structure$VCI
plot(VCI)

?metrics_canopydensity

mcd <- metrics_canopydensity(las@data$Z, interval_count = 10, zmin = NA)
mcd <- pixel_metrics(las, ~metrics_canopydensity(z = Z, interval_count = 10, zmin = NA), res = 10)
midstory_density <- mcd$zpcum5
plot(mcd)

lad <- pixel_metrics(las, ~metrics_lad(z = Z, zmin = NA, dz = 1, k = 0.5, z0 = 2), res = 10)
lad_sum <- lad$lad_sum

lad_sum
midstory_density
VCI
library(terra)
stacked_raster <- c(lad_sum, midstory_density, VCI)
stacked_raster
plot(stacked_raster)
