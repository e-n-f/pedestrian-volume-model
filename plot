set terminal postscript

epsilon = 1e-3

set xlabel "Predicted daily pedestrian volume"
set ylabel "Measured daily pedestrian volume"

set dummy area, work, home, retail, accomm, school, teach, major, blocks

f(area, work, home, retail, accomm, school, teach, major, blocks) = \
	( \
		log( \
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
			) ** scale \
		) \
	)

work_weight     = 0.23769
work_exp        = 0.63832
home_exp        = 0.735989
retail_weight   = 5.95748
retail_exp      = 1.08711
accomm_weight   = 0.979417
accomm_exp      = 0.689884
school_weight   = 0.636911
school_exp      = 0.714566
teach_weight    = 0.0130839
teach_exp       = 0.0868445
blocks_exp      = 0.100841
scale           = 2.56183
intercept       = 3.24574e+07

fit f(area, work, home, retail, accomm, school, teach, major, blocks) "daily-simple" using \
		($56): \
		($2 ): \
		($58): \
		($15): \
		($26): \
		($62): \
		($23): \
		($65): \
		($60): \
		(log($1 + epsilon)) \
	via \
		work_weight, work_exp, \
		home_exp, \
		retail_weight, retail_exp, \
		accomm_weight, accomm_exp, \
		school_weight, school_exp, \
		blocks_exp, \
		scale, \
		intercept

stats "daily-simple" using (f( \
		($56), \
		($2 ), \
		($58), \
		($15), \
		($26), \
		($62), \
		($23), \
		($65), \
		($60) \
	)):(log($1 + epsilon))

set logscale xy
set xrange [1:500000]
set yrange [1:500000]
plot "daily-simple" using (exp(f( \
		($56), \
		($2 ), \
		($58), \
		($15), \
		($26), \
		($62), \
		($23), \
		($65), \
		($60) \
	))):(($1 + epsilon)) with points ps .3, area title ""
