%input time and day
close all
day=60
All_T_max=[61.5 65.2 72.2 79.8 86.5 92.1 95.6 97 90.5 81.8 71.4 62.7];    %T max for every month
All_T_min=[41.5 44.8 51.3 58.6 66.7 72.3 74.4 74.6 69.4 60.6 50.6 42.3];  %T min for every month
month=findMonth(day); %find which month it is

T_max=All_T_max(month); %t max for current month
T_min=All_T_min(month);%t min for current month

time=linspace(0,24,1000); %x axis
amplitude =(T_max-T_min)/2; %amplitude for sine curve
sineCurve=amplitude*sin(time*(2*3.1415/24)-2.40)+T_min+amplitude;

plot(time,sineCurve);