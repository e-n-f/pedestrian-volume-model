set terminal postscript
set xrange [5:150000]
set yrange [5:150000]
set logscale xy

epsilon = 1e-10

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

f(x, y, t) = log((abs(work_weight) * exp(x) ** work_exp + abs(home_weight) * exp(y) ** home_exp + abs(mixed_use_wt) * (exp(x) ** work_mu_exp * exp(y) ** home_mu_exp)) * (abs(blocks_weight) * exp(t) ** blocks_exp)) + intercept

fit f(x,y,t) "daily-simple" using (log($2 + epsilon)):(log($58 + epsilon)):(log($60 + epsilon)):(log($1 + epsilon)):(1) via work_weight, home_weight, mixed_use_wt, work_exp, home_exp, work_mu_exp, home_mu_exp, intercept, blocks_weight, blocks_exp

plot "daily-simple" using (exp(log((abs(work_weight) * $2 ** work_exp + abs(home_weight) * $58 ** home_exp + abs(mixed_use_wt) * ($2 ** work_mu_exp * $58 ** home_mu_exp)) * abs(blocks_weight) * $60 ** blocks_exp) + intercept)):(($1)) with points ps .3, x
