function results = flashSeparator(T,P,F,z_ethanol)

% Water Antoine constants
Aw = 8.07131;
Bw = 1730.63;
Cw = 233.426;

% Ethanol Antoine Constants
Ae = 7.68117;
Be = 1332.04;
Ce = 199.200;

z_water = 1 - z_ethanol;

P_ethanol_sat = antoinePressure(T,Ae,Be,Ce);
P_water_sat = antoinePressure(T,Aw,Bw,Cw);

K_ethanol = P_ethanol_sat / P;
K_water = P_water_sat / P;

f = @(beta_val) ...
    (z_ethanol * (K_ethanol - 1)) / ...
    (1 + beta_val * (K_ethanol - 1)) + ...
    (z_water * (K_water - 1)) / ...
    (1 + beta_val * (K_water - 1));

f0 = f(0);
f1 = f(1);

x_ethanol = NaN;
x_water = NaN;
y_ethanol = NaN;
y_water = NaN;

if f0 > 0 && f1 < 0

    % Two-phase flash
    phase = "Two Phase";
    beta_guess = 0.50;
    options = optimoptions('fsolve','Display','off');
    beta_val = fsolve(f,beta_guess,options);

    V = beta_val * F;
    L = (1 - beta_val) * F;
    x_ethanol = z_ethanol / (1 + beta_val * (K_ethanol - 1));
    x_water = z_water / (1 + beta_val * (K_water - 1));

    y_ethanol = K_ethanol * x_ethanol;
    y_water = K_water * x_water;
elseif f0 <= 0 && f1 <= 0

    % All liquid
    phase = "All Liquid";
    beta_val = 0;
    V = 0;
    L = F;
    x_ethanol = z_ethanol;
    x_water = z_water;

elseif f0 >= 0 && f1 >= 0

    % All vapor
    phase = "All Vapor";
    beta_val = 1;
    V = F;
    L = 0;
    y_ethanol = z_ethanol;
    y_water = z_water;

end

results.phase = phase;

results.beta = beta_val;
results.V = V;
results.L = L;

results.x_ethanol = x_ethanol;
results.x_water = x_water;

results.y_ethanol = y_ethanol;
results.y_water = y_water;

results.K_ethanol = K_ethanol;
results.K_water = K_water;

results.P_ethanol_sat = P_ethanol_sat;
results.P_water_sat = P_water_sat;

results.f0 = f0;
results.f1 = f1;

if T <= 0
    error('Temperature must be greater than 0°C.')
end

if P <= 0
    error('Pressure must be greater than zero.')
end

if F < 0
    error('Feed flow rate cannot be negative.')
end

if z_ethanol < 0 || z_ethanol > 1
    error('Ethanol mole fraction must be between 0 and 1.')
end

if T < 1 || T > 100
    warning('Temperature is outside the possible Antoine-equation range.')
end

end