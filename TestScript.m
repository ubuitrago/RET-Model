%% test  script for Phase 1
clear variables
N=171; %day of the year
Long = 97.7528; %Longitude of the Event Center
LongStand = 90;
L = 30.2607; %Latitude of the Event Center
t = 12.00; %Decimal Local Time (noon)
Tilt = 22; %degrees
PanelAzimuth = 46; %degrees
A = .149047; %altitude in km
Efficiency = .157; %decimal efficiency
T = 25; %panel temp in celsius
length = 1.64; %meters
width = .99; %meters
n = 960; %panels

Del = Declination(N); %Declination angle 
w = w(solar_time(t,LongStand,Long,ET(N))); % Hour angle as a function of Solar Time, which is a function of 
% the Equation of Time, which is a function of the Local Time.
SolarAltitude = SolarAltitude(L,Del,w);
SolarAzimuth = SolarAzimuth(SolarAltitude,Del,w);
Incident = Incident(SolarAltitude,Tilt,SolarAzimuth,PanelAzimuth);
Io = Io(N); %Insolation for that day of the year
BeamT = BeamT(A,N,SolarAltitude); %Beam Transmissivity
DiffuseT = DiffuseT(BeamT); %Diffuse Transmissivity
Icbd = Icbd(Icb(Io,BeamT,Incident),Icd(DiffuseT,Io,SolarAltitude,Tilt)); %clear day beam and diffuse insolation

P = Power(Icbd,Efficiency,T,length,width,n);

