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

work_weight     = 0.0608031
work_exp        = 0.41121
home_exp        = 0.830486
retail_weight   = 42.5217
retail_exp      = 1.5001
accomm_weight   = 3.03707
accomm_exp      = 0.905434
school_weight   = 0.259021
school_exp      = 0.685986
teach_weight    = 0.324294
teach_exp       = 0.731631
stops_weight    = 54.9309
stops_exp       = 0.889973
blocks_exp      = 0.130487
scale           = 1.79921
intercept       = 1.47431e+06

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
