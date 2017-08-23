library(mdsr)
library(sp)
plot(CholeraDeaths)
library(rgdal)
dsn <- "./data/SnowGIS_SHP/"
list.files(dsn)
ogrListLayers(dsn)
ogrInfo(dsn, layer = "Cholera_Deaths")
CholeraDeaths <- readOGR(dsn, layer = "Cholera_Deaths")
summary(CholeraDeaths)
str(CholeraDeaths@data)
coordinates(CholeraDeaths)
cholera_coords <- as.data.frame(coordinates(CholeraDeaths))
m0 <- ggplot(cholera_coords) +
  geom_point(aes(x = coords.x1, y = coords.x2)) 
(m1 <- m0 +  
    coord_quickmap())
(m2 <- m0 + coord_map()) # Not working
library(ggmap)
m <- get_map("John Snow, London, England", 
             zoom = 17, 
             maptype = "roadmap")
ggmap(m) +
  geom_point(data = as.data.frame(CholeraDeaths),
             aes(x = coords.x1,
                 y = coords.x2,
                 size = Count))
