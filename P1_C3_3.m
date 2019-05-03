clear all
N = 172;
Ptot = P1_C1(N,46);
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
%%%
io = Io(N);
Tiltrange = -90:1:90;
for j = 1:length(TOD)
    for i = 1:length(Tiltrange)
        incident(i,j) = Incident(Alpha(j), Tiltrange(i), SolarAzimuth(Alpha(j),dec,hrAng(j)), 46);
    end
end

[incidentbest, indexbest] = min(incident,[],1);

    
Tiltbest = indexbest-91;
figure
plot(TOD,Tiltbest)
xlim([0 24]);
ylim([-100 100]);
xlabel('Time of day (Decimal hours)')
title('Optimal Tilt angle vs Time of Day')
ylabel('Angle (Degrees)')
grid on