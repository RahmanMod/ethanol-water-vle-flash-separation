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

%% Feed Composition
z_ethanol = 0.40;
z_water = 0.60;

fprintf('Temperature    K_ethanol    K_water      f(0)        f(1)      Flash?\n')
fprintf('--------------------------------------------------------------------------\n')

for T = 70:5:100

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
    else
        flash = "NO";
    end

    %% Print Results
    fprintf('%5.0f°C        %8.4f    %8.4f   %8.4f   %8.4f     %s\n', ...
        T, K_ethanol, K_water, f0, f1, flash)

end

% By the Intermediate Value Theorem, if the function is continuous, it must cross zero somewhere between
% β = 0 and β = 1. That means there is a physically meaningful vapor fraction @ 90 degC.