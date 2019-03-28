% Graphs the Irradiance for Austin and total system
% power delivery vs. time of day. 
% OCI=0
% Day is December 21
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculating Solar Time array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables;
N = 355;
TOD = [0.00:0.25:24.00]; % check that this is correct
ST = [zeros([1 length(TOD)])]; % pre-filled for execution speed 
et = ET(N);
for i=1:length(TOD)
    ST(i) = solar_time(TOD(i),90,97.753,et);
end

%%%%%%%%%%%%%%%%%%%%%%%
% Solar Geometrictators 
%%%%%%%%%%%%%%%%%%%%%%%

lat = 30.260;
dec = Declination(N);
Alpha = [zeros([1 length(TOD)])]; %solar altitude 
hrAng = [zeros([1 length(TOD)])]; %hour angle 
solAz = [zeros([1 length(TOD)])]; %solar azimuthal
anglInc = [zeros([1 length(TOD)])]; %angle of incedence 
for i=1:length(TOD)
    hrAng(i) = w(ST(i));
    Alpha(i) = SolarAltitude(lat,dec,hrAng(i));
    solAz(i) = SolarAzimuth(Alpha(i),dec,hrAng(i));
    anglInc(i) = Incident(Alpha(i),22,solAz(i),46);
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
    irrD(i) = Icd(diffuseTrans(i),Inso,Alpha(i),22); % clear day diffuse irradation
    totIr(i) = Icbd(irrB(i),irrD(i));
end 
%Power calculation 
for i=1:length(totIr)
    Ptot(i) = Power(totIr(i),0.182,25,1.640,0.99,960); % assumed a temp of 25 C, check with Andrew to mk sure was used correctly
    Ptot(i) = Ptot(i)/1e6;
end 

figure
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




