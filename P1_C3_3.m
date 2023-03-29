clear all
N = 355;
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
%%%%%%%%%%
% finding the best tilt angle
%%%%%%%%%%
io = Io(N);
Tiltrange = -90:1:90;
for j = 1:length(TOD)
    for i = 1:length(Tiltrange)
        incident(i,j) = Incident(Alpha(j), Tiltrange(i), SolarAzimuth(Alpha(j),dec,hrAng(j)), 46);
    end
end

[incidentbest, indexbest] = min(incident,[],1);
Tiltbest = indexbest-91;

global TOD;
global totIr;
Ptot = P1_C3(N,Tiltbest);
figure
grid on
title("Irradiance for Austin and System Power Delivery vs. Time of Day");
xlabel("Time of Day (Decimal Hours)");
yyaxis left
plot(TOD,Ptot,'-b');
hold on
ylabel("Total Power Delivery (MW)");
yyaxis right
plot(TOD,totIr,'b--');
ylabel('Irradiance for Austin (W/m^2)');
%%%%%%
N = 171;
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
%%%%%%%%%%
% finding the best tilt angle
%%%%%%%%%%
io = Io(N);
Tiltrange = -90:1:90;
for j = 1:length(TOD)
    for i = 1:length(Tiltrange)
        incident(i,j) = Incident(Alpha(j), Tiltrange(i), SolarAzimuth(Alpha(j),dec,hrAng(j)), 46);
    end
end

[incidentbest, indexbest] = min(incident,[],1);
Tiltbest = indexbest-91;
Ptot = P1_C3(N,Tiltbest);
yyaxis left
plot(TOD,Ptot,'-r');
yyaxis right
plot(TOD,totIr,'r--');


legend('December 2st1 Power','June 21st Power','December 21st Irradiance','June 21st Irradiance')
set(legend,'Location','southoutside','FontSize',12);
hold off


figure
plot(TOD,Tiltbest)
xlim([0 24]);
ylim([-100 100]);
xlabel('Time of Day (Decimal hours)')
title('Optimal Tilt Angle vs Time of Day, June 21st')
ylabel('Angle (Degrees)')
grid on

integralP=zeros(1,365);
for N=1:365
    Ptot = P1_C3(N,Tiltbest);
    integralP(N)=trapz(TOD,Ptot);
end
figure
plot(integralP)
xlim([0 365]);
ylabel('Power Produced (MWh)')
xlabel('Day of year')
title('Total daily energy production vs day of year')

