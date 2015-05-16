set terminal postscript

epsilon = 1e-10

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

set dummy x1, x2, x3, x4, x5, x6, x7

f(x1, x2, x3, x4, x5, x6, x7) = \
	log( \
		abs(work_weight) * exp(x1) ** work_exp + \
		abs(home_weight) * exp(x2) ** home_exp + \
		abs(retail_weight) * exp(x3) ** retail_exp + \
		abs(hosp_weight) * exp(x4) ** hosp_exp + \
		abs(svc_weight) * exp(x5) ** svc_exp + \
		abs(school_weight) * exp(x6) ** school_exp + \
		abs(mixed_use_wt) * (exp(x1) ** work_mu_exp * exp(x2) ** home_mu_exp) + \
	0) + \
	split_weight * (x7 - 0.75) + \
	intercept

fit f(x1, x2, x3, x4, x5, x6, x7) "daily-simple" using (log($2 + epsilon)):(log($58 + epsilon)):(log($15 + epsilon)):(log($26 + epsilon)):(log($27 + epsilon)):(log($62 + epsilon)):($61):(log($1 + epsilon)):(1) via \
	work_weight, work_exp, \
	home_weight, home_exp, \
	retail_weight, retail_exp, \
	hosp_weight, hosp_exp, \
	svc_weight, svc_exp, \
	school_weight, school_exp, \
	mixed_use_wt, work_mu_exp, home_mu_exp, \
	split_weight, \
	intercept

stats "daily-simple" using (f(log($2 + epsilon),log($58 + epsilon),log($15 + epsilon),log($26 + epsilon),log($27 + epsilon),log($62 + epsilon),$61)):(log($1 + epsilon))
set logscale xy

set logscale xy
set xrange [5:500000]
set yrange [5:500000]
plot "daily-simple" using (exp(f(log($2 + epsilon),log($58 + epsilon),log($15 + epsilon),log($26 + epsilon),log($27 + epsilon),log($62 + epsilon),$61))):(($1 + epsilon)) with points ps .3, x1
