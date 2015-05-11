set terminal postscript

epsilon = 1e-10

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

f(x, y, t) = \
	split_weight * (t - 0.75) + \
	log( \
		abs(work_weight) * exp(x) ** work_exp + \
		abs(home_weight) * exp(y) ** home_exp + \
		abs(mixed_use_wt) * (exp(x) ** work_mu_exp * exp(y) ** home_mu_exp)) + \
	intercept

fit f(x, y, t) "daily-simple" using (log($2 + epsilon)):(log($58 + epsilon)):($61):(log($1 + epsilon)):(1) via \
	split_weight, \
	work_weight, work_exp, \
	home_weight, home_exp, \
	mixed_use_wt, work_mu_exp, home_mu_exp, \
	intercept

stats "daily-simple" using ((f(log($2 + epsilon), log($58 + epsilon), $61))):(log($1))
set logscale xy

set logscale xy
plot "daily-simple" using (exp(f(log($2 + epsilon), log($58 + epsilon), $61))):1 with points ps .3, x
