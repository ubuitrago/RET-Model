function value = PVpower(il,io,m,T,V)
%Determines the current output of a pv cell (in whatever units il and io
%are given in). Inputs are light current (il, A/area), saturation current
%(same units of il), m (which is unitless and between 1 and 2), temperature
%(T, Kelvin), and the voltage of the panel (V, Volts).
 e = 1.602E-19;
 k= 1.38E-23;
 
I = il - io*(exp(e*V/(m*k*T))-1);

value = I*v;