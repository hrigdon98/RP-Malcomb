---
layout: page
title: RP- Vulnerability modeling for sub-Saharan Africa
---


**Replication of**
# Vulnerability modeling for sub-Saharan Africa

Original study *by* Malcomb, D. W., E. A. Weaver, and A. R. Krakowka. 2014. Vulnerability modeling for sub-Saharan Africa: An operationalized approach in Malawi. *Applied Geography* 48:17–30. DOI:[10.1016/j.apgeog.2014.01.004](https://doi.org/10.1016/j.apgeog.2014.01.004)

Replication Authors:
Emma Brown, Brooke Laird, Sam Marshall, Hannah Rigdon, Vincent Falardeau, Joseph Holler, Kufre Udoh, Open Source GIScience students of Fall 2019 and Spring 2021

Replication Materials Available [here](https://github.com/emmab725/RP-Malcomb).

Created: `14 April 2021`
Revised: `27 April 2021`

## Abstract

The original study is a multi-criteria analysis of vulnerability to Climate Change in Malawi, and is one of the earliest sub-national geographic models of climate change vulnerability for an African country. The study aims to be replicable, and had 40 citations in Google Scholar as of April 8, 2021.

## Original Study Information

The study region is the country of Malawi. The spatial support of input data includes DHS survey points, Traditional Authority boundaries, and raster grids of flood risk (0.833 degree resolution) and drought exposure (0.416 degree resolution).

The original study was published without data or code, but has detailed narrative description of the methodology. The methods used are feasible for undergraduate students to implement following completion of one introductory GIS course. The study states that its data is available for replication in 23 African countries.


### Data Description and Variables

#### [Demographic and Health Surveys](https://dhsprogram.com/Data/)

Demographic and Health Surveys data are used to quantify average household assets and access to resources.

The DHS dataset was collected by the US Agency for International Development (USAID) as part of their Demographics and Health Surveys program, which are designed to be nationally representative population-based surveys. This analysis used the table information from individual household survey responses as well as geographically randomized survey cluster points ([Perez-Heydrich et al. 2013](https://github.com/emmab725/RP-Malcomb/blob/main/data/metadata/Guidelines%20on%20the%20use%20of%20DHS%20GPS%20data.pdf)). The datasets used in this analysis were collected in 2004 and 2010 and are based on over 38,500 survey responses (Malcomb et al. 2014). The household survey questionnaire is standardized across all countries and regions where the survey is performed and is designed to be applicable and comparable across countries. Individual countries may add questions or supplemental questionnaires to tailor the surveys to local needs, but the model surveys remain the same and are designed by USAID ("Data Collection").

The original study constructs 10 indicators from 14 survey variables in order to assess each household’s financial and social assets as well as access to markets, information, and resources (Malcomb et al. 2014). These indicators measure financial assets such as livestock, land ownership, money, and access to technology and information, as well as demographic information such as household gender and age composition, health status, and market access/location. A full list of indicators used is available [here](https://github.com/emmab725/RP-Malcomb/blob/main/data/metadata/dhs-indicators-used.xlsx).

The survey cluster points were aggregated from the village level into 250 traditional authorities to allow for a more detailed and meaningful analysis (Malcomb et al. 2014).


#### [FEWSnet Livelihood Sensitivity](https://fews.net/fews-data/335)

FEWSnet data are used to assess livelihood sensitivity for 19 livelihood zones.

The livelihood zones data incorporated in this analysis comes from interviews with the Malawi Vulnerability Assessment Committee and data produced by MVAC in partnership with the Famine Early Warning System and USAID. The livelihood zones data are designed to establish a general baseline level of household sensitivity, so there is no specific year or range of years over which the survey gathers information about sensitivity. Rather, they ask about a self-reported ‘normal’ year of crop production, market activity, and environmental conditions, which could be different for different regions or households. The surveys were performed on a sample of communities within each livelihood zone. For each zone, two districts and four villages were selected for investigation based on information provided by district-level government officials and NGOs, the goal being to investigate villages that would be representative of the zone as a whole. Within each village, one community level interview and three smaller focus groups were conducted to establish a seasonal production calendar and wealth breakdown, to quantify food and income access, and to compile information about hazards and hazard responses.

The vector dataset of livelihood zones were created in 2003 by updating a previous food economy zone map made by Save the Children in 1996. The updates to the livelihood zones were based on secondary source material, a national workshop with members of the Malawi Vulnerability Assessment Committee, and interviews at the district level with key personnel. When thinking about the different livelihood zones, it is important to remember that they are not constant, but influenced by seasonality and livelihoods are often affected by seasonality and variation.


#### UNEP/GRID [Flood](https://github.com/emmab725/RP-Malcomb/blob/main/data/raw/public/fl1010irmt.tif) and [Drought](https://github.com/emmab725/RP-Malcomb/blob/main/data/raw/public/dr1010ipeykx.tif) Exposure

The UNEP Grid dataset is a set of two publicly available raster layers that was used in this lab to determine population exposure values to drought events and flood hazard. Both data layers were initially developed by UNEP/GRID-Europe for the Global Assessment Report of Risk Reduction. The data layer for physical exposure to drought events was developed based on three other sources: global monthly precipitation data, a GIS model of standardized precipitation, and a grid layer of global population. This layer reflects estimated physical exposure to drought for the temporal window between 1980 and 2001. The flood risk raster layer reflects estimated risk on an index scale between 1 (low) and 5 (extreme).

Within the r script, the raster layers are transformed and resampled to reflect a new, more focused study area. The CRS is reset to 4326 to be consistent with other layers. Later on in the methods the drought risk and the flood risk are resampled using a bilinear method for drought risk and nearest neighbor for flood risk, to then be incorporated into our overall understanding of vulnerability.


#### Traditional Authorities Boundaries

The Traditional Authorities (TA) data is a vector layer from the Database for Global Administrative Areas (GADM). The data is from 2010, and was extracted from the [database](www.gadm.org), version 2.8, November 2015. Its use is restricted to non-commercial purposes. The license states “It is not allowed to redistribute these data, or use them for commercial purposes, without prior consent.” Traditional Authorities are one level below the district level in Malawi, and offer the lowest level of “meaningful administrative power” (Malcomb et al. 2014). Because the TAs are the scale at which the analysis is conducted, the data itself is not transformed, however, the DHS data was aggregated to this scale.
In the R script, it is reprojected in order to match the CRS of other spatial data layers.


#### [Major Lakes](https://github.com/emmab725/RP-Malcomb/blob/main/data/raw/public/major_lakes.csv)

The major lakes dataset is a vector layer downloaded from the Malawi Spatial Data Platform. This dataset uses Open Street Maps data and the Overpass Turbo API to filter out OSM polygons according to the expression “water = lake.” The dataset was last updated in 2017.


### Analytical Specification

The original study was conducted using ArcGIS and STATA, but does not state which versions of these software were used.
The replication study will use R.

## Materials and Procedure

### Original Workflow
#### 1. Data:

- UNEP/GRID (raster)
  - Precipitation
  - Precipitation index
  - Flood and drought risk, physical exposure
- DHS (Demographic Health Survey) (points)
  - Assets and access, adaptive capacity
- Famine Early Warning Network
  - Livelihood sensitivity

#### 2. Planned Steps:

1. **DHS data**: Aggregate data from village level to TA (traditional authority) level
2. **All data**: Rasterize
3. **All data**: Normalize Indicators
   1. Group indicators into quintiles
   2. Assign 0-5 value
4. **All data**: Weight indicators - raster calculator
   1. See table 2 on pg. 23
5. Calculate Resilience - raster calculator
   1. Household Resilience = Adaptive Capacity + Livelihood Sensitivity - Physical Exposure

#### 3. Expected Results:

- Maps of average resilience score for 2004 and for 2010 (socioeconomic resilience of households) at TA level
  - Mapped with 4 classes using natural breaks
  - Using only the DHS data, grouped by TA, normalized into quintiles, weighted, and calculated by formula
- Map of Malawi vulnerability to climate change (based on assets, access, livelihoods and exposure)
  - Raster
  - Derived from the all of the data sources combined



## Replication Results

Our reproduction supports Malcomb et al.’s assessment of adaptive capacity at the Traditional Authority level (fig. xx). A difference map (fig. xx) shows general agreement between our adaptive capacity map (fig. xx) and a digitized version of the adaptive capacity map presented by Malcomb et al. (fig. xx), with most regions in our reproduction matching or being within one class break of the original value. A confusion matrix comparing the two maps (fig. xx) yielded a Spearman’s rho value of 0.77, indicating a relatively strong correlation between the original study and our reproduction.

We failed to reproduce the original study’s assessment of climate vulnerability (fig. xx). There was broad disagreement between our reproduction (fig. xx) and a digitized version of the original study’s map of climate vulnerability (fig. xx), as shown in figure xx.  A confusion matrix comparing the two maps (fig. xx) yielded a Spearman’s rho value of 0.15, indicating a very low degree of correlation between the original study and our reproduction. As shown in a map of the difference between the original study and our reproduction (fig. xx), the reproduction consistently yielded lower vulnerability scores.


![Adaptive Capacity by TA – Reproduction Results](/assets/ac_2010.png)

**Figure 1.** Reproduction results for adaptive capacity by traditional authority (TA), as calculated in R.

&ensp;

![Malawi Vulnerability – Reproduction Results](/assets/vulnerability.png)

**Figure 2.** Reproduction results for vulnerability in Malawi, as calculated in R.

&ensp;

![Adaptive Capacity Difference – Original Study vs. Reproduction](/assets/ac_difference.png)

**Figure 3.** Map of the difference between the adaptive capacity of the reproduction vs. the original study.

 &ensp;

![Vulnerability Difference – Original Study vs. Reproduction](/assets/vuln_difference.png)

**Figure 4.** Map of the difference between the vulnerability calculated in the reproduction vs. the original study.

&ensp;

![Confusion Matrix – Adaptive Capacity Reproduction](/assets/confusion matrix.png)

**Figure 5.** Confusion matrix comparing the Malcomb et al. (2014) results to the reproduction; note that the reproduction often yielded lower adaptive capacity scores than the original study, but the reproduction results for each TA were generally within one interval of the original study's results.

&ensp;

## Unplanned Deviations from the Protocol

Summarize changes and uncertainties between
- your interpretation and plan for the workflow based on reading the paper
- your final workflow after accessing the data and code and completing the code

## Discussion

Provide a summary and interpretation of the key findings of the replication *vis-a-vis* the original study results. If the attempt was a failure, discuss possible causes of the failure. In this replication, any failure is probably due to practical causes, which may include:
- lack of data
- lack of code
- lack of details in the original analysis
- uncertainties due to manner in which data has been used

## Conclusion

Restate the key findings and discuss their broader societal implications or contributions to theory.
Do the research findings suggest a need for any future research?

## References

Include any referenced studies or materials in the [AAG Style of author-date referencing](https://www.tandf.co.uk//journals/authors/style/reference/tf_USChicagoB.pdf).

####  Report Template References & License

This template was developed by Peter Kedron and Joseph Holler with funding support from HEGS-2049837. This template is an adaptation of the ReScience Article Template Developed by N.P Rougier, released under a GPL version 3 license and available here: https://github.com/ReScience/template. Copyright © Nicolas Rougier and coauthors. It also draws inspiration from the pre-registration protocol of the Open Science Framework and the replication studies of Camerer et al. (2016, 2018). See https://osf.io/pfdyw/ and https://osf.io/bzm54/

Camerer, C. F., A. Dreber, E. Forsell, T.-H. Ho, J. Huber, M. Johannesson, M. Kirchler, J. Almenberg, A. Altmejd, T. Chan, E. Heikensten, F. Holzmeister, T. Imai, S. Isaksson, G. Nave, T. Pfeiffer, M. Razen, and H. Wu. 2016. Evaluating replicability of laboratory experiments in economics. Science 351 (6280):1433–1436. https://www.sciencemag.org/lookup/doi/10.1126/science.aaf0918.

Camerer, C. F., A. Dreber, F. Holzmeister, T.-H. Ho, J. Huber, M. Johannesson, M. Kirchler, G. Nave, B. A. Nosek, T. Pfeiffer, A. Altmejd, N. Buttrick, T. Chan, Y. Chen, E. Forsell, A. Gampa, E. Heikensten, L. Hummer, T. Imai, S. Isaksson, D. Manfredi, J. Rose, E.-J. Wagenmakers, and H. Wu. 2018. Evaluating the replicability of social science experiments in Nature and Science between 2010 and 2015. Nature Human Behaviour 2 (9):637–644. http://www.nature.com/articles/s41562-018-0399-z.
