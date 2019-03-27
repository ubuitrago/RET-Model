function value = dailypower(N,A,Long,LongStand,L,tilt,PanelAzimuth,Efficiency,T,Length,width,n,tstart,tend)
% trapezoidal integration of instantaneous power over the time of the day
% where the sun is up (solar altitude > 0).
daily = 0;
H = .25; %step size, 15 minutes
t = [tstart:H:tend];
W = w(solar_time(t,LongStand,Long,ET(N)));
solaraltitude = SolarAltitude(L,Declination(N),W);
solarazimuth = SolarAzimuth(solaraltitude,Declination(N),W);
incident = Incident(solaraltitude,tilt,solarazimuth,PanelAzimuth);
beamt = BeamT(A,N,solaraltitude);
icbd = Icbd(Icb(Io(N),beamt,incident),Icd(DiffuseT(beamt),Io(N),solaraltitude,tilt));
power = Power(icbd,Efficiency,T,Length,width,n);

for i = 1:length(power)
    if solaraltitude(i) > 0 && solaraltitude(i+1) > 0
        step = (H/2*(power(i)+power(i+1)));
        daily = daily + step;
    end
end

value = daily;
