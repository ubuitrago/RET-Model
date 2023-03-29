% Total daily energy production vs. day of the year, starting on Jan.1st
% Will compare with Case 1, Case 1 plus panel temp model, case 4, and PEC
% data

%%%%%%%%%%%%%%%%%%%%
% Case 1 plus panel temp. model
%%%%%%%%%%%%%%%%%%%%
global TOD;
global totIr_OCI;
panel_temp = [zeros(365,289)];
daily_power = [zeros(2,365)];
% getting panel temp. for every hour on every day
for day=1:365
    P2_C5(day,0,25);
    for i=1:length(TOD)
        time = TOD(i);
        I = totIr_OCI(i);
        panel_temp(day,i) = T_panel(time,day,I);
    end
end
% calculating power output with known panel temperature on every hour
power = [zeros(1,289)];
for day=1:365
    
    for i=1:length(TOD)
        val = P2_C5(day,0,panel_temp(day,i));
        power(1,i) = val(i);
    end
    
    daily_power(1,day) = trapz(TOD,power); %first row holds Case 1
end 

% case 5 %
load('DailyOCI.mat');
for day=1:365
    P2_C5(day,index_OCI(day),25);
    for i=1:length(TOD)
        time = TOD(i);
        I = totIr_OCI(i);
        panel_temp(day,i) = T_panel(time,day,I);
    end
end

for day=1:365
    
    for i=1:length(TOD)
        val = P2_C5(day,index_OCI(day),panel_temp(day,i));
        power(1,i) = val(i);
    end
    
    daily_power(2,day) = trapz(TOD,power); %first row holds Case 1
    
end 

load('Case1_integralPower_year.mat');
load('Case4_integralPower_year.mat');
PEC = readtable('daily_noon.csv');
PEC = flip(PEC{:,3}*(0.001)*24);

figure
hold on;
plot(daily_power(1,:),'b-');
plot(daily_power(2,:),'r-');
plot(integration,'g-');
plot(integralP,'m-');
plot(PEC,'k--')
xlim([0 365]);
ylabel('Power Produced (MWh)')
xlabel('Day of year')
title('Total Daily Energy Production vs Day of the Year with complete model')
legend('Case 1 + Panel Temp. Model','Panel Temp. Model + Cloud Model','Case 1'...
    ,'Case 4','PEC actual data')
set(legend,'Location','southoutside','FontSize',12);