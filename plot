set terminal postscript

epsilon = 1e-3

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

set dummy area, work, home, retail, accomm, school, teach, major, blocks

f(area, work, home, retail, accomm, school, teach, major, blocks) = \
	intercept * \
	( \
		( \
			work_weight * (work / area) ** work_exp + \
			(home / area) ** home_exp + \
			retail_weight * (retail / area) ** retail_exp + \
			accomm_weight * (accomm / area) ** accomm_exp + \
			school_weight * (school / 200) ** school_exp + \
			0 \
		) * \
		(blocks / area) ** blocks_exp \
	) ** scale

work_weight     = 0.197892
work_exp        = 0.490142
home_exp        = 0.69142
retail_weight   = 52.1377
retail_exp      = 1.45549
accomm_weight   = 6.31868
accomm_exp      = 0.957899
school_weight   = 1.82011
school_exp      = 0.871245
blocks_exp      = 0.0975083
scale           = 2.22845
intercept       = 6.48681e+06

fit log(f(area, work, home, retail, accomm, school, teach, major, blocks)) "daily-simple" using \
		($56): \
		($2 ): \
		($58): \
		($15): \
		($26): \
		($62): \
		($23): \
		($65): \
		($60): \
		(log($1)) \
	via \
		work_weight, work_exp, \
		home_exp, \
		retail_weight, retail_exp, \
		accomm_weight, accomm_exp, \
		school_weight, school_exp, \
		blocks_exp, \
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
		($65), \
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
		($65), \
		($60) \
	))):(($1)) with points ps .3, area title ""
