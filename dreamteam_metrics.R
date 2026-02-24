library(lidRmetrics)
library(lidR)

#load tile, thin it for speed while we practice

las = readLAS('H:/Git/codeblitz3/codeblitz3/NEON_lidar_tile.laz', filter='-keep_random_fraction 0.3') 

# remove any points pre-classified by vendor as noise 18, 7

las = filter_poi(las, !Classification %in% c(18,7)) 

# Normalize heights, (zero out terrain)

las = normalize_height(las, algorithm=tin())

plot(las)

# Features we chose to do:

#glcm
# voxel metrics - specifically canopy roughness
# interval metrics

# generate voxel metrics

rumple_rast <- 
  pixel_metrics(
    las,
    ~ metrics_rumple(
      X, 
      Y, 
      Z, 
      pixel_size = 1), 
    res = 10
  )
)



# interval metrics

interval_rast <-
  pixel_metrics(
    las,
    ~ metrics_interval(
      Z,
      15
    ),
    res = 10
  )


# GLCM

glcm_rast <- 
  pixel_metrics(las, ~ metrics_texture(X, Y, Z, pixel_size = 1), res = 10)


# stack those rasters:

stacked_rast <-
  c(rumple_rast, interval_rast)
