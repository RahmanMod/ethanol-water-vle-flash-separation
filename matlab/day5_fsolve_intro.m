clc
clear
close all

A = 8.07131;
B = 1730.63;
C = 233.426;

f = @(T) 10^(A - (B/(T + C))) - 760;

T_solution = fsolve(f,100)