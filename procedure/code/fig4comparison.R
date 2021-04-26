or_fig4 = # load original figure 4 data
  read_sf("/Users/vincentfalardeau/Documents/GitHub/RP-Malcomb-V/data/derived/public/georeferenced.gpkg", 
          layer="ta_resilience") %>% 
  # load ta_resilience layer from georeferencing geopackage
  st_drop_geometry() %>%
  # remove the geometry data because two geometries cannot be joined
  select(c(ID_2,resilience)) %>%  
  # select only the ID_2 and resilience columns
  na.omit()
# remove records with null values

rp_fig4 = ta_2010 %>% # prepare our reproduction of figure 4 data
  select(c(ID_2,capacity_2010)) %>%  
  # select only the ID_2 and resilience columns
  # note: geometry columns are 'sticky' -- only way to remove is st_drop_geometry()
  na.omit()  %>%
  # remove records with null values
  mutate(rp_res = case_when(
    capacity_2010 <= ta_brks[2] ~ 1,
    capacity_2010 <= ta_brks[3] ~ 2,
    capacity_2010 <= ta_brks[4] ~ 3,
    capacity_2010 >  ta_brks[4] ~ 4
  ))
# code the capacity scores as integers, as we see them classified on the map. 
#ta_brks was the result of a Jenks classification, as noted on Malcomb et al's maps

fig4compare = inner_join(rp_fig4,or_fig4,by="ID_2") %>%  
  #inner join on field ID_2 keeps only matching records
  filter(rp_res>0 & rp_res<5 & resilience > 0 & resilience < 5)
# keep only records with valid resilience scores

table(fig4compare$resilience,fig4compare$rp_res)
# crosstabulation with frequencies

cor.test(fig4compare$resilience,fig4compare$rp_res,method="spearman")
# Spearman's Rho correlation test

fig4compare = mutate(fig4compare, difference = rp_res - resilience) 
# Calculate difference between the maps so that you can create a difference map

fig4compare$difference <- as.numeric(fig4compare$difference)

map_ta_diff = ggplot() +
  geom_sf(data = ea,
          aes(fill = EA),
          color = NA) +
  geom_sf(
    data = fig4compare,
    aes(fill = factor(difference)),
    color = "white",
    lwd = .2
  ) + 
  scale_fill_manual(
    values = c(
      "Missing Data" = "#FFC389",
      "National Parks and Reserves" = "#D9EABB",
      "Major Lakes of Malawi" = "lightblue",
      #"-3" = "#333333", # there are no -3 values
      "-2" = "#666666",
      "-1" = "#999999",
      "0" = "#CCCCCC",
      "1" = "#999999",
      "2" = "#CCCCCC"#,
      #"3" = "fedeaa"  # and there are no 3 values
    )
  ) +
  scale_x_continuous(breaks = c(33,34,35,36)) +
  labs(title = "New Title") +
  theme_minimal() +
  theme(legend.title = element_blank())

map_ta_diff


diffmap = ggplot() +
  geom_sf(data = ea,
          aes(fill = EA),
          color = NA) +
  geom_sf(
    data = fig4compare,
    aes(fill = factor(difference)),
    color = "white",
    lwd = .2
  ) + 
  #scale_fill_discrete(breaks = c("-2","-1","0","1","2","Missing Data","Major Lakes of Malawi","National Parks and Reserves"), 
  #                    values = c("#e66101","#fdb863","#f7f7f7","#b2abd2","#5e3c99","#cccccc","#00ff00","#0000ff"))+
  scale_fill_manual(name = "Reproduction Compared to Original Study", 
                    limits = c("-2","-1","0","1","2","Missing Data","Major Lakes of Malawi","National Parks and Reserves"), 
                    labels = c(
                      "-2" = "Two Intervals Lower",
                      "-1" = "One Interval Lower",
                      "0" = "Match",
                      "1" = "One Interval Higher",
                      "2" = "Two Intervals Higher",
                      "Missing Data" = "Missing Data",
                      "Major Lakes of Malawi" = "Major Lakes of Malawi",
                      "National Parks and Reserves" = "National Parks and Reserves"
                    ),
                    values = c("-2"="#e66101","-1"="#fdb863","0"="#cccccc","1"="#b2abd2","2"="#5e3c99","Missing Data"="#000000","Major Lakes of Malawi"="lightblue","National Parks and Reserves"="#D9EABB"))+
  scale_x_continuous(breaks = c(33,34,35,36)) +
  labs(title = "New Title") +
  theme_minimal() +
  theme(legend.title = element_blank())
diffmap

map3 =ggplot() +
  geom_sf(data = ea,
          aes(fill = EA),
          color = NA) +
  geom_sf(
    data = fig4compare,
    aes(fill = factor(difference)),
    color = "white",
    lwd = .2
  ) + 
  scale_fill_manual("Legend",
                    limits = c("-2","-1","0","1","2","Missing Data","Major Lakes of Malawi","National Parks and Reserves"), 
                    labels = c(
                      "-2" = "Two Intervals Lower",
                      "-1" = "One Interval Lower",
                      "0" = "Match",
                      "1" = "One Interval Higher",
                      "2" = "Two Intervals Higher",
                      "Missing Data" = "Missing Data",
                      "Major Lakes of Malawi" = "Major Lakes of Malawi",
                      "National Parks and Reserves" = "National Parks and Reserves"
                    ),
                    values = c("-2"="#e66101","-1"="#fdb863","0"="#cccccc","1"="#b2abd2","2"="#5e3c99","Missing Data"="#000000","Major Lakes of Malawi"="lightblue","National Parks and Reserves"="#D9EABB"))+
  scale_x_continuous(breaks = c(33,34,35,36)) +
  labs(title = "Comparing Adaptive Capacity Results", subtitle = "Original Study vs. Reproduction") +
  theme_minimal()
map3
