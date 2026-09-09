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

%% Fixed Operating Conditions
P = 760;      % mmHg
F = 100;      % kmol/hr

%% Feed Composition
z_ethanol = 0.40;
z_water = 1 - z_ethanol;

%% Temperature Range
T_range = 70:2:100;

%% Preallocate Storage Arrays
beta_values = zeros(size(T_range));
liquid_flow = zeros(size(T_range));
vapor_flow = zeros(size(T_range));
K_eth_values = zeros(size(T_range));
K_water_values = zeros(size(T_range));

%% Temperature Study
for i = 1:length(T_range)

    T = T_range(i);

    %% Saturation Pressures
    P_ethanol_sat = antoinePressure(T,Ae,Be,Ce);
    P_water_sat = antoinePressure(T,Aw,Bw,Cw);

    %% K-values
    K_ethanol = P_ethanol_sat / P;
    K_water = P_water_sat / P;

    %% Rachford-Rice Equation
    f = @(beta_val) ...
        (z_ethanol * (K_ethanol - 1)) / ...
        (1 + beta_val * (K_ethanol - 1)) + ...
        (z_water * (K_water - 1)) / ...
        (1 + beta_val * (K_water - 1));

    %% Evaluate Physical Endpoints
    f0 = f(0);
    f1 = f(1);

    %% Determine Phase Region
    if f0 > 0 && f1 < 0

        % Two-phase flash region
        beta_guess = 0.50;
        beta_val = fsolve(f, beta_guess);

        V = beta_val * F;
        L = (1 - beta_val) * F;

    elseif f0 <= 0 && f1 <= 0

        % All-liquid region
        beta_val = 0;
        V = 0;
        L = F;

    elseif f0 >= 0 && f1 >= 0

        % All-vapor region
        beta_val = 1;
        V = F;
        L = 0;

    else

        % Handles rare boundary cases
        beta_val = NaN;
        V = NaN;
        L = NaN;

    end

    %% Store Results
    beta_values(i) = beta_val;
    liquid_flow(i) = L;
    vapor_flow(i) = V;
    K_eth_values(i) = K_ethanol;
    K_water_values(i) = K_water;

end

if T < 0 || T > 100
    warning('Temperature is outside the recommended range of the Antoine constants. Results may be less accurate.')
end

%% Print Results Table
fprintf('\n');
fprintf('Temperature    K_ethanol    K_water      Beta      Vapor Flow    Liquid Flow\n');
fprintf('----------------------------------------------------------------------------\n');

for i = 1:length(T_range)

    fprintf('%5.0f degC      %8.4f     %8.4f    %7.4f     %8.2f      %8.2f\n', ...
        T_range(i), ...
        K_eth_values(i), ...
        K_water_values(i), ...
        beta_values(i), ...
        vapor_flow(i), ...
        liquid_flow(i));

end

%% Plot Vapor Fraction vs Temperature
figure

plot(T_range,beta_values,'-o','LineWidth',2)

xlabel('Temperature (°C)')
ylabel('Vapor Fraction (\beta)')
title('Effect of Temperature on Vapor Fraction')

ylim([0 1])
grid on
box on

%% Optional Flow Rate Plot
figure

plot(T_range,vapor_flow,'-o','LineWidth',2)
hold on
plot(T_range,liquid_flow,'--o','LineWidth',2)

xlabel('Temperature (°C)')
ylabel('Flow Rate (kmol/hr)')
title('Effect of Temperature on Outlet Flow Rates')

legend('Vapor Flow','Liquid Flow','Location','best')

grid on
box on

% At atmospheric pressure, the ethanol-water feed remained entirely liquid below approximately 90°C. Between 90°C and 94°C, 
% a two-phase flash region was observed, where vapor and liquid coexisted. Above approximately 94°C, the feed became completely 
% vaporized, resulting in a vapor fraction of one.

%% This is an addition after flashSeperator.m
% flashSeperator.m is a script that includes a function that makes flash
% calculations much easier. In this instance, if I were to write the 
% following:
%for i = 1:length(T_range)
%   results = flashSeparator(T_range(i),P,F,z_ethanol);
%   beta_values(i) = results.beta;
%   liquid_flow(i) = results.L;
%   vapor_flow(i) = results.V;
%end