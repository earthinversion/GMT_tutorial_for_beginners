
start=`date +%s.%N`

ctr="-Xc -Yc"

# gmt.conf
## The user can edit the gmt.conf file to set the default parameters
## The path to gmt.conf is /usr/share/gmt/conf

# Mercator Projection
## Option	Purpose
### -A	Exclude small features or those of high hierarchical levels
### -D	Select data resolution (full, high, intermediate, low, or crude)
### -G	Set color of dry areas (default does not paint)
### -I	Draw rivers (chose features from one or more hierarchical categories)
### -L	Plot map scale (length scale can be km, miles, or nautical miles)
### -N	Draw political borders (including US state borders)
### -S	Set color for wet areas (default does not paint)
### -W	Draw coastlines and set pen thickness
min_area=10000 #minimum area in km^2
### I1 -> permanent major rivers
### -Jm[lon0/[lat0/]]scale or -JM[lon0/[lat0/]]width
gmt pscoast -R270/290/0/20 -JM6i -P -B4 -Gchocolate -W0.25p,blue -Slightblue $ctr -BSWne+t"Mercator Projection" -Dh -A${min_area} -I1 > GMT_figure6.ps


##To plot a green Africa with white outline on blue background, with permanent major rivers in thick blue pen,
## additional major rivers in thin blue pen, and national borders as dashed lines on a Mercator map at scale 0.1 inch/degree
gmt pscoast -R-90/120/-60/60 -Jm0.05i -B10 -I1/1p,blue -N1/0.5p,-- \
		 -I2/0.25p,blue -W1p,black -Ggreen -Sblue -A${min_area} -Dc $ctr > GMT_figure7.ps


# Alber's Projection
## -JBlon_0/lat_0/lat_1/lat_2/width
### where (lon_0, lat_0) is the map (projection) center and lat_1, lat_2 are the two standard parallels
### where the cone intersects the Earth’s surface.
gmt pscoast -R-130/-70/24/52 -JB-100/35/33/45/6i -Ba -B+t"Conic Projection" -N1/thickest -N2/thinnest -A500 -Ggray -Slightblue -Wthinnest -P $ctr > GMT_figure8.ps


# Orthographic Projection
## -JGlon_0/lat_0/width
### where (lon_0, lat_0) is the center of the map (projection)
gmt pscoast -Rg -JG280/30/6i -Bag -Dc -A5000 -Gwhite -SDarkTurquoise -P $ctr > GMT_figure9.ps


# Eckert IV and VI projection
## -JK[f|s]lon_0/width
### where f gives Eckert IV (4) and s (Default) gives Eckert VI (6).
### The lon_0 is the central meridian (which takes precedence over the mid-value implied by the -R setting)
gmt pscoast -Rg -JKf180/9i -Bag -Dc -A5000 -Gchocolate -SDarkTurquoise -Wthinnest $ctr > GMT_figure10.ps


figure=GMT_figure10.ps
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
rm -f *.ps *.pdf *.history