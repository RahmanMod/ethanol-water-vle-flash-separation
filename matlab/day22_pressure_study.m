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

%% Fixed Conditions
T = 90;       % degC
F = 100;      % kmol/hr

z_ethanol = 0.40;
z_water = 1 - z_ethanol;

%% Pressure Range
P_range = 400:40:1200;

%% Pressure Check
if any(P_range <= 0)
    error("All pressures must be above 0 mmHg")
end

if any(P_range < 50 | P_range > 5000)
    warning('One or more pressures are outside the typical range used in this project. Check model assumptions.')
end

%% Store Values
beta_values = zeros(size(P_range));
liquid_flow = zeros(size(P_range));
vapor_flow = zeros(size(P_range));
K_eth_values = zeros(size(P_range));
K_water_values = zeros(size(P_range));

%% Loop
for i = 1:length(P_range)

    P = P_range(i);

    %% Saturation Pressures
    P_ethanol_sat = antoinePressure(T,Ae,Be,Ce);
    P_water_sat = antoinePressure(T,Aw,Bw,Cw);

    %% K-Values
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
    %% Phase Cases
    if f0 > 0 && f1 < 0

        % Two-phase region
        beta_guess = 0.50;
        beta_val = fsolve(f, beta_guess);

        V = beta_val * F;
        L = (1 - beta_val) * F;

    elseif f0 <= 0 && f1 <= 0

        % All liquid
        beta_val = 0;
        V = 0;
        L = F;

    elseif f0 >= 0 && f1 >= 0

        % All vapor
        beta_val = 1;
        V = F;
        L = 0;
    end
beta_values(i) = beta_val;
liquid_flow(i) = L;
vapor_flow(i) = V;
K_eth_values(i) = K_ethanol;
K_water_values(i) = K_water;
end

if P <= 0
    error("Absolute pressure must be above  0")
end

if P < 50 || P > 5000
    warning('Pressure is outside the typical range used in this project. Check model assumptions.')
end

%% Graph 1
figure

plot(P_range,beta_values,'-o','LineWidth',2)

xlabel('Pressure (mmHg)')
ylabel('Vapor Fraction (\beta)')
title('Effect of Pressure on Vapor Fraction')

ylim([0 1])
grid on
box on

%% Graph 2
figure

plot(P_range,vapor_flow,'-o','LineWidth',2)
hold on
plot(P_range,liquid_flow,'--o','LineWidth',2)

xlabel('Pressure (mmHg)')
ylabel('Flow Rate (kmol/hr)')
title('Effect of Pressure on Outlet Flow Rates')

legend('Vapor Flow','Liquid Flow','Location','best')

grid on
box on

%% Print Results Table
fprintf('\n');
fprintf('Pressure    K_ethanol    K_water      Beta      Vapor Flow    Liquid Flow\n');
fprintf('----------------------------------------------------------------------------\n');

for i = 1:length(P_range)

    fprintf('%5.0f mmHg      %8.4f     %8.4f    %7.4f     %8.2f      %8.2f\n', ...
        P_range(i), ...
        K_eth_values(i), ...
        K_water_values(i), ...
        beta_values(i), ...
        vapor_flow(i), ...
        liquid_flow(i));

end

%% This is an addition after flashSeperator.m
% flashSeperator.m is a script that includes a function that makes flash
% calculations much easier. In this instance, I would write the 
% following:
%for i = 1:length(P_range)
%   results = flashSeparator(T,P_range(i),F,z_ethanol);
%   beta_values(i) = results.beta;
%   liquid_flow(i) = results.L;
%   vapor_flow(i) = results.V;
%end