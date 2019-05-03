%%%%%%%%%%%%%%%%
% Case 2 graph 3
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
% Case 2 graph 3
% Trapezoidal Integration 
% of total power production 
% per day for a year
% repeted at different temps
%%%%%%%%%%%%%%%%%%%%
integration = [zeros([1 length(N)])];
for i=1:length(N)
    n = N(i);
    pwr = P1_C2(n,0); % P1_C1 is daily power production
    integration(i)= trapz(TOD,pwr);
end

%%%%%%%%%%%%%%%
%plotting graph 3
figure;
plot(N,integration,'-b');
hold on
integration = [zeros([1 length(N)])];
for i=1:length(N)
    n = N(i);
    pwr = P1_C2(n,25); % P1_C1 is daily power production
    integration(i)= trapz(TOD,pwr);
end
plot(N,integration,'-r');
integration = [zeros([1 length(N)])];
for i=1:length(N)
    n = N(i);
    pwr = P1_C2(n,45); % P1_C1 is daily power production
    integration(i)= trapz(TOD,pwr);
end
plot(N,integration,'-g');
integration = [zeros([1 length(N)])];
for i=1:length(N)
    n = N(i);
    pwr = P1_C2(n,85); % P1_C1 is daily power production
    integration(i)= trapz(TOD,pwr);
end
plot(N,integration,'-c');
grid on;
title('Total Daily Energy Production vs. Day of the Year');
legend({'0C Panel Temperature','25C Panel Temperature','45C Panel Temperature','85C Panel Temperature'},'location','southoutside')
xlabel('Day of the Year');
xlim([0 365])
ylabel('Energy Production (MWh)');


