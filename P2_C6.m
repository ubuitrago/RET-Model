function PTOT = P2_C6(N,OCI,panelTemp,panelAz,numPanels=960)
% function outputs total power for a given day.
% It graphs the Irradiance for Austin and total system
% power delivery vs. time of day.
% Utilizing OCI in this calculation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculating Solar Time array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% globalizing variables for accessibility 
global TOD;
global totIr_OCI; %irradiance with OCI model 
global irrB; 
global irrD;
long_std = 90; %standard longitude 
long_loc = 97.753; %local longitude
TOD = [0.00:5/60:24.00]; % Decimal Hours 
ST = [zeros([1 length(TOD)])]; % pre-filled for execution speed 
et = ET(N); % equation of time

for i=1:length(TOD)
    ST(i) = solar_time(TOD(i),long_std,long_loc,et);
end

%%%%%%%%%%%%%%%%%%%%%%%
% Solar Geometrictators 
%%%%%%%%%%%%%%%%%%%%%%%
lat = 30.260; % Austin latitude 
dec = Declination(N); % angle in degrees 
%panelAz = 46; % panel azimuthal angle 
beta = 22; % panel tilt in degrees
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
%Globalizing beam and diffuse transmissivity for accessibility 
beamTrans = BeamT(alt,N,Alpha); % beam transmisivity for clear day
beamTrans_wc = beamTrans*(1-(OCI/10)); % beam trans with clouds
diffuseTrans_wc = 0.271-(0.294*beamTrans_wc); % Diffuse transmisivity with clouds
irrD = [zeros([1 length(anglInc)])];
%irradiation calculation
for i=1:length(anglInc)
%     global irrB;    % globalizing irradation for accessibility 
%     global irrD;
    irrB(i) = Icb(Inso,beamTrans_wc(i),anglInc(i)) ; % clear day beam irradation 
    % checking tilt of panel
    if beta ~= 0
        irrD(i) = Icd(diffuseTrans_wc(i),Inso,anglInc(i),beta); % clear day diffuse irradation, panel tilt
    elseif beta == 0
        zenith = 90-Alpha(i);
        irrD(i) = Icd(diffuseTrans_wc(i),Inso,zenith,beta); % horizontal surface
    end
    % Cannot model diffuse radiation at sunrise when
    % angles are small, so setting diffuse Irradiation equal to zero if its negative. 
    if irrD(i) < 0
        irrD(i) = 0;
    end 
    
    totIr_OCI(i) = Icbd(irrB(i),irrD(i));
    
end 

%Power calculation 
eff = 0.157;    % rated module efficiency 
%panelTemp = 25; % degrees celsius 
len = 1.640; %length meters
width = 0.99;   % meters
%numPanels = 960; % number of panels 
Ptot = [zeros([1 length(totIr_OCI)])];

for i=1:length(totIr_OCI)
    Ptot(i) = Power(totIr_OCI(i),eff,panelTemp,len,width,numPanels); 
    Ptot(i) = Ptot(i);
end 
 PTOT = Ptot;

