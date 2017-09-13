start=`date +%s.%N`

ctr="-Xc -Yc"
### Option	Purpose
### -Cdx/dy	Spacing between text and the text box (see -W)
### -Ddx/dy	Offsets the projected location of the strings
### -Fparams	Set font, justify, angle values or source
### -Gfill	Fills the text bos using specified fill
### -L	Lists the font ids and exits
### -N	Deactivates clipping at the borders
### -Spen	Selects outline font and sets pen attributes
### -Tform	Select text box shape
### -Wpen	Draw the outline of text box

### The input data to pstext is expected to contain the following information:### 
### `[ x   y ]  [ font]  [ angle ] [ justify ]   my text`
### The font is the optional font to use, the angle is the angle (measured counterclockwise) between the text’s
###  baseline and the horizontal, justify indicates which anchor point on the text-string should correspond
###   to the given x, y location, and my text is the text string or sentence to plot


### Code	Effect
### @~	Turns symbol font on or off
### @+	Turns superscript on or off
### @-	Turns subscript on or off
### @#	Turns small caps on or off
### @_	Turns underline on or off
### @%font%	Switches to another font; @%% resets to previous font
### @:size:	Switches to another font size; @:: resets to previous size
### @;color;	Switches to another font color; @;; resets to previous color
### @!	Creates one composite character of the next two characters
### @@	Prints the @ sign itself

gmt pstext -R0/7/0/6 -Jx1i -P -Ba -F+f15p,Times-Roman,blue+jBL $ctr << EOF > GMT_figure14.ps
1  2  You can @%33%change font@%% within text
1  1  @~D@~g@-b@- = 2@~pr@~G@~D@~h.
1  5  @:23:Institute of Earth Sciences@::, at N@!a\222ngang, Taipei
1  3  z@+2@+ = x@+2@+ + y@+2@+
1  4  It\'s 32@+o@+C today
EOF

figure=GMT_figure14.ps
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