# GMT Tutorial for Beginners
## Requirements:
* Pre-installed GMT-5, check by typing `gmt` in terminal.
* Pre-installed netcdf-5, check by typing `ncdump`.
* Pre-installed ghostview package, check by typing `gv`.
* Downloaded ETOPO1_Bed_g_gmt4.grd from the [NOAA website](https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/bedrock/grid_registered/netcdf/).

## Installing GMT
In Ubuntu: `sudo apt-get install gmt gmt-dcw gmt-gshhg`

In Mac: `brew install gmt`

## Description of the Package:
The package consists of three directories: Data, Scripts and Figures.

* The __Data__ directory contains the data files required to run the scripts in the __Scripts__ directory.
* The __Scripts__ directory consists of all the bash scripts numbered from 1-8. 
    - `1linearPlots.sh`: Contains commands for making basemap for linear projections including the log-log plot. It also explains how to add title, xlabel, ylabel, tick-marks, background-color to the plot.
    - `2PlottingMaps.sh`: This explains how to plot the Mercator projection, Alber's projection, Orthographic projection, Eckert projection.
    - `3PlottingLinesSymbols.sh`: This script explains the use of `psxy` command to plot the lines and symbols. It also contains the commands to plot the earthquake epicenter with colors representing depths and symbol size representing magnitude.
    - `4PlottingTexts.sh`: This script explains how to type texts onto the plots. The user can even type mathematical equations.
    - `5Plottingcontours.sh`: This bash script explains how to plot the contour lines using the command `grdcontour`. It also explains how to cut the large data set using the `grdcut` command and obtain the information about it using the `grdinfo`. It also explains how to do interpolation of data (__nearest neighbour__ and __spline__).
    - `6Manipulating_Images.sh`: It contains the description of how to make the cpt files, and plot the colorbars using `psscale` command. It also explains plotting the relief data.
    - `7multiD_maps.sh`: This script explains how to plot the multidimensional netcdf data in GMT. 
    - `8three-DPlots.sh`: It includes how to plot the data as 3D plots using two methods: mesh plot, color-coded surface. 
* The __Figures__ directory consists of all the example plots from 1-24.