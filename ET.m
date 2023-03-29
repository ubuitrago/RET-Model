function value = ET(N)
%given N as the day of the year (Jan. 1 => N=1), returns the Equation of Time for that day in units of
%minutes. Should not exceed 15 minutes.

t = 360*N/365;
a1=-7.3412;
a2=-9.3795;
a3=-.3179;
a4=-.1739;
b1=.4944;
b2=-3.2568;
b3=-.0774;
b4=-.1283;
value = a1*sind(t) + b1*cosd(t) + a2*sind(2*t) + b2*cosd(2*t) + a3*sind(3*t)+ b3*cosd(3*t) + a4*sind(4*t) + b4*cosd(4*t);
minutes = fix(value);
decimal_seconds = value-minutes;
seconds = round(decimal_seconds*60*-1);
clock_time = minutes+":"+seconds; %done


