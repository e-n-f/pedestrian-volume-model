set terminal postscript

epsilon = 1e-10

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

set dummy x1, x2, x3, x4, x5, x6, x7

f(x1, x2, x3, x4, x5, x6, x7) = \
	log( \
		abs(work_weight) * exp(x1) ** work_exp + \
		exp(x2) ** home_exp + \
		abs(retail_weight) * exp(x3) ** retail_exp + \
		abs(accomm_weight) * exp(x4) ** accomm_exp + \
		abs(school_weight) * exp(x5) ** school_exp + \
		abs(teach_weight) * exp(x7) ** teach_exp + \
	0) + \
	intercept

fit f(x1, x2, x3, x4, x5, x6, x7) "daily-simple" using (log($2 + epsilon)):(log($58 + epsilon)):(log($15 + epsilon)):(log($26 + epsilon)):(log($62 + epsilon)):($61):(log($23 + epsilon)):(log($1 + epsilon)):(1) via \
	work_weight, work_exp, \
	home_exp, \
	retail_weight, retail_exp, \
	accomm_weight, accomm_exp, \
	school_weight, school_exp, \
	teach_weight, teach_exp, \
	intercept

stats "daily-simple" using (f(log($2 + epsilon),log($58 + epsilon),log($15 + epsilon),log($26 + epsilon),log($62 + epsilon),$61,log($23 + epsilon))):(log($1 + epsilon))
set logscale xy

set logscale xy
set xrange [1:500000]
set yrange [1:500000]
plot "daily-simple" using (exp(f(log($2 + epsilon),log($58 + epsilon),log($15 + epsilon),log($26 + epsilon),log($62 + epsilon),$61, log($23 + epsilon)))):(($1 + epsilon)) with points ps .3, x1
