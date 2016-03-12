set term pngcairo font "OpenSans, 28" size 1920,1028
set xlabel "Time (seconds)"
set ylabel "Firing rate(Hz)"
set yrange [0:200]

set output "firing-rates.png"
set title "Firing rate"
plot "firing-rates.gdf" with lines lw 6 title "";
