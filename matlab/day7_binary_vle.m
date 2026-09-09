clc
clear
close all

% Pick a temperature, choosing 78 because ethanol evaporates arond there
T = 78;

% Water constants
A = 8.07131;
B = 1730.63;
C = 233.426;

% Ethanol Constants
A1 = 7.68117;
B1 = 1332.04;
C1 = 199.200;

% Calculate vapor pressures
P_ethanol = antoinePressure(T,A1,B1,C1);
P_water = antoinePressure(T,A,B,C);

% Liquid composition marked by x
x_ethanol = 0.5;
x_water = 0.5;
x_e1 = 0.2;
x_w1 = 0.8;
x_e2 = 0.8;
x_w2 = 0.2;

% Calculate partial pressures
P_ethanol_partial = x_ethanol * P_ethanol;
P_water_partial = x_water * P_water;

P_e1_p = x_e1 * P_ethanol;
P_w1_p = x_w1 * P_water;

P_e2_p = x_e2 * P_ethanol;
P_w2_p = x_w2 * P_water;

% Total pressure
P_total = P_ethanol_partial + P_water_partial;

P_t1 = P_e1_p + P_w1_p;

P_t2 = P_e2_p + P_w2_p;

% Vapor composition marked by y
y_ethanol = P_ethanol_partial / P_total;
y_water = P_water_partial / P_total;

y_e1 = P_e1_p / P_t1;
y_w1 = P_w1_p / P_t1;

y_e2 = P_e2_p / P_t2;
y_w2 = P_w2_p / P_t2;

fprintf('Liquid ethanol fraction: %.4f\n', x_ethanol)
fprintf('Vapor ethanol fraction: %.4f\n', y_ethanol)

fprintf('Liquid water fraction: %.4f\n', x_water)
fprintf('Vapor water fraction: %.4f\n', y_water)

fprintf('Ethanol Vapor + Water Vapor = %.4f\n', y_ethanol + y_water)

fprintf('----\n')

fprintf('Liquid ethanol fraction: %.4f\n', x_e1)
fprintf('Vapor ethanol fraction: %.4f\n', y_e1)

fprintf('Liquid water fraction: %.4f\n', x_w1)
fprintf('Vapor water fraction: %.4f\n', y_w1)

fprintf('Ethanol Vapor + Water Vapor = %.4f\n', y_e1 + y_w1)

fprintf('----\n')


fprintf('Liquid ethanol fraction: %.4f\n', x_e2)
fprintf('Vapor ethanol fraction: %.4f\n', y_e2)

fprintf('Liquid water fraction: %.4f\n', x_w2)
fprintf('Vapor water fraction: %.4f\n', y_w2)

fprintf('Ethanol Vapor + Water Vapor = %.4f\n', y_e2 + y_w2)