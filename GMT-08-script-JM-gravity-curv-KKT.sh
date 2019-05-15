#!/bin/sh
# Purpose: Gravity model map
# Mercator projection (here: Kuril-Kamchatka Trench).
# GMT modules: grd2cpt, grdimage, pscoast, psbasemap, psscale, psimage, logo, pstext
# Step-1. Generate a file
ps=Curv_KKT.ps
# Step-2. Extract subset of img file in Mercator or Geographic format
img2grd curv_27.1.img -R140/170/40/60 -Gcurv.grd -T1 -I1 -E -S0.1 -V
# Step-3. Generate a color palette table from grid
gmt grd2cpt curv.grd -CGMT_haxby > curv.cpt
# Step-4. Generate gravity image with shading
gmt grdimage curv.grd -I+a45+nt1 -R140/170/40/60 -JM6i -Ccurv.cpt -P -K > $ps
# Step-5. Add basemap: grid, title, costline
gmt pscoast -R -J -P \
	-V -W0.25p \
    -Df -B+t"Marine free-air vertical gravity anomaly: Kuril-Kamchatka Trench area" \
	-Bxa4g3f2 -Bya4g3f2 \
    --FORMAT_GEO_MAP=dddF \
    --MAP_TITLE_OFFSET=1c \
    --MAP_FRAME_PEN=dimgray \
    --MAP_FRAME_WIDTH=0.1c \
    --MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    --MAP_GRID_PEN_PRIMARY=thinnest \
    --MAP_GRID_CROSS_SIZE_PRIMARY=0.1i \
    --FONT_TITLE=14p,Palatino-Roman,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    --FONT_LABEL=7p,Helvetica,dimgray \
    -O -K >> $ps
# Step-6. Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,dimgray \
    --MAP_ANNOT_OFFSET=0.0c \
    -Tdg142/58+w0.5c+f2+l \
    -Lx5.2i/-0.5i+c50+w500k+l"Mercator projection. Scale, km"+f \
    -UBL/-15p/-40p -O -K >> $ps
# Step-7. Add legend
gmt psscale -R -J -Ccurv.cpt \
    -Dg135/40+w4.7i/0.15i+v+o1.0/0i+ml  \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=5p,Helvetica,dimgray \
    -Baf+l"Marine free-air vertical gravity modelling color scale" \
    -I0.2 -By+lmGal -O -K >> $ps
# Step-8. Add logo
gmt logo -R -J -Dx6.5/-2.2+o0.1i/0.1i+w2c -O -K >> $ps
# Step-9. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X-2.5c -Y7.0c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 15.0 Global free-air vertical gravity gradient grid: CryoSat-2 and Jason-1, 1 min resolution
EOF
