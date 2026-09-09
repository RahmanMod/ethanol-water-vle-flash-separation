% This is very similar to day 21 except I edited it so it uses user inputs
% and 
clc
clear
close all

%% Fixed Operating Conditions
P = 760;      % mmHg
F = 100;      % kmol/hr
z_ethanol = 0.40;
z_water = 1 - z_ethanol;

%% Inputs
fprintf("TEMPERATURE STUDY\n");
fprintf("------------------\n");
fprintf("Range:\n");
T_low = input("Input first limit: \n");
T_high = input("Input last limit: \n");
T_incr = input("Input increments: \n");

T_range = T_low:T_incr:T_high;

%% Preallocate Storage Arrays
beta_values = zeros(size(T_range));
liquid_flow = zeros(size(T_range));
vapor_flow = zeros(size(T_range));
K_eth_values = zeros(size(T_range));
K_water_values = zeros(size(T_range));

%% Calculator
for i = 1:length(T_range)

   T = T_range(i);

   results = flashSeparator(T_range(i),P,F,z_ethanol);
   
   beta_values(i) = results.beta;
   liquid_flow(i) = results.L;
   vapor_flow(i) = results.V;
   K_eth_values(i) =  results.K_ethanol;
   K_water_values(i) = results.K_water;
end

if T_low < 0 || T_high > 100
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