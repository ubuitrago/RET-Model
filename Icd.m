function value = Icd(DiffuseT,Io,Incident,Tilt)

value = DiffuseT*Io*cosd(Incident)*(1+cosd(Tilt))/2;