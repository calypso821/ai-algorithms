p = 4
n = 5
m1 = matrix(NaN, n, p, FALSE)
m1[n, 1] = 5
m1
for (x in m1[, 1]) {
  if(!is.nan(x))
    print(x)
}
  