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

% Temperature
T = 78;

% Vapor Pressures
P_ethanol = antoinePressure(T,Ae,Be,Ce);
P_water = antoinePressure(T,Aw,Bw,Cw);

% Vector of liquid compositions:
x_ethanol = 0:0.05:1;

% Calculate vapor composition for every point
for i = 1:length(x_ethanol)

    xe = x_ethanol(i);
    xw = 1 - xe;

    P_e_partial = xe * P_ethanol;
    P_w_partial = xw * P_water;

    P_total = P_e_partial + P_w_partial;

    ye = P_e_partial / P_total;

    y_ethanol(i) = ye;

end

plot(x_ethanol,y_ethanol,'LineWidth',2)

hold on
