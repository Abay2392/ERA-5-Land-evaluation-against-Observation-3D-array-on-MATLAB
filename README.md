# ERA-5-Land-evaluation-against-Observation-3D-array-on-MATLAB
Validation of ERA5 precipitation and temperature data against observed climate datasets using RMSE, Nash-Sutcliffe Efficiency (NSE), and Pearson correlation in MATLAB.
# ERA5 Temperature and Precipitation Validation

This repository contains MATLAB code for evaluating the performance of ERA5 climate data against observed temperature and precipitation datasets.

## Objectives
- Compare ERA5 temperature and precipitation with observations.
- Assess dataset performance using statistical metrics.
- Visualize spatial patterns of model agreement and bias.

## Evaluation Metrics
- Root Mean Square Error (RMSE)
- Nash-Sutcliffe Efficiency (NSE)
- Pearson Correlation Coefficient

## Outputs
The code generates:
- Spatial maps of RMSE
- Spatial maps of NSE
- Spatial maps of Pearson correlation
- Mean temperature and precipitation maps
- Annual precipitation maps
- Difference maps between ERA5 and observations

## Data Requirements
The analysis requires:
- Observed precipitation data
- Observed temperature data
- ERA5 precipitation data
- ERA5 temperature data

Input files are stored in MATLAB `.mat` format.

## Software
- MATLAB (tested with recent versions)
- Required functions: `NSE.m` and `rmse.m`

## Author
Dr. Tagele Mossie Aschale

## Citation
If you use this code in your research, please cite the associated publication or acknowledge this repository.
