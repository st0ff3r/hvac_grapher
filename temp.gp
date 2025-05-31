set termopt enhanced
set title 'Temperature'
set xlabel 'date'
set grid
set terminal png size 2000,800
set output '/data/temp.png.tmp'
set datafile separator "\t"
set timefmt "%s"
set format x "%Y-%m-%d %H:%M:%S"
set xdata time
plot '/data/temp.txt' using 1:2 with lines lt rgb "#3874c8" title 'outside air {\260}C', \
     '' using 1:3 with lines lt rgb "#c33f25" title 'supply air {\260}C', \
     '' using 1:4 with lines lt rgb "#696969" title 'room temp {\260}C', \
     '' using 1:5 with lines lt rgb "#f1d54c" title 'return air {\260}C', \
     '' using 1:6 with lines lt rgb "#693b28" title 'exhaust air {\260}C'
