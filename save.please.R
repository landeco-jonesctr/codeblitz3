setwd("C:/Users/Nathan/Desktop/landscape.lab/myLiDAR/codeblitz3")
library(lidR)
library(terra)
library(lidRmetrics)

las = readLAS('NEON_lidar_tile.laz', filter = '-keep_random_fraction 0.5')
las = filter_poi(las, !Classification %in% c(7, 18))
las = normalize_height(las, algorithm = tin())

library(Lmoments)

# Set resolution
res_m = 20

# height percentiles
percentile_features = pixel_metrics(las, ~metrics_percentiles(Z), res = res_m)

# L-moments
lmom_features = pixel_metrics(las, ~metrics_Lmoments(Z), res = res_m)

names(lmom_features)


# height percentiles
par(mfrow = c(2, 2), mar = c(2, 2, 3, 1))
plot(percentile_features$zq25, main = "zq25 - Lower canopy")
plot(percentile_features$zq50, main = "zq50 - Median height")
plot(percentile_features$zq75, main = "zq75 - Upper canopy")
plot(percentile_features$zq95, main = "zq95 - Canopy top")

# L-moments
par(mfrow = c(2, 2), mar = c(2, 2, 3, 1))
plot(lmom_features$L1, main = "L1 - L-mean (robust mean)")
plot(lmom_features$L2, main = "L2 - L-scale (robust spread)")
plot(lmom_features$L3, main = "L3 - L-skewness")
plot(lmom_features$L4, main = "L4 - L-kurtosis")


# Combine your team's features into one stack
team_stack = c(
  percentile_features$zq25,
  percentile_features$zq50,
  percentile_features$zq95,
  lmom_features$L1,
  lmom_features$L2
)

# Name the layers
names(team_stack) = c("zq25", "zq50", "zq95", "L1", "L2")

# View the stack
print(team_stack)

# Plot all features
par(mfrow = c(2, 3), mar = c(2, 2, 3, 1))
for(i in 1:nlyr(team_stack)) {
  plot(team_stack[[i]], main = names(team_stack)[i])
}


# Save to the repository folder
writeRaster(team_stack, "lmoments_percentiles_features.tif", overwrite = TRUE)




