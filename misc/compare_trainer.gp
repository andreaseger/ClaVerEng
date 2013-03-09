set autoscale

set xlabel "cost"
set ylabel "gamma"
set zlabel "accuracy"

set pm3d
splot "tmp/20121203_1822_function_results" title "grid_search" with lines pal, \
      "tmp/20121203_1756_function_results" title "doe heuristic" with points linecolor rgb "green"