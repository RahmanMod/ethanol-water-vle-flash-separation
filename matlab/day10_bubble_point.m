clc
clear
close all

% Water Constants
Aw = 8.07131;
Bw = 1730.63;
Cw = 233.426;

% Ethanol Constants
Ae = 7.68117;
Be = 1332.04;
Ce = 199.200;

% Vector of liquid compositions:
x_ethanol = 0.5;
x_water = 0.5;

% Bubble Point Function
f = @(T) x_ethanol * antoinePressure(T,Ae,Be,Ce) + x_water * antoinePressure(T,Aw,Bw,Cw) - 760;

% 85 is an educated guess
T_bubble = fsolve(f,85);

% Print Result
fprintf('Bubble Point Temperature = %.2f °C\n', T_bubble)