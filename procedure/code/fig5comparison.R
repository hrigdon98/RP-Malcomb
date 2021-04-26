orfig5vect = 
  read_sf(here("data", "derived", "public", "georeferencing3.gpkg"), 
          layer="vulnerability_grid")
# load original figure 5 data

orfig5rast = st_rasterize(orfig5vect["b_mean"], template=ta_final)
# convert mean of blue values into a raster using ta_final as a reference for raster
# extent, cell size, CRS, etc.

orfig5rast = orfig5rast %>% 
  mutate(or = 1-
           (b_mean - min(orfig5rast[[1]], na.rm= TRUE)) /
           (max(orfig5rast[[1]], na.rm= TRUE) -
              min(orfig5rast[[1]], na.rm= TRUE)
           )
  )  # or is Re-scaled from 0 to 1 with (value - min)/(max - min)
# it is also inverted, because higher blue values are less red


ta_final = ta_final %>% 
  mutate(rp =
           (capacity_2010 - min(ta_final[[1]], na.rm= TRUE)) /
           (max(ta_final[[1]], na.rm= TRUE) -
              min(ta_final[[1]], na.rm= TRUE)
           )
  )  # rp is Re-scaled from 0 to 1 with (value - min)/(max - min)

fig5comp = c( select(ta_final,"rp"), select(orfig5rast,"or"))
# combine the original (or) fig 5 and reproduced (rp) fig 5

fig5comp = fig5comp %>% mutate( diff = rp - or )
# calculate difference between the original and reproduction,
# for purposes of mapping

fig5comppts = st_as_sf(fig5comp)
# convert raster to vector points to simplify plotting and correlation testing

plot(fig5comppts$or, fig5comppts$rp, xlab="Original Study", ylab="Reproduction")
# create scatterplot of original results and reproduction results

cor.test(fig5comppts$or, fig5comppts$rp, method="spearman")
# Spearman's Rho correlation test

# Hint for mapping raster results: refer to the diff raster attribute
# in the fig5comp stars object like this: fig5comp["diff"]