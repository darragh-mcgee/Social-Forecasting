## Project Overview
This project was developed for the **Social Forecasting Final Assignment (2025)**.  
It forecasts monthly trends in total shootings across New York City, supporting proactive public safety planning for the **Mayor's Office of Criminal Justice (MOCJ)**.

The analysis applies an **ARIMA(2,0,0)(0,1,1)[12] with drift** model to predict shooting patterns using historical NYPD data from **January 2006 to December 2019**.


## Contents
| File | Description |
|:-----|:------------|
| **Final Project Code.R** | Full R script for data preparation, modeling, diagnostics, and forecast generation. |
| **NYC Shoooting Data.csv** | Raw dataset sourced from NYC OpenData (NYPD Historic Shooting Incident Database). |


## Data Source
- **NYC OpenData Portal**  
  [NYPD Historic Shooting Incident Database](https://data.cityofnewyork.us/Public-Safety/NYPD-Shooting-Incident-Data-Historic/833y-fsy8)

**Note:** Data from 2020–2024 were excluded due to distortions caused by the COVID-19 pandemic.  
Forecasts were validated using a split of:
- **Training set:** January 2006 – December 2016
- **Validation set:** January 2017 – December 2019


## Methodology
- **Time-Series Modeling:** AutoRegressive Integrated Moving Average (ARIMA)
- **Model Selection:** `auto.arima()` function from the `forecast` R package
- **Key Metrics:** MAE, MAPE, RMSE, Theil’s U
- **Residual Diagnostics:** ACF plots, Ljung-Box test, residual plots
