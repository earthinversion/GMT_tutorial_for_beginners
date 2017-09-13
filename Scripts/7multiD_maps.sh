# Plotting Seasonal Analysed Mean Temperature from the World Ocean Atlas 1998 
ncdump -h ../Data/otemp.anal1deg.nc
### netcdf otemp.anal1deg {
### dimensions:
### 	lon = 360 ;
### 	lat = 180 ;
### 	level = 33 ;
### 	time = UNLIMITED ; // (4 currently)
### variables:
### 	float lat(lat) ;
### 		lat:units = "degrees_north" ;
### 		lat:long_name = "Latitude" ;
### 		lat:actual_range = 89.5f, -89.5f ;
### 		lat:standard_name = "latitude" ;
### 		lat:axis = "Y" ;
### 	float lon(lon) ;
### 		lon:units = "degrees_east" ;
### 		lon:long_name = "Longitude" ;
### 		lon:actual_range = 0.5f, 359.5f ;
### 		lon:standard_name = "longitude" ;
### 		lon:axis = "X" ;
### 	float level(level) ;
### 		level:units = "meters" ;
### 		level:positive = "down" ;
### 		level:long_name = "Level" ;
### 		level:actual_range = 0.f, 5500.f ;
### 		level:axis = "Z" ;
### 	double time(time) ;
### 		time:units = "days since 1-1-1 00:00:0.0" ;
### 		time:long_name = "Time" ;
### 		time:actual_range = 0., 273. ;
### 		time:delta_t = "0000-03-00 00:00:00" ;
### 		time:avg_period = "0097-00-00 00:00:00" ;
### 		time:prev_avg_period = "0000-01-00 00:00:00" ;
### 		time:ltm_range = 693597., 729026. ;
### 		time:standard_name = "time" ;
### 		time:axis = "T" ;
### 	float otemp(time, level, lat, lon) ;
### 		otemp:long_name = "Ocean Temperature, analyzed mean, 1-deg grid, Seasonal" ;
### 		otemp:valid_range = -10.f, 90.f ;
### 		otemp:actual_range = -2.1f, 32.7039f ;
### 		otemp:units = "deg C" ;
### 		otemp:add_offset = 0.f ;
### 		otemp:scale_factor = 1.f ;
### 		otemp:missing_value = -9.96921e+36f ;
### 		otemp:var_desc = "Ocean Temperature, analyzed mean" ;
### 		otemp:dataset = "NODC World Ocean Atlas 1998" ;
### 		otemp:level_desc = "Multiple Levels" ;
### 		otemp:statistic = "Analyzed Mean" ;
### 		otemp:parent_stat = "Mean" ;### 

### // global attributes:
### 		:title = "NODC World Ocean Atlas 1998" ;
### 		:history = "created February 2000 by Hoop" ;
### 		:platform = "Marine Analyses" ;
### 		:Conventions = "COARDS" ;
### 		:References = "https://www.esrl.noaa.gov/psd/data/data.nodc.woa98.html" ;
### 		:dataset_title = "NODC (Levitus) World Ocean Atlas 1998" ;
### }

###Here, we want to plot the four dimensional variable otemp
gmt makecpt -Cno_green -T-2/30/2 > otemp.cpt

### The addition ”?otemp[2,0]” indicates which variable to retrieve from the netCDF 
### file (otemp) and that we need the third time step and first level. 
### The numbering of the time steps and levels starts at zero, therefore “[2,0]”.

gmt grdimage -Rg -JW180/9i "../Data/otemp.anal1deg.nc?otemp[2,0]" -Cotemp.cpt -Bag > GMT_figure22.ps

figure=GMT_figure22.ps

gv ${figure}
rm *.ps *.cpt *.history