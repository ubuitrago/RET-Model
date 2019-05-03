% First two plots of case 4
% OCI=10
% Dec. 21
global TOD;
global totIr_OCI;
DOY = 355;
OCI = 10;
power = P2_C4(DOY,OCI);
%%%%%%%%%%%%%%%%%
% Plotting graph 1 %%%%%%
figure
grid on
title("Irradiance and Power Delivery vs. Time of Day, cloudy day");
xlabel("Time of Day (Decimal Hours)");
yyaxis left
plot(TOD,power,'-b');
hold on
ylabel("Total Power Delivery (MW)");
yyaxis right
plot(TOD,totIr_OCI,'b--');
ylabel('Irradiance for Austin (W/m^2)');

%%%%%%%%%%%%%%%%%%%
% Plotting graph 2 %%%%
DOY = 172;
OCI = 10;
power = P2_C4(DOY,OCI);
yyaxis left;
plot(TOD,power,'-r');
yyaxis right;
plot(TOD,totIr_OCI,'r--');
legend('December 21st Power','June 21st Power','December 21st Irradiance','June 21st Irradiance')
set(legend,'Location','southoutside','FontSize',12);
hold off;