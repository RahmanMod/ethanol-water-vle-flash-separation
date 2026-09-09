clc
clear
close all

% Water Antoine Constants
Aw = 8.07131;
Bw = 1730.63;
Cw = 233.426;

% Ethanol Constants
Ae = 7.68117;
Be = 1332.04;
Ce = 199.200;

% Liquid ethanol compositions
x_ethanol = 0:0.05:1;

% Store bubble point temperatures
T_bubble = zeros(size(x_ethanol));

% Initial guess for fsolve
T_guess = 85;

% Loop through every liquid composition
for i = 1:length(x_ethanol)

    % Current liquid composition
    xe = x_ethanol(i);
    xw = 1 - xe;

    % Bubble point equation
    f = @(T) xe * antoinePressure(T,Ae,Be,Ce) + xw * antoinePressure(T,Aw,Bw,Cw) - 760;

    % Solve for bubble point temperature
    T_bubble(i) = fsolve(f,T_guess);

    % Use this solution as the next initial guess
    T_guess = T_bubble(i);

end

% Plot bubble point curve
plot(x_ethanol,T_bubble,'LineWidth',2)

xlabel('Liquid Ethanol Mole Fraction, x')
ylabel('Bubble Point Temperature (°C)')
title('Bubble Point Curve for Ethanol-Water Mixture')

grid on