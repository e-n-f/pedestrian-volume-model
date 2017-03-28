set terminal postscript

epsilon = 1e-3

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

set dummy area, work, home, retail, accomm, school, teach, split, blocks, stops

f(area, work, home, retail, accomm, school, teach, split, blocks, stops) = \
	abs(intercept) * \
	(blocks / area) ** abs(blocks_exp) * \
	(1 + abs(stops_weight) * stops ** abs(stops_exp)) * \
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

work_weight     = 0.0470586
work_exp        = 0.358766
home_exp        = 0.833155
retail_weight   = 45.3638
retail_exp      = 1.51917
accomm_weight   = 3.43899
accomm_exp      = 0.916848
school_weight   = 0.252658
school_exp      = 0.686353
teach_weight    = 0.318222
teach_exp       = 0.711528
stops_weight    = 41.6992
stops_exp       = 0.787956
blocks_exp      = 0.147019
scale           = 1.80457
intercept       = 1.55157e+06

fit log(f(area, work, home, retail, accomm, school, teach, split, blocks, stops)) "daily-simple" using \
		($56): \
		($2 ): \
		($58): \
		($15): \
		($26): \
		($62): \
		($23): \
		($61): \
		($60): \
		($68): \
		(log($1)) \
	via \
		work_weight, work_exp, \
		home_exp, \
		retail_weight, retail_exp, \
		accomm_weight, accomm_exp, \
		school_weight, school_exp, \
		teach_weight, teach_exp, \
		stops_weight, stops_exp, \
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
		($60), \
		($68) \
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
		($60), \
		($68) \
	))):(($1)) with points ps .3, area title ""

plot "daily-simple" using 67:1 with points ps .3, area title ""
