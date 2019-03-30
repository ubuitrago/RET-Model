% Total system power delivery (Mwh)vs.time of day 
% for March 26,2019.
% C1_Graph7
global TOD;
N = 85;
pwr = P1_C1(N);
integration = round(trapz(TOD,pwr),2);
f = sprintf(' %.2f',integration);
%plotting graph 7
figure;
plot(TOD,pwr);
grid on;
title('Power Delivery vs. Time of Day on March 26,2019');
xlabel('Time of Day (decimal hours)');
ylabel('Power Production (Mw)');
dim = [0.14 0.5 0.4 0.4];
str = strcat('Total Power delivery is', f,' Mwh');
annotation('textbox',dim,'String',str,'FitBoxToText','on');