% 1X congfiguration
% March 29,2019
load('DailyOCI.mat');
global totIr_OCI;
global TOD;
day = 88;
P2_C6(day,5,25,46);
% power generated
for i=1:length(TOD)
    time = TOD(i);
    I = totIr_OCI(i);
    panel_temp(i) = T_panel(time,day,I);
end
    
for i=1:length(TOD)
    val = P2_C6(day,5,panel_temp(i),46);
    generated(1,i) = val(i);
end
% Idealized power consumption on a winter day
load('winter_consumption.mat');
% Idealized power purchased on a winter day
purchased = [zeros(1,289)];
stored = [zeros(1,289)];
for i=1:289
    diff = consum(i) - generated(i);
    
    if diff > 0
        purchased(i) = diff;
    
    elseif diff < 0
        
        if i == 1
            stored(i) = abs(diff);
        else
            stored(i) = abs(diff)+ stored(i-1);
        end
    end
end

actual_data = readtable('March 29, 2019 PEC data.csv'); 
pec_prod = flip(actual_data{:,3});
pec_consumption = flip(actual_data{:,2});

figure
hold on;
grid on;
xlabel('Time of Day');
yyaxis left;
ylabel('Power (Kw)');
plot(TOD,generated,'b-');
plot(TOD,purchased,'r-');
yyaxis right;
ylabel('Storage (Kwh)')
plot(TOD,stored,'g-');
yyaxis left;
plot(TOD,consum,'m-');
plot(TOD,pec_prod,'k-');
plot(TOD,pec_consumption,'k--');
grid off;
hold off;
title('Power Production vs Time of Day with storage (1X)')
legend('Power produced','Idealized Power Purchased'...
    ,'Idealized Power Consumed','PEC Production','PEC Consumption','Energy stored in batteries')
set(legend,'Location','southoutside','FontSize',12);


%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4X configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%



    
    