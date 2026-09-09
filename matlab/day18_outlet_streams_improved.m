clc
clear
close all

%% Water Antoine Constants
Aw = 8.07131;
Bw = 1730.63;
Cw = 233.426;

%% Ethanol Antoine Constants
Ae = 7.68117;
Be = 1332.04;
Ce = 199.200;

%% Pressure
P = 760;     % mmHg

%% Feed Flow Rate
F = 100;   % kmol/hr

%% Feed Composition
z_ethanol = 0.40;
z_water = 0.60;

%% Temperature
T = 90;

%% Saturation Pressures
P_ethanol_sat = antoinePressure(T,Ae,Be,Ce);
P_water_sat = antoinePressure(T,Aw,Bw,Cw);

%% K-values
K_ethanol = P_ethanol_sat / P;
K_water = P_water_sat / P;

%% Rachford-Rice Equation
f = @(beta) ...
    (z_ethanol*(K_ethanol-1))/(1 + beta*(K_ethanol-1)) + ...
    (z_water*(K_water-1))/(1 + beta*(K_water-1));
%% Evaluate Endpoints
f0 = f(0);
f1 = f(1);

%% Check for Flash
if f0 * f1 < 0
    flash = "YES";
    %% Initial Guess
    beta_guess = 0.50;

    %% Solve for beta
    beta = fsolve(f, beta_guess);

    V = beta * F;
    L = (1 - beta) * F;

    x_ethanol = z_ethanol / (1 + beta * (K_ethanol - 1));
    x_water   = z_water   / (1 + beta * (K_water   - 1));

    y_ethanol = K_ethanol * x_ethanol;
    y_water   = K_water   * x_water;

    x_total = x_water + x_ethanol;
    y_total = y_water + y_ethanol;

    %% Print Results
    fprintf('======================================== \n');
    fprintf('      FLASH SEPARATOR SIMULATOR \n');
    fprintf('======================================== \n');
    fprintf('\n');
    fprintf('Operateing Conditions \n');
    fprintf('-------------------- \n');
    fprintf('Temperature : %.1f degC \n',T);
    fprintf('Vapor Fraction (beta) : %.4f\n',beta)
    fprintf('Ethanol Liquid : %.3f \n',x_ethanol);
    fprintf('Ethanol Vapor : %.3f \n',y_ethanol);
    fprintf('Water Liquid : %.3f \n',x_water);
    fprintf('Water Vapor : %.3f \n',y_water);
    fprintf('Liquid Flow Rate : %.3f kmol/hr \n',L)
    fprintf('Vapor Flow Rate : %.3f kmol/hr \n',V)
    fprintf('CHECK: liquid total : %.3f \n', x_total)
    fprintf('CHECK: vapor total : %.3f \n', y_total)
    fprintf('CHECK: Total Flow : %.3f kmol/hr\n', L + V)
else
    flash = "NO";
    fprintf('No flash occurs under these operating conditions.\n')
end