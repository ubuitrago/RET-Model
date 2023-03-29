%%%%%%%%%%%%%
% Panel temperature vs. time of day,sunny day (OCI=0), June 21
%%%%%%%%%%%%%
OCI = 0;
day = 172;
P2_C5(day,OCI,25);
global TOD;
global totIr_OCI;
% creating zero arrays
panel_temp = [zeros(4,length(TOD))];
irr = [zeros(3,length(TOD))]; %irradiance
power = irr;

for i=1:length(TOD)
    time = TOD(i);
    I = totIr_OCI(i);
    panel_temp(1,i) = T_panel(time,day,I);
end
% for use in graph 3
irr(1,:) = totIr_OCI; % not dep. on panel temp?

% cloudy day (OCI=10), June 21
OCI = 10;
P2_C5(day,OCI,25);
for i=1:length(TOD)
    time = TOD(i);
    I = totIr_OCI(i);
    panel_temp(2,i) = T_panel(time,day,I);
end

%%%%%%%%%%%%%
% Irradiance for Austin and total system power delivery vs. time of day
% June 21, OCI =0
%%%%%%%%%%%%%
day = 172;
OCI = 0;
for i=1:length(TOD)
    val = P2_C5(day,OCI,panel_temp(1,i));
    power(1,i) = val(i);
end

%%%%%%%%%%%%
% Irradiance for Austin and total system power delivery vs. time of day
% with cloud model
% June 21
%%%%%%%%%%%%
load('DailyOCI.mat');
OCI = index_OCI(day);
P2_C5(day,OCI,25);
irr(3,:) = totIr_OCI;
% calculating panel temps. throughout the day
for i=1:length(TOD)
    time = TOD(i);
    I = irr(3,i);
    panel_temp(4,i) = T_panel(time,day,I);
end

for i=1:length(TOD)
    val = P2_C5(day,OCI,panel_temp(4,i));
    power(3,i) = val(i);
end

%%%%%%%%%%%%%
% Irradiance for Austin and total system power delivery vs. time of day
% Dec 21, OCI=10
%%%%%%%%%%%%%
day = 355;
OCI = 10;
P2_C5(day,OCI,25);
irr(2,:) = totIr_OCI;
% calculating panel temps. throughout the day
for i=1:length(TOD)
    time = TOD(i);
    I = irr(2,i);
    panel_temp(3,i) = T_panel(time,day,I);
end

for i=1:length(TOD)
    val = P2_C5(day,OCI,panel_temp(3,i));
    power(2,i) = val(i);
end

%%%%%%%%%%%%
% Irradiance for Austin and total system power delivery vs. time of day
% with cloud model
% June 21
%%%%%%%%%%%%



%%%%%%%%%%%%
% Graphs 1&2
%%%%%%%%%%%%
figure;
hold on;
grid on
plot(TOD,panel_temp(1,:),'-b');
plot(TOD,panel_temp(2,:),'-r');
xlabel("Time of Day (Decimal Hours)");
ylabel("Panel Temperature (deg.Celsius)");
title("Panel Temperature vs. Time of Day,June 21");
legend('OCI=0','OCI=10');
set(legend,'Location','southoutside','FontSize',12);
grid off;
hold off;


%%%%%%%%%%%%
% Graphs 3&4
%%%%%%%%%%%%
figure
hold on;
grid on;
title("Irradiance and Power Delivery vs. Time of Day w/OCI & HT model");
xlabel("Time of Day (Decimal Hours)");
yyaxis left
plot(TOD,power(1,:),'-b');
ylabel("Total Power Delivery (MW)");
yyaxis right
plot(TOD,irr(1,:),'b--');
ylabel('Irradiance for Austin (W/m^2)');
yyaxis left
plot(TOD,power(2,:),'-r');
yyaxis right
plot(TOD,irr(2,:),'r--');
% legend('June 21st Power.OCI=0','December 21st Power.OCI=10','June 21st Irradiance','December 21st Irradiance')
% set(legend,'Location','southoutside','FontSize',12);
%%%%%%%%%%%
% Graph 5
%%%%%%%%%%%
yyaxis left
plot(TOD,power(3,:),'-g');
yyaxis right
plot(TOD,irr(3,:),'g--');
legend('June 21st Power.OCI=0','December 21st Power.OCI=10','June 21st Power.Actual OCI=2.2'...
    ,'June 21st Irradiance','December 21st Irradiance','June 21st Irradiance.Actual OCI=2.2')
set(legend,'Location','southoutside','FontSize',12);

