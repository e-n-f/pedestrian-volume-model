set terminal postscript
set xrange [5:150000]
set yrange [5:150000]
set logscale xy

work_weight     = 0.121621
home_weight     = 0.022665
mixed_use_wt    = -0.669651
work_exp        = 1.25175
home_exp        = 0.879561
work_mu_exp     = 0.364179
home_mu_exp     = 0.88164
intercept       = -2.67202
split_weight    = 0

epsilon = 1e-10

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

f(x, y, t) = split_weight * (t - 0.75) + log((abs(work_weight) * exp(x) ** work_exp + abs(home_weight) * exp(y) ** home_exp + abs(mixed_use_wt) * (exp(x) ** work_mu_exp * exp(y) ** home_mu_exp))) + intercept

plot "daily-simple" using (exp(f(log($2 + epsilon), log($58 + epsilon), $61))):1 with points ps .3, x

unset logscale xy
stats "daily-simple" using ((f(log($2 + epsilon), log($58 + epsilon), $61))):(log($1))
set logscale xy

# in isolation, exp(-3.43596 + x + 8.62859)
split_weight = -3.43596

fit f(x, y, t) "daily-simple" using (log($2 + epsilon)):(log($58 + epsilon)):($61):(log($1 + epsilon)):(1) via work_weight, home_weight, mixed_use_wt, work_exp, home_exp, work_mu_exp, home_mu_exp, intercept, split_weight

# plot "daily-simple" using (exp(log((abs(work_weight) * $2 ** work_exp + abs(home_weight) * $58 ** home_exp + abs(mixed_use_wt) * ($2 ** work_mu_exp * $58 ** home_mu_exp))) + intercept)):(($1)) with points ps .3, x

unset logscale xy
stats "daily-simple" using ((f(log($2 + epsilon), log($58 + epsilon), $61))):(log($1))
set logscale xy

plot "daily-simple" using (exp(f(log($2 + epsilon), log($58 + epsilon), $61))):1 with points ps .3, x
