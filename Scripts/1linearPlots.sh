
center="-Xc -Yc"

#Linear Projection
##10 to 70 in x and from -3 to 8 in y, with automatic annotation intervals
gmt psbasemap -R10/70/-3/8 -JX6i/5i -Ba -BWeSn+glightred+t"Title of the plot" -Bx+l"xlabel" -By+l"ylabel" -P ${center}  > GMT_figure1.ps
# gv GMT_tut_1.ps

## only left and bottom axes annotated, using xscale = yscale = 1.0, ticking every 1 unit and annotating every 2
gmt psbasemap -R0/9/0/5 -Jx1 -Bf1a2 -Bx+lDistance -By+l"No of samples" -BWeSn ${center} > GMT_figure2.ps
# gv linear.ps


#Logarithmic Projection
## log–log plot
## the raw x data range from 3 to 9613 and that y ranges from 3.2 10^20 to 6.8 10^24
gmt psbasemap -R1/10000/1e20/1e25 -JX9il/6il -Bxa2+l"Wavelength (m)" -Bya1pf3+l"Power (W)" -BWS > GMT_figure3.ps
# gv GMT_tut_2.ps

## the x-axis is 25 cm and annotated every 1-2-5 and the y-axis is 15 cm and annotated every power of 10 but has tick-marks every 0.1
gmt psbasemap -R1/10000/1e20/1e25 -JX25cl/15cl -Bx2+lWavelength -Bya1pf3+lPower -BWS $center > GMT_figure4.ps
gv loglog.ps

# Power axes
## To design an axis system to be used for a depth-sqrt(age) plot with depth positive down,
## ticked and annotated every 500m, and ages annotated at 1 my, 4 my, 9 my etc
gmt psbasemap -R0/100/0/5000 -Jx1p0.5/-0.001 -Bx1p+l"Crustal age" -By500+lDepth $center > GMT_figure5.ps
gmt psconvert -Tf GMT_figure5.ps

gv GMT_figure5.ps

rm -f *.ps *.pdf *.history