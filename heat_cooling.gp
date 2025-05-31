set termopt enhanced
set title 'Cooling'
set xlabel 'date'
set grid
set terminal png size 2000,800
set output '/data/heat_cooling.png.tmp'
set datafile separator "\t"
set timefmt "%s"
set format x "%Y-%m-%d %H:%M:%S"
set xdata time
plot '/data/heat_cooling.txt' using 1:2 with lines lt rgb "#377ef7" title 'cooling %', \
     '' using 1:4 with lines lt rgb "#696969" title 'room temp {\260}C', \
     '' using 1:5 with lines lt rgb "#f1d54c" title 'heat exchanger %', \
     '' using 1:6 with lines lt rgb "#c33f25" title 'heating %'
	 