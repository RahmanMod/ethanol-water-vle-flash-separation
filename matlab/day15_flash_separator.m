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

% Feed composition
z_ethanol = 0.40;
z_water = 0.60;

% Feed flow rate
F = 100;    % kmol/hr

fprintf('Temperature = %.1f\n', T);
fprintf('Pressure = %.1f\n', P);
fprintf('Feed Flow = %.1f kmol/hr \n', F);
fprintf('Feed Ethanol = %.2f \n', z_ethanol);
fprintf('Feed Water = %.2f \n', z_water);