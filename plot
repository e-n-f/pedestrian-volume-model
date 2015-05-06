set terminal postscript
set xrange [5:150000]
set yrange [5:150000]
set logscale xy

epsilon = 1e-10

f(x, y, z) = log((abs(m) * exp(x) ** w + abs(n) * exp(y) ** h + abs(o) * (exp(x) ** ww * exp(y) ** hh)) * (abs(i) * exp(z) ** ii)) + b
fit f(x,y,t) "daily-simple" using (log($3 + epsilon)):(log($4 + epsilon)):(log($5 + epsilon)):(log($2 + epsilon)):(1) via m, n, o, w, h, ww, hh, b, i, ii
plot "daily-simple" using (exp(log((abs(m) * $3 ** w + abs(n) * $4 ** h + abs(o) * ($3 ** ww * $4 ** hh)) * abs(i) * $5 ** ii) + b)):(($2)), x
