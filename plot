set terminal postscript

epsilon = 1e-3

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

set dummy area, work, home, retail, accomm, school, teach, split, blocks

f(area, work, home, retail, accomm, school, teach, split, blocks) = \
	intercept * \
	(blocks / area) ** blocks_exp * \
	log(abs(2 - split) + epsilon) ** split_exp * \
	( \
		( \
			work_weight * (work / area) ** work_exp + \
			(home / area) ** home_exp + \
			retail_weight * (retail / area) ** retail_exp + \
			accomm_weight * (accomm / area) ** accomm_exp + \
			school_weight * (school / 200) ** school_exp + \
			0 \
		) \
	) ** scale

work_weight     = 0.176085
work_exp        = 0.494188
home_exp        = 0.70727
retail_weight   = 69.135
retail_exp      = 1.54169
accomm_weight   = 5.52831
accomm_exp      = 0.949495
school_weight   = 1.71035
school_exp      = 0.876242
blocks_exp      = 0.187143
split_exp       = 0.192465
scale           = 2.18694
intercept       = 7.59384e+06

fit log(f(area, work, home, retail, accomm, school, teach, split, blocks)) "daily-simple" using \
		($56): \
		($2 ): \
		($58): \
		($15): \
		($26): \
		($62): \
		($23): \
		($61): \
		($60): \
		(log($1)) \
	via \
		work_weight, work_exp, \
		home_exp, \
		retail_weight, retail_exp, \
		accomm_weight, accomm_exp, \
		school_weight, school_exp, \
		blocks_exp, \
		split_exp, \
		scale, \
		intercept

stats "daily-simple" using (log(f( \
		($56), \
		($2 ), \
		($58), \
		($15), \
		($26), \
		($62), \
		($23), \
		($61), \
		($60) \
	))):(log($1))

set logscale xy
set xrange [1:500000]
set yrange [1:500000]
plot "daily-simple" using ((f( \
		($56), \
		($2 ), \
		($58), \
		($15), \
		($26), \
		($62), \
		($23), \
		($61), \
		($60) \
	))):(($1)) with points ps .3, area title ""
