# The Relationship Between Respiratory Health and Cities

**By:** Sumaiya Tasnim

## Overview
Urban areas are seeing steady increases in asthma, COPD, and other respiratory illnesses, much of which can be traced to the air city residents breathe every day. Outdoor air pollution tends to be more concentrated in urban settings because of dense traffic networks, industrial facilities, older heating systems, and limited green space. Pollutants such as PM₂.₅, PM₁₀, NO₂, SO₂, CO, and ozone are small enough to penetrate the lungs, trigger inflammation, worsen chronic respiratory conditions, and increase susceptibility to infection. This project explores whether common air pollutants, AQI, and weather conditions are statistically associated with respiratory health outcomes using real-world air quality and health impact data.

## Introduction & Problem Statement
A large body of research has documented how sensitive respiratory health is to changes in air pollution:

- **Bell et al. (2007)** found that even modest increases in particulate matter led to noticeable spikes in asthma attacks and emergency department visits.
- **Stieb et al. (2009)** showed that short-term surges in particulate matter were closely tied to hospital admissions for asthma and COPD across multiple cities.
- **O'Connor et al. (2008)** highlighted that children are especially vulnerable, showing higher ER visits even from relatively small pollution increases.
- **Brugha and Grigg (2014)** described how chronic exposure slowly reshapes the airways, weakens lung function, and raises the risk of developing persistent respiratory disease.

Pollution is also unevenly distributed across neighborhoods. **Gryech et al. (2022)** and **Slama et al. (2019)** found that road density, traffic flow, industrial zoning, and access to green space create pockets where air quality is substantially worse than the city average. **Jiang et al. (2024)** add that these pollution–health relationships are not static — they shift as cities change through new transportation policy, climate conditions, or redevelopment. Environmental justice research (PJSS Review, CS Review Journal) further shows that lower-income, immigrant, and historically marginalized communities tend to bear a disproportionate share of pollution-related harm, often living closer to highways, industrial corridors, and crowded housing developments with fewer resources to mitigate exposure.

Given these combined challenges, this project aims to bring together environmental and health data to better understand respiratory risk in cities — modeling pollution exposure, analyzing how pollutant levels relate to respiratory health outcomes, and (eventually) mapping where these risks are most concentrated.

## Methodology

### Planned / broader study design
The full study design calls for combining several complementary data sources: ground-based measurements (EPA AirData, OpenAQ), satellite Aerosol Optical Depth data (NASA MODIS/VIIRS) to fill spatial gaps, weather data (NOAA), and land-use/road network data (OpenStreetMap) to train a machine learning model (Random Forest or XGBoost) predicting PM₂.₅ at a fine spatial scale, following approaches used in Slama et al. (2019) and Gryech et al. (2022). On the health side, the plan is to analyze daily respiratory ER visits/hospital admissions via Quasi-Poisson regression and Distributed Lag Nonlinear Models (DLNMs) to capture both immediate and delayed effects of exposure (as in Stieb et al., 2009; O'Connor et al., 2008), adjusting for temperature, humidity, day of week, and seasonal trends. A spatial analysis stage would map exposure and health outcomes against census/ACS socioeconomic indicators, using hotspot detection (Local Moran's I, Getis-Ord Gi) to find neighborhoods where high pollution and elevated respiratory illness coincide.

### Analysis completed so far
The portion of the study actually implemented in R uses an urban air quality/health impact dataset containing daily pollutant measurements, weather variables, and a composite respiratory health impact score:

1. Load and clean the dataset; standardize column names.
2. Auto-detect pollutant, health outcome, and control (weather/seasonal) variables via pattern matching.
3. Coerce relevant columns to numeric and drop incomplete records.
4. Compute a Pearson correlation matrix across pollutants, AQI, health impact score, and weather controls.
5. Visualize relationships with a pairwise scatterplot matrix (`GGally::ggpairs`).

## Packages Used
`tidyverse`, `skimr`, `GGally`, `broom`, `car`, `mgcv`

## Results

The correlation matrix revealed that **AQI had the strongest relationship with the health impact score (r = 0.615)** — a moderately strong positive association, meaning that as overall air quality worsens, respiratory health impacts increase. Individual pollutants showed weaker positive correlations: PM₂.₅ (r = 0.220), PM₁₀ (r = 0.183), O₃ (r = 0.158), NO₂ (r = 0.124), and SO₂ (r ≈ 0.016). Weather variables (temperature, humidity, wind speed) showed correlations close to zero, indicating no strong direct relationship with the health impact score in this dataset.

![Correlation matrix of pollutants, AQI, weather, and health impact score](airquality-correlation-matrix.png)

**Console output.** Pearson correlation matrix across AQI, individual pollutants (PM10, PM2.5, NO2, SO2, O3), weather variables, and the health impact score.

The pairwise scatterplot matrix supported these findings — most variable pairs showed dense, cloud-like distributions with no clear linear pattern, consistent with the low correlation values. The AQI–health impact relationship stood out as the clearest trend among the variables analyzed.

![Pairwise scatterplot matrix of pollutants and AQI](airquality-pairwise-scatterplot.png)

**Pairwise scatterplot matrix (`GGally::ggpairs`).** Relationships among record ID, AQI, PM10, and temperature, with correlation coefficients annotated in each panel.

## Conclusion
This analysis provides quantitative support for the well-established link between air pollution and respiratory health. While individual pollutants showed comparatively weak correlations, AQI demonstrated a moderately strong relationship with the health impact score, reinforcing its value as a summary measure of air quality risk. The results align with prior research while also highlighting the complexity of urban pollution systems, where no single pollutant fully explains health outcomes.

## Future Work
- Fit regression models (e.g., linear or generalized additive models via `mgcv`) of the health impact score on pollutants and controls, rather than relying on correlation alone.
- Incorporate time-series methods (Quasi-Poisson regression, DLNMs) to capture lagged pollution effects.
- Bring in spatial and socioeconomic data to examine neighborhood-level disparities in exposure and outcomes, as outlined in the broader study design above.

## How to Run
1. Open `Air Quality Research.R` in RStudio.
2. Place `air_quality_health_impact_data.csv` in the working directory.
3. Run the script top to bottom; required packages will be installed automatically if missing.

## Data Sources Referenced in the Paper
1. https://pmc.ncbi.nlm.nih.gov/articles/PMC1913584/
2. https://www.mdpi.com/1660-4601/19/5/3095
3. https://link.springer.com/article/10.1007/s11356-019-04781-3
4. https://link.springer.com/article/10.1186/1476-069x-8-25#Sec3
5. https://www.sciencedirect.com/science/article/abs/pii/S0091674908004077
6. https://www.sciencedirect.com/science/article/abs/pii/S1526054214000281
7. https://link.springer.com/article/10.1186/s12940-024-01083-1
8. https://pjssreview.com/index.php/13/article/view/4
9. https://csreviewjournal.com/index.php/10/article/view/11
10. https://pmc.ncbi.nlm.nih.gov/articles/PMC59535/#ref-list1
11. https://pmc.ncbi.nlm.nih.gov/articles/PMC59535/#sec9
12. https://pmc.ncbi.nlm.nih.gov/articles/PMC8541932/
13. https://pmc.ncbi.nlm.nih.gov/articles/PMC6351918/
14. https://pmc.ncbi.nlm.nih.gov/articles/PMC3155438/
15. https://pmc.ncbi.nlm.nih.gov/articles/PMC10487870/
16. https://pmc.ncbi.nlm.nih.gov/articles/PMC12677569/
17. https://pmc.ncbi.nlm.nih.gov/articles/PMC8718688/
18. https://pmc.ncbi.nlm.nih.gov/articles/PMC11451890/
19. https://pmc.ncbi.nlm.nih.gov/articles/PMC10990824/
