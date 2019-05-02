%input time and day
function value = T_infinity(clockTime,day)

All_T_max=[61.5 65.2 72.2 79.8 86.5 92.1 95.6 97 90.5 81.8 71.4 62.7];    %T max for every month
All_T_min=[41.5 44.8 51.3 58.6 66.7 72.3 74.4 74.6 69.4 60.6 50.6 42.3];  %T min for every month
month=findMonth(day); %find which month it is

T_max=All_T_max(month); %t max for current month
T_min=All_T_min(month);%t min for current month

%This section is for graphing
time=linspace(0,24,1000); %x axis
amplitude =(T_max-T_min)/2; %amplitude for sine curve
sineCurve=amplitude*sin(time*(2*3.1415/24)-2.40)+T_min+amplitude;

%This section is for returning correct value
[ d, ix ] = min( abs( time-clockTime )); %finding closest value to clockTime
correctedTime=time(ix);
sineCurveTime=amplitude*sin(correctedTime*(2*3.1415/24)-2.40)+T_min+amplitude;
value=sineCurveTime;
%plot(time,sineCurve);