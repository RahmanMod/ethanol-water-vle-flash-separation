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

%% Temperature
T = input('Input temperature (°C): ');    % degC

%% Pressure
P = input('Input pressure (mmHg): ');     % mmHg

%% Feed Flow Rate
F = input('Input feed flow rate (kmol/hr): ');   % kmol/hr

%% Feed Composition
z_ethanol = -1;

while z_ethanol < 0 || z_ethanol > 1

    z_ethanol = input('Input ethanol mole fraction (0-1): ');

    if z_ethanol < 0 || z_ethanol > 1
        fprintf('Invalid input. Please try again.\n\n');
    end

end

z_water = 1 - z_ethanol;

%% Saturation Pressures
P_ethanol_sat = antoinePressure(T,Ae,Be,Ce);
P_water_sat = antoinePressure(T,Aw,Bw,Cw);

%% K-values
K_ethanol = P_ethanol_sat / P;
K_water = P_water_sat / P;

%% Rachford-Rice Equation
f = @(beta_val) ...
    (z_ethanol*(K_ethanol-1))/(1 + beta_val*(K_ethanol-1)) + ...
    (z_water*(K_water-1))/(1 + beta_val*(K_water-1));
%% Evaluate Endpoints
f0 = f(0);
f1 = f(1);

%% Determine Phase
if f0 > 0 && f1 < 0

    % Two-phase flash
    beta_guess = 0.50;
    beta_val = fsolve(f, beta_guess);

    V = beta_val * F;
    L = (1 - beta_val) * F;

    x_ethanol = z_ethanol / (1 + beta_val * (K_ethanol - 1));
    x_water   = z_water   / (1 + beta_val * (K_water - 1));

    y_ethanol = K_ethanol * x_ethanol;
    y_water   = K_water * x_water;

    x_total = x_water + x_ethanol;
    y_total = y_water + y_ethanol;

    fprintf('Flash occurs.\n');
    fprintf('Vapor Fraction (beta) : %.4f\n', beta_val);

elseif f0 <= 0 && f1 <= 0

    % All liquid
    beta_val = 0;
    V = 0;
    L = F;

    fprintf('No two-phase flash occurs.\n');
    fprintf('The feed remains entirely liquid.\n');

elseif f0 >= 0 && f1 >= 0

    % All vapor
    beta_val = 1;
    V = F;
    L = 0;

    fprintf('No two-phase flash occurs.\n');
    fprintf('The feed is entirely vapor.\n');

end

total_flow = L + V;

%% Print Results
fprintf('======================================== \n');
fprintf('      FLASH SEPARATOR SIMULATOR \n');
fprintf('======================================== \n');
fprintf('\n');
fprintf('Operating Conditions \n');
fprintf('-------------------- \n');
fprintf('Temperature : %.1f degC \n',T);
fprintf('Vapor Fraction (beta) : %.4f\n',beta_val);
fprintf('Liquid Flow Rate : %.3f kmol/hr \n',L);
fprintf('Vapor Flow Rate : %.3f kmol/hr \n',V);
fprintf('CHECK: Total Flow : %.3f kmol/hr\n', total_flow);

if f0 > 0 && f1 < 0
    fprintf('Ethanol Liquid : %.3f \n',x_ethanol);
    fprintf('Ethanol Vapor : %.3f \n',y_ethanol);
    fprintf('Water Liquid : %.3f \n',x_water);
    fprintf('Water Vapor : %.3f \n',y_water);

    fprintf('CHECK: liquid total : %.3f \n',x_total);
    fprintf('CHECK: vapor total : %.3f \n',y_total);
end