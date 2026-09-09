clc
clear
close all

T = linspace(1,100,200);

% Water

A = 8.07131;
B = 1730.63;
C = 233.426;

P = antoinePressure(T,A,B,C);

% Ethanol
A1 = 7.68117;
B1 = 1332.04;
C1 = 199.200;

P_ethanol = antoinePressure(T,A1,B1,C1);

% Benzene
A2 = 6.90565;
B2 = 1211.033;
C2 = 220.790;

P_benzene = antoinePressure(T,A2,B2,C2);

plot(T,P)
hold on
plot(T,P_ethanol)
hold on
plot(T,P_benzene)
hold on
legend('Water','Ethanol','Benzene')

xlabel('Temperature (°C)')
ylabel('Vapor Pressure (mmHg)')
title('Water Vapor Pressure')

grid on