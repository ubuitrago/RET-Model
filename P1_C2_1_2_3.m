N = 355;
global TOD;
global totIr;
Ptot = P1_C2(N,0);
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
plot(TOD,totIr,'-k');
ylabel('Irradiance for Austin (W/m^2)');
Ptot = P1_C2(355,25);
yyaxis left
plot(TOD,Ptot,'-r');
Ptot = P1_C2(355,45);
plot(TOD,Ptot,'-g');
legend('Power at 0 C','Power at 25 C','Power at 45 C','Irradiance')
set(legend,'Location','southoutside','FontSize',12);
hold off

figure
grid on
title("Irradiance for Austin and System Power Delivery vs. Time of Day");
xlabel("Time of Day (Decimal Hours)");
yyaxis left
Ptot = P1_C2(172,25);
plot(TOD,Ptot,'-b');
hold on
ylabel("Total Power Delivery (MW)");
yyaxis right
plot(TOD,totIr,'-k');
ylabel('Irradiance for Austin (W/m^2)');
Ptot = P1_C2(172,45);
yyaxis left
plot(TOD,Ptot,'-r');
Ptot = P1_C2(172,85);
plot(TOD,Ptot,'-g');
legend('Power at 25 C','Power at 45 C','Power at 85 C','Irradiance')
set(legend,'Location','southoutside','FontSize',12);
hold off

%%%%%%%%%%%%%%%%%%%