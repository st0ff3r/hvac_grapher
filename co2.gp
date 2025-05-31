set termopt enhanced
set title 'CO_2'
set xlabel 'date'
set grid
set terminal png size 2000,800
set output '/data/co2.png.tmp'
set datafile separator "\t"
set timefmt "%s"
set format x "%Y-%m-%d %H:%M:%S"
set xdata time
plot '/data/co2.txt' using 1:2 with lines lt rgb "blue" title 'CO_2 ppm', \
     '' using 1:3 with lines lt rgb "red" title 'Supply air m^2/h', \
     '' using 1:4 with lines lt rgb "#ff9900" title 'Exthaust air m^2/h'