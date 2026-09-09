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

% Vapor Composition
y_ethanol = 0:0.05:1;

% Store dew point temperatures
T_dew = zeros(size(y_ethanol));

% Temperature Guess
T_guess = 85;

% Loop
for i = 1:length(y_ethanol)

    % Current Vapor Composition
    ye = y_ethanol(i);
    yw = 1 - ye;

    % Dew Point Equation
    f = @(T) (ye * 760 / antoinePressure(T,Ae,Be,Ce)) + (yw * 760 / antoinePressure(T,Aw,Bw,Cw)) - 1;

    % Solve for bubble point temperature
    T_dew(i) = fsolve(f,T_guess);

    % Use this solution as the next initial guess
    T_guess = T_dew(i);

end

% Plot bubble point curve
plot(y_ethanol,T_dew,'LineWidth',2)

xlabel('Vapor Ethanol Mole Fraction, x')
ylabel('Dew Point Temperature (°C)')
title('Dew Point Curve for Ethanol-Water Mixture')

grid on