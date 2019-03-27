function value = PVcurrent(V,il,io,m,T)
% determines current given Voltage (V), Light Current (Amps/area), Saturation Current (Amps/area), m (unitless),
% and ambient temperature (K).
 e = 1.602E-19;
 k= 1.38E-23;
 
value = il - io*(exp(e*V/(m*k*T))-1);