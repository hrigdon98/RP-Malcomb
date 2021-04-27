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
abline(a=0, b=1)
title("Comparing Vulnerability Scores")

scatter = fig5comppts %>% ggplot(aes(x = or, y = rp, colour = 'green'))+
  labs(x = "Original Study", y = "Reproduction")
plot(scatter)
  
# create scatterplot of original results and reproduction results

cor.test(fig5comppts$or, fig5comppts$rp, method="spearman")
# Spearman's Rho correlation test

# Hint for mapping raster results: refer to the diff raster attribute
# in the fig5comp stars object like this: fig5comp["diff"]

vuln_diff = ggplot() +
  geom_sf(data = ea,
          fill = clrs,
          color = NA) +
  geom_stars(data = fig5comp["diff"]) +
  scale_fill_gradient2(
    midpoint = 0,
    low = "blue",
    mid = "white",
    high = "red",
    space = "Lab",
    breaks = c(-1,  1),
    labels = c("Reproduction Vulnerability Lower", "Reproduction Vulnerability Higher"),
    na.value = "transparent",
    guide = "colourbar",
    limits = c(-1,  1)
  ) +
  scale_x_continuous(breaks = c(33,34,35,36)) +
  labs(title = "Comparing Vulnerability Results", subtitle = "Original Study vs. Reproduction") +
  theme_minimal() +
  theme(
    legend.title = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  )

vuln_diff


