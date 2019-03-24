function value = Incident(SolarAltitude, Tilt, SolarAzimuth, PanelAzimuth)


value = acosd((sind(SolarAltitude)*cosd(Tilt))+(cosd(SolarAltitude)*sind(Tilt)*cosd(PanelAzimuth-SolarAzimuth)));