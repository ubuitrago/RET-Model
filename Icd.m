function value = Icd(DiffuseT,Io,SolarAltitude,Tilt)

value = DiffuseT*Io*cosd(90-SolarAltitude)*(1+cosd(Tilt))/2;