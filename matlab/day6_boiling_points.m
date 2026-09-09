clc
clear
close all

% Water
A = 8.07131;
B = 1730.63;
C = 233.426;

f = @(T) antoinePressure(T,A,B,C) - 760;

T_water = fsolve(f,100)

% Ethanol
A1 = 7.68117;
B1 = 1332.04;
C1 = 199.200;

f1 = @(T) antoinePressure(T,A1,B1,C1) - 760;

T_ethanol = fsolve(f1,80)

%Benzene
A2 = 6.90565;
B2 = 1211.033;
C2 = 220.790;

f2 = @(T) antoinePressure(T,A2,B2,C2) - 760;

T_benzene = fsolve(f2,80)

fprintf('Water boiling point: ~%.2f °C\n', T_water)