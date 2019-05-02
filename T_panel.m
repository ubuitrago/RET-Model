function value = T_panel(clockTime,day, Irradiance)

value=T_infinity(clockTime,day)+(28/80)*Irradiance/10;