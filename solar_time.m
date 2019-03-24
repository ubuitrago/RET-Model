function value = solar_time(time,long_stand,long_loc,ET)
%finds the solar time of a specific location at a specific time of a
%certain day of the year. Longitude should be given in decimal degrees and 
%time should be given as decimal hours. For Austin, long_stand is 90 and 
%long_loc is 97.7528 for the Palmer Event Center.

value = time + (2/30)*(long_stand-long_loc)/60 + ET/60;

