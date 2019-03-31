clear all
N = 172;
Ptot = P1_C1(N);
%solar time array
global TOD;
long_std = 90; %standard longitude 
long_loc = 97.753; %local longitude
TOD = [0.00:5/60:24.00]; % Decimal Hours 
ST = [zeros([1 length(TOD)])]; % pre-filled for execution speed 
et = ET(N); % equation of time

for i=1:length(TOD)
    ST(i) = solar_time(TOD(i),long_std,long_loc,et);
end
%solar altitude
lat = 30.260; % Austin latitude 
dec = Declination(N); % angle in degrees 
Alpha = [zeros([1 length(TOD)])]; %solar altitude 
hrAng = [zeros([1 length(TOD)])]; %hour angle 
for i=1:length(TOD)
    hrAng(i) = w(ST(i));
    Alpha(i) = SolarAltitude(lat,dec,hrAng(i));
end

for x=1:size(Alpha,2)
    if Alpha(x)<0
        Alpha(x)=0;%angles shouldnt be negative
    end
end
beta=90-Alpha;
plot(ST,beta);
xlim([0 24]);
ylim([0 100]);
xlabel('Time of day (Decimal hours)')
title('Tilt angle vs time of day')
ylabel('Angle (Degrees)')