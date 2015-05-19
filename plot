set terminal postscript

epsilon = 1e-3

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

set dummy work, home, retail, accomm, school, teach

f(work, home, retail, accomm, school, teach) = \
	log( \
		abs(work_weight) * exp(work) ** work_exp + \
		exp(home) ** home_exp + \
		abs(retail_weight) * exp(retail) ** retail_exp + \
		abs(accomm_weight) * exp(accomm) ** accomm_exp + \
		abs(school_weight) * exp(school) ** school_exp + \
		abs(teach_weight) * exp(teach) ** teach_exp + \
	0) + \
	intercept

fit f(work, home, retail, accomm, school, teach) "daily-simple" using (log($2 + epsilon)):(log($58 + epsilon)):(log($15 + epsilon)):(log($26 + epsilon)):(log($62 + epsilon)):(log($23 + epsilon)):(log($1 + epsilon)) via \
	work_weight, work_exp, \
	home_exp, \
	retail_weight, retail_exp, \
	accomm_weight, accomm_exp, \
	school_weight, school_exp, \
	teach_weight, teach_exp, \
	intercept

stats "daily-simple" using (f(log($2 + epsilon),log($58 + epsilon),log($15 + epsilon),log($26 + epsilon),log($62 + epsilon),log($23 + epsilon))):(log($1 + epsilon))
set logscale xy

set logscale xy
set xrange [1:500000]
set yrange [1:500000]
plot "daily-simple" using (exp(f(log($2 + epsilon),log($58 + epsilon),log($15 + epsilon),log($26 + epsilon),log($62 + epsilon),log($23 + epsilon)))):(($1 + epsilon)) with points ps .3, work title ""
