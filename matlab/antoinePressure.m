function P = antoinePressure(T,A,B,C)

P = 10.^(A - (B ./ (T + C)));

end