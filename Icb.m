function value = Icb(Io,BeamT,Incident)

if Incident > 90
    value = 0
    
else
    value = Io*BeamT.*cosd(Incident);

end