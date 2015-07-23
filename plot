set terminal postscript

epsilon = 1e-3

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

set dummy area, work, home, retail, accomm, school, teach, major, minor

f(area, work, home, retail, accomm, school, teach, major, minor) = \
	log(abs( \
		(work_weight) * (exp(work) / exp(area)) ** work_exp + \
		(exp(home) / exp(area)) ** home_exp + \
		(retail_weight) * (exp(retail) / exp(area)) ** retail_exp + \
		(accomm_weight) * (exp(accomm) / exp(area)) ** accomm_exp + \
		(school_weight) * (exp(school) / 200) ** school_exp + \
		(teach_weight) * (exp(teach) / exp(area)) ** teach_exp + \
	0)) * scale + \
	intercept

work_weight     = 0.24257
work_exp        = 0.60256
home_exp        = 0.694629
retail_weight   = 5.89859
retail_exp      = 1.09033
accomm_weight   = 1.06178
accomm_exp      = 0.671372
school_weight   = 0.499471
school_exp      = 0.655078
teach_weight    = 0.0156911
teach_exp       = 0.0986928
scale           = 2.78669
intercept       = 14.9351

fit f(area, work, home, retail, accomm, school, teach, major, minor) "daily-simple" using \
		(log($56 + epsilon)): \
		(log($2 + epsilon)): \
		(log($58 + epsilon)): \
		(log($15 + epsilon)): \
		(log($26 + epsilon)): \
		(log($62 + epsilon)): \
		(log($23 + epsilon)): \
		(log($65 + epsilon)): \
		(log($66 + epsilon)): \
		(log($1 + epsilon)) \
	via \
		work_weight, work_exp, \
		home_exp, \
		retail_weight, retail_exp, \
		accomm_weight, accomm_exp, \
		school_weight, school_exp, \
		teach_weight, teach_exp, \
		scale, \
		intercept

stats "daily-simple" using (f( \
		log($56 + epsilon), \
		log($2 + epsilon), \
		log($58 + epsilon), \
		log($15 + epsilon), \
		log($26 + epsilon), \
		log($62 + epsilon), \
		log($23 + epsilon), \
		log($65 + epsilon), \
		log($66 + epsilon) \
	)):(log($1 + epsilon))
set logscale xy

set logscale xy
set xrange [1:500000]
set yrange [1:500000]
plot "daily-simple" using (exp(f( \
		log($56 + epsilon), \
		log($2 + epsilon), \
		log($58 + epsilon), \
		log($15 + epsilon), \
		log($26 + epsilon), \
		log($62 + epsilon), \
		log($23 + epsilon), \
		log($65 + epsilon), \
		log($66 + epsilon) \
	))):(($1 + epsilon)) with points ps .3, area title ""
