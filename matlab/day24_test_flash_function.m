clc
clear
close all

T = 90;
P = 760;
F = 100;
z_ethanol = 0.40;

results = flashSeparator(T,P,F,z_ethanol);

fprintf('Phase: %s\n',results.phase)
fprintf('Vapor Fraction: %.4f\n',results.beta)
fprintf('Liquid Flow: %.3f kmol/hr\n',results.L)
fprintf('Vapor Flow: %.3f kmol/hr\n',results.V)