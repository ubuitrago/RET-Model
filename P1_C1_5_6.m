%%%%%%%%%%%%%%%%
% Case 1 graph 5
% Angle of Incidence 
% at noon vs. Day of the Year starting Jan 1
%%%%%%%%%%%%%%%%
global TOD;
A = 0.149; % alt. of Austin in Km
N = [1:1:365]; % day of year
lat = 30.260;  % latitude of austin
time = 12.00;  % watch time 
Lo_std = 90;   % standard longitude 
Lo_loc = 97.753;%local longitude 
beta = 22;
panAz = 46;
thetaI = [zeros([1 length(N)])];
% calculate solar alt, solar azmuth, hour angle, declination
for i=1:length(N)
    n = N(i);
    dec = Declination(n);
    et = ET(n);
    st = solar_time(time,Lo_std,Lo_loc,et);
    hrAng = w(st);
    alpha = SolarAltitude(lat,dec,hrAng);
    solAz = SolarAzimuth(alpha,dec,hrAng);
    thetaI(i) = Incident(alpha,beta,solAz,panAz);
end

%%%%%%%%%%%%%%%%%%%%
% Case 1 graph 6
% Trapezoidal Integration 
% of total power production 
% per day for a year
%%%%%%%%%%%%%%%%%%%%
integration = [zeros([1 length(N)])];
for i=1:length(N)
    n = N(i);
    pwr = P1_C1(n,46); % P1_C1 is daily power production
    integration(i)= trapz(TOD,pwr);
end

%%%%%%%%%%%%%%%%%
%plotting graph 5
figure;
plot(N,thetaI);
grid on;
title('Angle of Incidence at Noon vs. Day of the Year');
xlabel('Day of the Year');
ylabel('Angle of Incidence (deg)');
%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%
%plotting graph 6
figure;
plot(N,integration);
grid on;
title('Total Daily Energy Production vs. Day of the Year');
xlabel('Day of the Year');
xlim([0 365])
ylabel('Energy Production (MWh)');


