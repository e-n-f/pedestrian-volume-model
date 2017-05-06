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

work_weight     = 0.086042
work_exp        = 0.37525
home_exp        = 0.744601
retail_weight   = 47.0099
retail_exp      = 1.48033
accomm_weight   = 3.95404
accomm_exp      = 0.8853
school_weight   = 0.37729
school_exp      = 0.659622
teach_weight    = 0.303156
teach_exp       = 0.698606
stops_weight    = 25.5382
stops_exp       = 0.883672
blocks_exp      = 0.194644
scale           = 2.0684
intercept       = 3.63692e+06

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
