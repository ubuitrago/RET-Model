function value = Io(N)
%N =1 for January 1st. Outputs the solar insolation of the upper atmosphere for this day of the
%year in W/m^2

value = 1368*(1+.034*cos(2*pi*(N-3)/365));