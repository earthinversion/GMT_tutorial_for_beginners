start=`date +%s.%N`

ctr="-Xc -Yc"

#psxy options
## Option	 Purpose
### -A	Suppress line interpolation along great circles
### -Ccpt	Let symbol color be determined from z-values and the cpt file
### -E[x|X][y|Y][+wcap][+ppen]	Draw selected error bars with specified attributes
### -Gfill	Set color for symbol or fill for polygons
### -L[options]	Explicitly close polygons or create polygon (see psxy)
### -N[c|r]	Do Not clip symbols at map borders
### -S[symbol][size]	Select one of several symbols
### -Wpen	Set pen for line or symbol outline

## Symbols
### Option	Symbol
### -S-size	horizontal dash; size is length of dash
### -Sasize	star; size is radius of circumscribing circle
### -Sbsize[/base][u]	bar; size is bar width, append u if size is in x-units
###  	Bar extends from base [0] to the y-value
### -Scsize	circle; size is the diameter
### -Sdsize	diamond; size is its side
### -Se	ellipse; direction (CCW from horizontal), major, and minor axes
###  	are read from the input file
### -SE	ellipse; azimuth (CW from vertical), major, and minor axes in kilometers
###  	are read from the input file
### -Sgsize	octagon; size is its side
### -Shsize	hexagon; size is its side
### -Sisize	inverted triangle; size is its side
### -Sksymbol/size	kustom symbol; size is its side
### -Slsize+tstring	letter; size is fontsize. The string can be a letter or a text string
###  	Append +ffont to set font and +jjust for justification
### -Snsize	pentagon; size is its side
### -Sp	point; no size needed (1 pixel at current resolution is used)
### -Srsize	rect, width and height are read from input file
### -Sssize	square, size is its side
### -Stsize	triangle; size is its side
### -Svparams	vector; direction (CCW from horizontal) and length are read from input data
###  	Append parameters of the vector; see psxy for syntax.
### -SVparams	vector, except azimuth (degrees east of north) is expected instead of direction
###  	The angle on the map is calculated based on the chosen map projection
### -Sw[size]	pie wedge; start and stop directions (CCW from horizontal) are read from
###  	input data
### -Sxsize	cross; size is length of crossing lines
### -Sysize	vertical dash; size is length of dash

# Data Information
cat <<eof> test_data.txt
3 5
2 8
1 9
3 7
8 4
11 3
12 4
26 14
eof

gmt info test_data.txt #-> test_data.txt: N = 8	<1/26>	<3/14> -> num of lines, min/max min/max


# Plot a line using given data
gmt psxy test_data.txt -R1/26/3/14 -Jx.4i -Baf -Wthinner -K > GMT_figure11.ps
gmt psxy test_data.txt -R1/26/3/14 -Jx.4i -Baf -Sh.3 -Gblue -Wthinner -O >> GMT_figure11.ps

# Plotting Earthquakes based on magnitude and depths
cat <<eof> earthquakeData.txt
Historical Tsunami Earthquakes from the NGDC Database
Year  Mo  Da  Lat+N  Long+E  Dep  Mag
1987  01  04  49.77  149.29  489  4.1
1987  01  09  39.90  141.68  067  6.8
eof

# colorPallete cpt
### color palette for seismicity
#z0  color   z1 color
cat <<eof> quakes.cpt
0    red    100 red
100  green  300 green
300  blue  1000 blue
eof

# gmt makecpt -Cred,green,blue -T0,80,300,1000 > quakes.cpt #doesn't work
gmt pscoast -R130/150/35/50 -JM6i -B5 -P -Ggray $ctr -K > GMT_figure12.ps
### To skip the first 3 header records and then select the 4th, 3rd, 5th, and 6th column and scale the last column by 0.1
### -i4,3,5,6s0.1
gmt psxy -R -J -O earthquakeData.txt -Wfaint -i4,3,5,6s0.1 -h2 -Scc -Cquakes.cpt >> GMT_figure12.ps #-Scc for circles in cm



## Plotting catalog.txt earthquakes
awk -F";" 'NR>1{print $7,$8,$9,$11*0.1}' ../Data/catalog.dat >EQ_catalog.txt #long, lat, depth, magnitude
gmt pscoast -Rg -JKf180/9i -Bag -Dc -A5000 -Gwhite -SDarkTurquoise -Wthinnest $ctr -K > GMT_figure13.ps
gmt psxy -R -J -O EQ_catalog.txt -Wblack -Scc -Cquakes.cpt >> GMT_figure13.ps #-Scc for circles in cm



figure=GMT_figure13.ps
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

rm -f *.ps *.pdf *.history *.txt *.cpt