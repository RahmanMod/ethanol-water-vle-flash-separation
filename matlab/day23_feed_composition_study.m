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
T = 90;      % °C
P = 760;     % mmHg
F = 100;     % kmol/hr

%% Ethanol Range
z_ethanol_range = 0:0.05:1;

%% Store Values
beta_values = zeros(size(z_ethanol_range));
liquid_flow = zeros(size(z_ethanol_range));
vapor_flow = zeros(size(z_ethanol_range));
K_eth_values = zeros(size(z_ethanol_range));
K_water_values = zeros(size(z_ethanol_range));

%% Loop
for i = 1:length(z_ethanol_range)

    z_ethanol = z_ethanol_range(i);
    z_water = 1 - z_ethanol;

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

if z_ethanol < 0 || z_ethanol > 1
    error('Ethanol mole fraction must be between 0 and 1.')
end

%% Graph 1
figure

plot(z_ethanol_range,beta_values,'-o','LineWidth',2)

xlabel('Feed Ethanol Mole Fraction')
ylabel('Vapor Fraction (\beta)')
title('Effect of Feed Ethanol Mole Fraction on Vapor Fraction')

ylim([0 1])
grid on
box on

%% Graph 2
figure

plot(z_ethanol_range,vapor_flow,'-o','LineWidth',2)
hold on
plot(z_ethanol_range,liquid_flow,'--o','LineWidth',2)

xlabel('Feed Ethanol Mole Fraction')
ylabel('Flow Rate (kmol/hr)')
title('Effect of Feed Ethanol Mole Fraction on Outlet Flow Rates')

legend('Vapor Flow','Liquid Flow','Location','best')

grid on
box on

%% This is an addition after flashSeperator.m
% flashSeperator.m is a script that includes a function that makes flash
% calculations much easier. In this instance, if I were to write the 
% following:
% for i = 1:length(z_ethanol_range)
%   results = flashSeparator(T,P,F,z_ethanol_range(i));
%   beta_values(i) = results.beta;
%   liquid_flow(i) = results.L;
%   vapor_flow(i) = results.V;
% end