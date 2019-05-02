N = 172;
global TOD;
global totIr;
Ptot = P1_C1(N,46);
%%%%%%%%%%%
%Grahping for three
%case1_graphs 1,2,&3
%%%%%%%%%%%
figure
grid on
title("Irradiance for Austin and System Power Delivery vs. Time of Day");
xlabel("Time of Day (Decimal Hours)");
yyaxis left
plot(TOD,Ptot,'-b');
hold on
ylabel("Total Power Delivery (MW)");
yyaxis right
plot(TOD,totIr,'b--');
ylabel('Irradiance for Austin (W/m^2)');
Ptot = P1_C1(355,46);
yyaxis left
plot(TOD,Ptot,'-r');
yyaxis right
plot(TOD,totIr,'r--');
Ptot = P1_C1(172,0);
yyaxis left
plot(TOD,Ptot,'-g');
yyaxis right
plot(TOD,totIr,'g--');
legend('June 21st Power','December 21st Power','June 21st Due South Power','June 21st Irradiance','December 21st Irradiance','June 21st Due South Irradiance')
set(legend,'Location','southoutside','FontSize',12);
hold off


%%%%%%%%%%%%%%%%%%%