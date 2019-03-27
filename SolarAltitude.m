function value = SolarAltitude(L,declination,w)

value = asind((sind(declination)*sind(L))+(cosd(declination)*cosd(L)*cosd(w)));