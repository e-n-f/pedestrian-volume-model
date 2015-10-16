set terminal postscript

epsilon = 1e-3

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

set dummy area, work, home, retail, accomm, school, teach, split, blocks

f(area, work, home, retail, accomm, school, teach, split, blocks) = \
	abs(intercept) * \
	(blocks / area) ** abs(blocks_exp) * \
	( \
		( \
			work_weight * (work / area) ** abs(work_exp) + \
			(home / area) ** abs(home_exp) + \
			retail_weight * (retail / area) ** abs(retail_exp) + \
			accomm_weight * (accomm / area) ** abs(accomm_exp) + \
			school_weight * (school / 200) ** abs(school_exp) + \
			teach_weight * (teach / area) ** abs(teach_exp) + \
			0 \
		) \
	) ** abs(scale)

#	log(abs(2 - split) + epsilon) ** abs(split_exp) * \

work_weight     = 0.184681
work_exp        = 0.466989
home_exp        = 0.673936
retail_weight   = 28.3033
retail_exp      = 1.31188
accomm_weight   = 6.14282
accomm_exp      = 0.93917
school_weight   = 1.79566
school_exp      = 0.855255
teach_weight    = 0.421983
teach_exp       = 0.784359
blocks_exp      = 0.19115
scale           = 2.28767
intercept       = 4.76531e+06

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
		teach_weight, teach_exp, \
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

plot "daily-simple" using 67:1 with points ps .3, area title ""
