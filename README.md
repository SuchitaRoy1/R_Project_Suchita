# Empirical Macro-Liquidity & Central Bank Policy Tools Analysis (2020–2026)

## Overview
An empirical analysis in **R** examining systemic liquidity management operations, foreign asset movements, and commercial banking flows in India. Using 56 monthly observations from **March 2022 to October 2026** (`Regression_Monthly`), this project investigates how Reserve Bank liquidity absorption tools (**SDF** and **VRRR**) interact with changes in **Net Foreign Assets (NFA)**, bank credit, and aggregate deposits.

## Repository Contents
* **`Macro_Liquidity_Project.R`**: Complete R script covering dataset inspection, `dplyr` filtering and variable construction, conditional liquidity classification, loop-based threshold counting, and `ggplot2` OLS trend visualization.
* **`Surplus Liquidity Regression by suchita.xlsx`**: Structured macroeconomic dataset containing monthly and daily observations (2020–2026), variable definitions, and data-quality checks.
* **`Macro_Liquidity_Analysis_Project_Report.docx`**: Full project report detailing methodology, empirical findings, data considerations, and planned econometric extensions.
* **`R_Project_Suchita.Rproj`**: RStudio project file for reproducible environment management.

## Tools & Methodology
* **Language & Environment:** R, RStudio
* **Packages:** `readxl`, `tidyverse` (`dplyr`, `ggplot2`), `utf8`
* **Techniques:** Data wrangling, policy-window filtering (`window == 1`), conditional regime classification (`case_when`), loop-based threshold analysis, and Ordinary Least Squares (OLS) visual trend modeling.

## How to Run
1. Download or clone this repository.
2. Open `R_Project_Suchita.Rproj` in RStudio.
3. Run `Macro_Liquidity_Project.R` to reproduce the data processing, regime counts, and visualizations.
