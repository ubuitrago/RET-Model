N = 172;
global TOD;
global totIr;
Ptot = P1_C1(N);
%%%%%%%%%%%
%Grahping for three
%case1_graphs 1,2,&3
%%%%%%%%%%%
figure
grid on
title("Irradiance for Austin and system power delivery vs. Time of day");
hold on;
xlabel("Time of Day (decimal hours)");
yyaxis left
plot(TOD,Ptot,'-b');
ylabel("Total Power Delivery (Mw)");
yyaxis right
plot(TOD,totIr,'r--');
ylabel('Irradiance for Austin (W/m^2)');
legend('Power','Irradiance')
set(legend,'Location','NorthWest','FontSize',13);
hold off
%%%%%%%%%%%%%%%%%%%