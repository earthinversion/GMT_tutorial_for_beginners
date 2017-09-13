start=`date +%s.%N`

ctr="-Xc -Yc"

# creating CPTs
##CPTs can be created in any number of ways. GMT provides two mechanisms:###

###1. Create simple, linear color tables given a master color table (several are built-in) 
###and the desired z-values at color boundaries (makecpt)
###2. Create color tables based on a master CPT color table and 
###the histogram-equalized distribution of z-values in a gridded data file (grd2cpt)


## Option	Purpose
## -C	Set the name of the master CPT to use
## -I	Reverse the sense of the color progression
## -V	Run in verbose mode
## -Z	Make a continuous rather than discrete table

## To make discrete and continuous color CPTs for data that ranges from -20 to 60, with color changes at every 10
gmt makecpt -Crainbow -T-20/60/10 > disc.cpt
gmt makecpt -Crainbow -T-20/60/10 -Z > cont.cpt

# psscale
### Option	Purpose
### -Ccpt	The required CPT
### -Dxxpos/ypos+wlength/width[+h]	Sets the position and dimensions of scale bar.
###  	Append +h to get horizontal bar
### -Imax_intensity	Add illumination effects

gmt psbasemap -R0/6/0/9 -Jx1i -P -B0 -K $ctr > GMT_figure19.ps
gmt psscale -Dx1i/1i+w4i/0.5i+h -Cdisc.cpt -B+tdiscrete -O -K >> GMT_figure19.ps
gmt psscale -Dx1i/3i+w4i/0.5i+h -Ccont.cpt -B+tcontinuous -O -K >> GMT_figure19.ps
gmt psscale -Dx1i/5i+w4i/0.5i+h -Cdisc.cpt -B+tdiscrete -I0.5 -O -K >> GMT_figure19.ps
gmt psscale -Dx1i/7i+w4i/0.5i+h -Ccont.cpt -B+tcontinuous -I0.5 -O >> GMT_figure19.ps


# Colored Images
gmt grdcut ../Data/ETOPO1_Bed_g_gmt4.grd -R-108/-103/35/40 -Grelief_data.nc
gmt grdinfo relief_data.nc 
###-->
#### relief_data.nc: Title: Produced by grdcut
#### relief_data.nc: Command: grdcut /home/utpal/bin/etopo1/ETOPO1_Bed_g_gmt4.grd -R-108/-103/35/40 -Grelief_data.nc
#### relief_data.nc: Remark: 
#### relief_data.nc: Gridline node registration used [Geographic grid]
#### relief_data.nc: Grid file format: nf = GMT netCDF format (32-bit float), COARDS, CF-1.5
#### relief_data.nc: x_min: -108 x_max: -103 x_inc: 0.0166666666667 name: longitude [degrees_east] nx: 301
#### relief_data.nc: y_min: 35 y_max: 40 y_inc: 0.0166666666667 name: latitude [degrees_north] ny: 301
#### relief_data.nc: z_min: 1072 z_max: 4096 name: z
#### relief_data.nc: scale_factor: 1 add_offset: 0
#### relief_data.nc: format: netCDF-4 chunk_size: 151,151 shuffle: on deflation_level: 3
#### Total runtime: 0:00:00:0.3168
gmt makecpt -Crainbow -T1000/5000/500 -Z > topo.cpt

#grdimage options
### Option	Purpose
### -Edpi	Sets the desired resolution of the image [Default is data resolution]
### -Iintenfile	Use artificial illumination using intensities from intensfile
### -M	Force gray shade using the (television) YIQ conversion
gmt grdimage relief_data.nc -JM6i -P -Ba -Ctopo.cpt $ctr -V -K > GMT_figure20.ps
gmt psscale -DjTC+w5i/0.25i+h+o0/-1i -Rrelief_data.nc -J -Ctopo.cpt -I0.4 -By+lm -O >> GMT_figure20.ps


##The plain color map lacks detail and fails to reveal the topographic complexity of this Rocky Mountain region.
# grdgradient options
### Option	Purpose
### -Aazimuth	Azimuthal direction for gradients
### -fg	Indicates that this is a geographic grid
### -N[t|e][+snorm][+ooffset]	Normalize gradients by norm/offset [= 1/0 by default].
###  	Insert t to normalize by the inverse tangent transformation.
###  	Insert e to normalize by the cumulative Laplace distribution.

###-N[e|t][amp][+ssigma][+ooffset]
gmt grdgradient relief_data.nc -Ne0.6 -A100 -fg -Gus_i.nc #-Ne normalizes using a cumulative Laplace distribution 
#yielding gn = amp * (1.0 - exp(sqrt(2) * (g - offset)/ sigma)), where sigma is estimated using the L1 norm of (g - offset) if it is not given.

gmt grdimage relief_data.nc -Ius_i.nc -JM6i -P -Ba -Ctopo.cpt $ctr -K > GMT_figure21.ps
gmt psscale -DjTC+w5i/0.25i+h+o0/-1i -Rrelief_data.nc -J -Ctopo.cpt -I0.4 -By+lm -O >> GMT_figure21.ps


figure=GMT_figure21.ps
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