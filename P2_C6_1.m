% 1X congfiguration
% March 26,2019
% case 5 %
load('DailyOCI.mat');
global totIr_OCI;
global TOD;
day = 85;
P2_C6(day,index_OCI(day),25,46);
% power generated
for i=1:length(TOD)
    time = TOD(i);
    I = totIr_OCI(i);
    panel_temp(i) = T_panel(time,day,I);
end
    
for i=1:length(TOD)
    val = P2_C6(day,index_OCI(day),panel_temp(day,i),46);
    power(1,i) = val(i);
end
% Idealized power consumption on a winter day
consume = load('winter_consumption.mat');
% Idealized power purchased on a winter day


    
    