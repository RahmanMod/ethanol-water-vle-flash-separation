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

% Temperature (°C)
T = 78;

% Vapor Pressures at 78°C
P_ethanol = antoinePressure(T,Ae,Be,Ce);
P_water = antoinePressure(T,Aw,Bw,Cw);

% Vector of liquid ethanol compositions
x_ethanol = 0:0.05:1;

% Preallocate vapor composition vector
y_ethanol = zeros(size(x_ethanol));

% Calculate vapor composition for each liquid composition
for i = 1:length(x_ethanol)

    xe = x_ethanol(i);
    xw = 1 - xe;

    % Partial pressures
    P_e_partial = xe * P_ethanol;
    P_w_partial = xw * P_water;

    % Total pressure
    P_total = P_e_partial + P_w_partial;

    % Vapor composition
    ye = P_e_partial / P_total;

    % Store result
    y_ethanol(i) = ye;

end

% Plot equilibrium curve
plot(x_ethanol,y_ethanol,'LineWidth',2)

hold on

% Plot y = x diagonal
plot([0 1],[0 1],'--','LineWidth',1.5)

xlabel('Liquid Ethanol Fraction, x')
ylabel('Vapor Ethanol Fraction, y')

title('Ethanol-Water x-y Equilibrium Diagram')

legend('Equilibrium Curve','y = x')

grid on

% Display some values
fprintf('x = 0.20 --> y = %.4f\n', y_ethanol(5))
fprintf('x = 0.50 --> y = %.4f\n', y_ethanol(11))
fprintf('x = 0.80 --> y = %.4f\n', y_ethanol(17))
