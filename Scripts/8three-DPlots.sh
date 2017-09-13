# grdview can make two kinds of plots:

## 1. Mesh or wire-frame plot (with or without superimposed contours)
## 2. Color-coded surface (with optional shading, contours, or draping).

##Other required arguments:
### relief_file; a gridded data set of the surface.
### -J for the desired map projection.
### -JZheight for the vertical scaling.
### -pazimuth/elevation for the vantage point.

## Other options
### Option	Purpose
### -Ccpt	The cpt is required for color-coded surfaces and for contoured mesh plots
### -Gdrape_file	Assign colors using drape_file instead of relief_file
### -Iintens_file	File with illumination intensities
### -Qm	Selects mesh plot
### -Qs[+m]	Surface plot using polygons; append +m to show mesh. This option allows for -W
### -Qidpi[g]	Image by scan-line conversion. Specify dpi; append g to force gray-shade image. -B is disabled.
### -Wpen	Draw contours on top of surface (except with -Qi)

gmt grdcut ../Data/ETOPO1_Bed_g_gmt4.grd -R-66/-60/30/35 -Gber_bathy.nc -V

# Mesh plot
gmt grd2cpt ber_bathy.nc -Cocean > bermuda.cpt
gmt grdview ber_bathy.nc -JM5i -P -JZ2i -p135/30 -Ba -Cbermuda.cpt > GMT_figure23.ps


# Color plot
gmt grdcut /home/utpal/bin/etopo1/ETOPO1_Bed_g_gmt4.grd -R-108/-103/35/40 -Grelief_data.nc
gmt grdgradient relief_data.nc -Ne0.6 -A100 -fg -Gus_i.nc
gmt grdview relief_data.nc -JM6i -p135/35 -Qi50 -Ius_i.nc -Ctopo.cpt -Ba -JZ0.7i > GMT_figure24.ps #resolution is 50dpi

figure=GMT_figure24.ps

gv ${figure}

rm -f *.ps *.pdf *.history *.txt *.cpt *.nc *.xyz