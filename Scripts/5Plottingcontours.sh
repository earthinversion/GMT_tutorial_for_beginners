start=`date +%s.%N`

ctr="-Xc -Yc"
# extract the bermuda bathymetry from the etopo1 grd file and saving it into ber_bathy.nc
gmt grdcut ../Data/ETOPO1_Bed_g_gmt4.grd -R-66/-60/30/35 -Gber_bathy.nc -V


## obtain the information about the netcdf file ber_bathy.nc
gmt grdinfo ber_bathy.nc

# gmt grdcontour ber_bathy.nc -C100 -S4 -Dcontours_%c.txt ###smoothed 100m contour data in the text file

## --->
### ber_bathy.nc: Title: Produced by grdcut
### ber_bathy.nc: Command: grdcut /home/utpal/bin/etopo1/ETOPO1_Bed_g_gmt4.grd -R-66/-60/30/35 -Gber_bathy.nc -V
### ber_bathy.nc: Remark: 
### ber_bathy.nc: Gridline node registration used [Geographic grid]
### ber_bathy.nc: Grid file format: nf = GMT netCDF format (32-bit float), COARDS, CF-1.5
### ber_bathy.nc: x_min: -66 x_max: -60 x_inc: 0.0166666666667 name: longitude [degrees_east] nx: 361
### ber_bathy.nc: y_min: 30 y_max: 35 y_inc: 0.0166666666667 name: latitude [degrees_north] ny: 301
### ber_bathy.nc: z_min: -5953 z_max: 166 name: z
### ber_bathy.nc: scale_factor: 1 add_offset: 0
### ber_bathy.nc: format: netCDF-4 chunk_size: 181,151 shuffle: on deflation_level: 3

### Option	Purpose
### -Aannot_int	Annotation interval and attributes
### -Ccont_int	Contour interval
### -Ggap	Controls placement of contour annotations
### -Llow/high	Only draw contours within the low to high range
### -Qcut	Do not draw contours with fewer than cut points
### -Ssmooth	Resample contours smooth times per grid cell increment
### -T[+|-][+dgap[/length]][+l[labels]]	Draw tick-marks in downhill
###  	direction for innermost closed contours. Add tick spacing
###  	and length, and characters to plot at the center of closed contours
### -W[a|c]pen	Set contour and annotation pens
### -Z[+s *factor*][+ooffset]	Subtract offset and multiply data by factor prior to processing

# Plotting plain contour map using 2000 m as annotation interval and 500 m as contour interval
gmt grdcontour ber_bathy.nc -JM7i -C500 -A2000+f10p -P -B1g30m -S4 $ctr > GMT_figure15.ps

# Gridding on arbitrarily spaced data
### Option	Purpose
### -Rxmin/xmax/ymin/ymax	The desired grid extent
### -Ixinc[yinc]	The grid spacing (append m or s for minutes or seconds of arc)
### -Ggridfile	The output grid filename

#Nearest Neighbour gridding
### Option	Purpose
### -Sradius[u]	Sets search radius. Append u for radius in that unit [Default is x-units]
### -Eempty	Assign this value to unconstrained nodes [Default is NaN]
### -Nsectors	Sector search, indicate number of sectors [Default is 4]
### -W	Read relative weights from the 4th column of input data

gmt info ../Data/ship.xyz #-> ship.xyz: N = 82970	<245/254.705>	<20/29.99131>	<-7708/-9>

if [ ! -f ship.nc ]; then #interpolation if the interpolated file is not present
	gmt nearneighbor -R245/255/20/30 -I5m -S40k -Gship.nc -V ../Data/ship.xyz #search radius 40 km
fi
gmt grdcontour ship.nc -JM6i -P -Ba -C250 -A1000+f12p $ctr > GMT_figure16.ps



# Gridding with Splines in Tension
### Physically, we are trying to force a thin elastic plate to go through all our data points; 
### the values of this surface at the grid points become the gridded data. 
### Mathematically, we want to find the function z(x, y) that satisfies the following equation away from data constraints:### 

### (1-t)nabla^2 z -t nabla z =0### 

### where t is the “tension” in the 0-1 range.
### Option	Purpose
### -Aaspect	Sets aspect ratio for anisotropic grids.
### -Climit	Sets convergence limit. Default is 1/1000 of data range.
### -Ttension	Sets the tension [Default is 0]

##It is required to pre-process the data before gridding using surface
### There are three pre-processors: blockmean, blockmedian, and blockmode
#### As a rule of thumb, we use means for most smooth data (such as potential fields)
#### and medians (or modes) for rough, non-Gaussian data (such as topography).

#
### Option	Purpose
### -r	Choose pixel node registration [Default is gridline]
### -W[i|o]	Append i or o to read or write weights in the 4th column

gmt blockmedian -R245/255/20/30 -I5m -V ../Data/ship.xyz > ship_5m.xyz
gmt surface ship_5m.xyz -R245/255/20/30 -I5m -Gship_surf.nc -V
gmt grdcontour ship_surf.nc -JM6i -P -Ba -C250 -A1000+f12p $ctr > GMT_figure17.ps

#### There are numerous options available to us at this point:#### 

#### We can reset all nodes too far from a data constraint to the NaN value.
#### We can pour white paint over those regions where contours are unreliable.
#### We can plot the landmass which will cover most (but not all) of the unconstrained areas.
#### We can set up a clip path so that only the contours in the constrained region will show. -> we will use this one

### The psmask module can read the same preprocessed data and set up a contour mask based on the data distribution. 
### Once the clip path is activated we can contour the final grid; we finally deactivate the clipping with a second call to psmask.
gmt psmask -R245/255/20/30 -I5m ship_5m.xyz -JM6i -Ba -Glightgray -P -K -V $ctr> GMT_figure18.ps #clip path colored using light gray
gmt grdcontour ship.nc -J -O -K -C250 -A1000 >> GMT_figure18.ps
gmt psmask -C -O >> GMT_figure18.ps

figure=GMT_figure18.ps
end=`date +%s.%N`


time_elapsed() {
dt=$(echo "$2 - $1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)
printf "Total runtime: %d:%02d:%02d:%02.4f\n" $dd $dh $dm $ds
}


time_elapsed $start $end
gv ${figure}
rm -f *.ps *.pdf *.history *.txt *.cpt *.nc *.xyz