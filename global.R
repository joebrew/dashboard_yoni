library(raster)

isr <- getData(name = 'GADM', country = 'ISR', level = 1)
isr0 <- getData(name = 'GADM', country = 'ISR', level = 0)

# generate a dataframe of places in israel
places <- coordinates(isr)
places <- as.data.frame(places)
names(places) <- c('lng', 'lat')
places$name <- sample(letters, nrow(places))
