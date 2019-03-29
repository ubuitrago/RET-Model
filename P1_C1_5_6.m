% Case 1 graph 5
% Angle of Incidence at noon vs. Day of the Year starting Jan 1.
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
eff = 0.157;    % rated module efficiency 
len = 1.640; %length meters
width = 0.99;   % meters
numPanels = 960;
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
% Trapezoidal Integration of total power production per day for a year
%%%%%%%%%%%%%%%%%%%%
H = 0.25; %step size, 15 minutes
integration = [zeros([1 length(N)])];
for i=1:length(N)
    
    n = N(i);
    pwr = P1_C1(n); % P1_C1 is daily power production
    daily = 0;
    integration(i)= trapz(TOD,pwr);

end

%plotting graph 5
figure;
grid on;
plot(N,thetaI);
title('Angle of Incidence at noon vs. Day of the year');
xlabel('Day of the Year');
ylabel('Angle of Incidence (deg)');
grid off;
%%%%%%%%%%%%%%%

%plotting graph 6
figure;
grid on;
plot(N,integration);
title('Total Daily energy production vs. Day of the year');
xlabel('Day of the Year');
ylabel('Energy Production (Mwh)');
grid off;

