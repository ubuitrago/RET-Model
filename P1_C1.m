% Graphs the Irradiance for Austin and total system
% power delivery vs. time of day.
% Austin Irradiance vs. time of day.
% OCI=0
% Day is December 21
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculating Solar Time array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables;
N = 355;
long_std = 90; %standard longitude 
long_loc = 97.753; %local longitude
TOD = [0.00:0.25:24.00]; % Decimal Hours 
ST = [zeros([1 length(TOD)])]; % pre-filled for execution speed 
et = ET(N); % equation of time

for i=1:length(TOD)
    ST(i) = solar_time(TOD(i),long_std,long_loc,et);
end

%%%%%%%%%%%%%%%%%%%%%%%
% Solar Geometrictators 
%%%%%%%%%%%%%%%%%%%%%%%

lat = 30.260;
dec = Declination(N);
beta = 0;
panelAz = 46;
Alpha = [zeros([1 length(TOD)])]; %solar altitude 
hrAng = [zeros([1 length(TOD)])]; %hour angle 
solAz = [zeros([1 length(TOD)])]; %solar azimuthal
anglInc = [zeros([1 length(TOD)])]; %angle of incedence 
for i=1:length(TOD)
    hrAng(i) = w(ST(i));
    Alpha(i) = SolarAltitude(lat,dec,hrAng(i));
    solAz(i) = SolarAzimuth(Alpha(i),dec,hrAng(i));
    anglInc(i) = Incident(Alpha(i),beta,solAz(i),panelAz);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculating Irradiation and Power
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Inso = Io(N);
alt = 0.149; %Altitude of Austin in Km
beamTrans = BeamT(alt,N,Alpha); % beam radiation transmisivity  
diffuseTrans = DiffuseT(beamTrans); % Diffuse radiation transmisivity

%irradiation calculation 
for i=1:length(anglInc)
    
    irrB(i) = Icb(Inso,beamTrans(i),anglInc(i)) ; % clear day beam irradation 
    % checking tilt of panel
    if beta ~= 0
        irrD(i) = Icd(diffuseTrans(i),Inso,anglInc(i),beta); % clear day diffuse irradation, panel tilt
    else
        irrD(i) = Icd(diffuseTrans(i),Inso,90-Alpha(i),beta); % horizontal surface
    end
    
    totIr(i) = Icbd(irrB(i),irrD(i));
    
end 

%Power calculation 
eff = 0.157;    % rated module efficiency 
panelTemp = 25; % degrees celsius 
len = 1.640; % meters
width = 0.99;   % meters
numPanels = 960;
Ptot = [zeros([1 length(totIr)])];

for i=1:length(totIr)
    
    Ptot(i) = Power(totIr(i),eff,panelTemp,len,width,numPanels); 
    Ptot(i) = Ptot(i)/1e6;
end 

%%%%%%%%%%%
% Grahping 
%%%%%%%%%%%
figure
grid on
title("Irradiance for Austin and system power delivery vs. Time of day");
hold on;
xlabel("Time of Day (decimal hours)");
yyaxis left
plot(TOD,Ptot,'-b');
ylabel("Total Power Delivery (Mw)");
yyaxis right
plot(TOD,totIr,'r--');
ylabel('Irradiance for Austin (W/m^2)');
legend('Power','Irradiance')
set(legend,'Location','NorthWest','FontSize',13);
hold off
