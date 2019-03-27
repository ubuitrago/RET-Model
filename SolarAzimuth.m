function value = SolarAzimuth(SolarAltitude,Declination,w)

% All inputs should be in degrees. Solar azimuth is output in degrees.

value = asind((cosd(Declination)*sind(w))/cosd(SolarAltitude));