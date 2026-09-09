# MATLAB VLE and Flash Separation Simulator

This project uses MATLAB to model vapor-liquid equilibrium (VLE) and flash separation for an ethanol-water mixture.

I built this project to apply thermodynamics concepts computationally and get more experience using MATLAB for chemical engineering calculations.

## What the Program Does

The simulator can:

- Calculate saturation vapor pressures using Antoine's equation
- Use Raoult's law to model vapor-liquid equilibrium
- Calculate bubble point and dew point temperatures
- Calculate K-values for ethanol and water
- Determine whether the system is liquid, vapor, or two-phase
- Calculate the vapor fraction using the Rachford-Rice equation
- Calculate liquid and vapor flow rates
- Calculate the compositions of the liquid and vapor streams
- Study how temperature, pressure, and feed composition affect the separation

## System Assumptions

The model is based on an ethanol-water binary mixture and assumes:

- Ideal liquid-phase behavior
- Ideal vapor-phase behavior
- Raoult's law
- Antoine's equation for saturation vapor pressure
- Isothermal flash conditions
- No energy balance
- Binary mixture only

## How It Works

The program first calculates the saturation vapor pressures of ethanol and water at the specified temperature. These values are then used to calculate the K-values:

`K_i = P_i^sat / P`

For flash calculations, the Rachford-Rice equation is used to determine the vapor fraction:

`f(beta) = sum[z_i(K_i - 1)/(1 + beta(K_i - 1))] = 0`

If a physical solution exists between beta = 0 and beta = 1, the program calculates the liquid and vapor compositions and flow rates.

## MATLAB Files

### `antoinePressure.m`

Calculates the saturation vapor pressure of a component using the Antoine equation and the appropriate Antoine constants.

### `flashSeparator.m`

Performs the flash separation calculations using the specified temperature, pressure, feed flow rate, and feed composition.

### Main Script

Runs the overall calculations and sensitivity studies for the ethanol-water system.

## Example Result

For a feed of 100 kmol/hr containing 40 mol% ethanol at 90°C and 760 mmHg, the model predicts a two-phase flash.

Approximate results:

- Vapor fraction: 0.232
- Vapor flow rate: 23.24 kmol/hr
- Liquid flow rate: 76.76 kmol/hr
- Vapor ethanol mole fraction: 0.553
- Liquid ethanol mole fraction: 0.354

## Sensitivity Studies

The project also looks at how changing operating conditions affects the flash separation.

### Temperature

Increasing temperature increases the saturation vapor pressures and generally favors the vapor phase.

### Pressure

Increasing pressure decreases the K-values at a fixed temperature and generally favors the liquid phase.

### Feed Composition

Changing the ethanol concentration changes the phase compositions and the amount of material entering the vapor phase.

## Limitations

This is an idealized model and is not intended to exactly represent an industrial flash separator.

Some limitations include:

- Raoult's law assumes ideal liquid behavior.
- Real ethanol-water mixtures can show nonideal behavior.
- Antoine's equation is only valid over its applicable temperature range.
- The current model does not include an energy balance.
- The simulator is limited to a binary mixture.

## Future Improvements

Possible improvements to the project include:

- Adding activity coefficient models for nonideal mixtures
- Adding an energy balance for non-isothermal flash calculations
- Expanding the program to handle multicomponent mixtures
- Comparing the results with experimental or process simulation data
- Adding a graphical user interface

## Author

**Abdulrahman Modhesh**
Chemical Engineering  
Oklahoma State University
