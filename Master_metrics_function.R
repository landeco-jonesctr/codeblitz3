library(lidRmetrics)
library(lidR)
library(ForestTools)
library(geometry)

#master function combining all metrics
master_metrics <- function (x, y, z, i, ReturnNumber, NumberOfReturns, zmin = NA, 
                            threshold = c(2, 5), dz = 1, interval_count = 10, zintervals = c(0, 
                                                                                             0.15, 2, 5, 10, 20, 30), pixel_size = 1, vox_size = 1, 
                            KeepReturns = c(1, 2, 3, 4), chm_algorithm = NULL) 
{
  m_set1 <- metrics_set1(z = z, zmin = zmin, threshold = threshold, 
                         dz = dz, interval_count = interval_count, zintervals = zintervals)
  m_echo <- metrics_echo(ReturnNumber = ReturnNumber, NumberOfReturns = NumberOfReturns, 
                         z = z, zmin = zmin)
  m_echo2 <- metrics_echo2(ReturnNumber = ReturnNumber, KeepReturns = KeepReturns, 
                           z = z, zmin = zmin)
  m_rumple <- metrics_rumple(x = x, y = y, z = z, pixel_size = pixel_size)
  m_vox <- metrics_voxels(x = x, y = y, z = z, vox_size = vox_size, 
                          zmin = zmin)
  m_kde <- metrics_kde(z = z, zmin = zmin)
  m_HOME <- metrics_HOME(z = z, i = i, zmin = zmin)
  mt <- metrics_texture(x=x, y=y, z=z, pixel_size=pixel_size, zmin = zmin, chm_algorithm = chm_algorithm)
  m <- c(m_set1, m_echo, m_echo2, m_rumple, m_vox, m_kde, m_HOME, mt)
  return(m)
}

#Testing master_metrics function on a las file
las = readLAS("NEON_lidar_tile.laz")

# remove any points pre-classified by vendor as noise 18, 7

las = filter_poi(las, !Classification %in% c(18,7)) 

# Normalize heights, (zero out terrain)
getwd()
las = normalize_height(las, algorithm=tin())

#Run master_metrics on the cleaned las file
Master_raster <- pixel_metrics(las, ~master_metrics(X, Y, Z, Intensity, ReturnNumber, NumberOfReturns), res = 20)
plot(Master_raster)
