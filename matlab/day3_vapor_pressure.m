clc
clear
close all

%Temperature Vector
T = linspace(1,100,200);

%Constants
A = 8.07131;
B = 1730.63;
C = 233.426;

%Pressure Equation
P = 10.^(A - (B ./ (T + C)));

%Plot
plot(T,P)

xlabel('Temperature (°C)')
ylabel('Vapor Pressure (mmHg)')
title('Water Vapor Pressure vs Temperature')

grid on