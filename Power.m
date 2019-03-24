function value = Power(Icbd,Efficiency,T,length,width,n)

%Efficiency should be given as a decimal. T should be given in Celsius.
%length and width are the dimmensions of the panels should be given in meters. 
% n is the number of panels.

PFull = Icbd*Efficiency; %Power without temperature consideration
dT = abs(T-25); %how far the temperature is from ideal temp of 25c.
Ploss = PFull*.0045*dT; %how much power is lost due to temperature.
P = PFull-Ploss; %Power per m^2
value = P*length*width*n;