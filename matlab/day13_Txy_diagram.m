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
plot(x_ethanol,T_bubble,'b-','LineWidth',2)
hold on
% Plot bubble point curve
plot(y_ethanol,T_dew,'r--','LineWidth',2)

legend('Bubble Point Curve','Dew Point Curve','Location','best')
xlabel('Ethanol Mole Fraction')
ylabel('Temperature (°C)')
title('T-x-y Diagram for Ethanol-Water at 760 mmHg')

grid on
box on