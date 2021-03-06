# Team DDJ
# Geo-Scripting Project Week 

# Global Forest Cover Analysis with Hansen data

# Modification date: 29-01-2015
# E-mail: daniel.scheerooren@wur.nl

#-------------------------------------- Function -----------------------------------

Hansen <- function(Threshold){
  ## Create variable Area Of Interest (aio)
  aoi <- readRDS(file = 'data/BufferWGS.rds', refhook = NULL)
    
  ## Calculate tiles needed to cover the AOI
  tiles <- calc_gfc_tiles(aoi)
  print(length(tiles))
    
  ## Crop the shapefile 
  crop_buffer <- crop(tiles, aoi)
   
  ## Download GFC data
  download_tiles(tiles, 'data', first_and_last=FALSE)
    
  ## Extract data from tiles
  gfc_extract <- extract_gfc(aoi, "data", filename="data/extract_hansen/GFC_extract.tif", overwrite=TRUE )
  
  ## Apply threshold to extracted data 
  gfc_thresholded <- threshold_gfc(gfc_extract, Threshold=Threshold, 
                                   filename="data/extract_hansen/GFC_extract_thresholded.tif", overwrite=TRUE)
  
  ## Set mask over tresholded gfc, size of buffer
  mask_gfc <- mask(gfc_thresholded$forest2000, aoi)
  
  return (mask_gfc)
}
