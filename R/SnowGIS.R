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
  geom_point(aes(x = coords.x1, 
                 y = coords.x2)) 
(m1 <- m0 +  
    coord_quickmap())
(m2 <- m0 + coord_map()) # Not working
library(ggmap)
m <- get_map("John Snow, London, England", 
             zoom = 17, 
             maptype = "roadmap")
ggmap(m)
ggmap(m) +
  geom_point(data = as.data.frame(CholeraDeaths), # All the points are out og bounds
             aes(x = coords.x1,
                 y = coords.x2,
                 size = Count))
head(as.data.frame(CholeraDeaths))
str(m)
attr(m, "bb") # coordinates are at different units
library(maps)
map("world", projection = "mercator", wrap = TRUE)
map("world", projection = "cylequalarea", param = 45, wrap = TRUE)
map("state", projection = "lambert",
    parameters = c(lat0 = 20, lat1 = 50), wrap = TRUE)
map("state", projection = "albers",
    parameters = c(lat0 = 20, lat1 = 50), wrap = TRUE)
proj4string(CholeraDeaths) %>% strwrap()
CRS("+init=epsg:4326")
CRS("+init=epsg:3857")
CRS("+init=epsg:27700")
cholera_latlong <- CholeraDeaths %>% spTransform(CRS("+init=epsg:4326"))
bbox(cholera_latlong)
ggmap(m) +
  geom_point(data = as.data.frame(cholera_latlong),
             aes(x = coords.x1, 
                 y = coords.x2,
                 size = Count))
help("spTransform-methods", package = "rgdal")
CholeraDeaths %>% proj4string() %>% showEPSG()
proj4string(CholeraDeaths) <- CRS("+init=epsg:27700")
cholera_latlong <- CholeraDeaths %>%
  spTransform(CRS("+init=epsg:4326"))
snow <- ggmap(m) +
  geom_point(data = as.data.frame(cholera_latlong),
             aes(x = coords.x1,
                 y = coords.x2,
                 size = Count))
snow
pumps <- readOGR(dsn, layer = "Pumps")
proj4string(pumps) <- CRS("+init=epsg:27700")
pumps_latlong <- pumps %>% spTransform(CRS("+init=epsg:4326"))
snow + 
  geom_point(data = as.data.frame(pumps_latlong),
             aes(x = coords.x1,
                 y = coords.x2,
                 size = 3, 
                 colour = "red"))
