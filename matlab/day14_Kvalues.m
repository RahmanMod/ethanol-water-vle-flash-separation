clc
clear
close all

% Water Antoine Constants
Aw = 8.07131;
Bw = 1730.63;
Cw = 233.426;

% Ethanol Antoine Constants
Ae = 7.68117;
Be = 1332.04;
Ce = 199.200;

% Fixed Temperature
T = 85;

% Saturation Pressures
P_ethanol_sat = antoinePressure(T,Ae,Be,Ce);
P_water_sat = antoinePressure(T,Aw,Bw,Cw);

% Atmospheric Pressure
P = 760; % mmHg

% K-Values
K_ethanol = P_ethanol_sat / P; % If K>1, ethanol prefers vapor phase
K_water = P_water_sat / P; % If K<1, water prefers liquid phase

% Calculate Liquid Composition
x_ethanol = 0.40;
x_water = 0.60;

% Calculate Vapor Composition
y_ethanol = K_ethanol * x_ethanol;
y_water = K_water * x_water;

% Print
fprintf('K ethanol = %.4f\n', K_ethanol)
fprintf('K water = %.4f\n', K_water)

fprintf('Liquid ethanol = %.4f\n', x_ethanol)
fprintf('Vapor ethanol = %.4f\n', y_ethanol)

fprintf('Liquid water = %.4f\n', x_water)
fprintf('Vapor water = %.4f\n', y_water)

fprintf('Sum of vapor fractions = %.4f\n', y_ethanol + y_water)

% Check
if abs(y_ethanol + y_water - 1) < 1e-6
    fprintf('The mixture is at equilibrium.\n')
    fprintf('-----------------------------\n')
else
    fprintf('The mixture is NOT at equilibrium.\n')
    fprintf('-----------------------------\n')
end