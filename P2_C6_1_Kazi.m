clear all
% 1X congfiguration
% March 26,2019
load('DailyOCI.mat');
global totIr_OCI;
global TOD;
N = 88;
OCI=5;
P2_C6(N,OCI,25,46);
% power Ptot
for i=1:length(TOD)
    time = TOD(i);
    I = totIr_OCI(i);
    panel_temp(i) = T_panel(time,N,I);
end

x=4;
if x==4
    for i=1:length(TOD)
        val1 = P2_C6(N,OCI,panel_temp(i),46);
    end
    for i=1:length(TOD)
        val2 = P2_C6(N,OCI,panel_temp(i),0);
    end
    for i=1:length(TOD)
        val3 = P2_C6(N,OCI,panel_temp(i),0);
    end
    for i=1:length(TOD)
        val4 = P2_C6(N,OCI,panel_temp(i),23);
    end
    for i=1:length(TOD)
        Ptot(1,i)=val1(i)+val2(i)+val3(i)+val4(i);
    end
end
if x==6
    for i=1:length(TOD)
        val1 = P2_C6(N,OCI,panel_temp(i),46);
    end
    for i=1:length(TOD)
        val2 = P2_C6(N,OCI,panel_temp(i),0);
    end
    for i=1:length(TOD)
        val3 = P2_C6(N,OCI,panel_temp(i),0);
    end
    for i=1:length(TOD)
        val4 = P2_C6(N,OCI,panel_temp(i),23);
    end
    for i=1:length(TOD)
        val5 = P2_C6(N,OCI,panel_temp(i),23);
    end
    for i=1:length(TOD)
        val6 = P2_C6(N,OCI,panel_temp(i),46);
    end
    for i=1:length(TOD)
        Ptot(1,i)=val1(i)+val2(i)+val3(i)+val4(i)+val5(i)+val6(i);
    end
end

% Idealized power consumption on a winter day
load('winter_consumption.mat');
%needs Ptot over the given day, needs to be told the day of the year, and
%the number of batteries.
Batteries = 6; %0,6, or 24
cconsumption = zeros(1,length(TOD)); % cummulative consumption in kWh that had to be purchased from Austin Energy
iconsumption = zeros(1,length(TOD)); %instantaneous consumption kW
storage = zeros(1,length(TOD)); %kWh
esold = 0; %energy sold
capacity = Batteries*210; % 210 kWh per battery
for i = 1:length(TOD)
    if N >= 152 && N <=324 %summer days , June 1 to nov 20
        if TOD(i) <= 6 || TOD(i) >19 %midnight to 6am or 7pm to midnight
            iconsumption(i) = 220; %kw
        elseif TOD(i) > 6 && TOD(i) <= 19 %6 to 18
            iconsumption(i) = 580; %kw            
        end
    elseif N >= 325 || N<= 151 %winter days, Nov 21 to may 21
        if TOD(i)<= 6 || TOD(i) >18 %midnight to 6 or 6 to midnight
            iconsumption(i) = 200; %200 kW
        elseif TOD(i)>6 && TOD(i) <= 18 %6 to 18
            iconsumption(i) = 300; %300 kW
        end
    
    end
    %we now have instantaneous demand for this time of day
    % next we either store battery power, use battery power, or buy energy     
    if storage(i) == capacity && Ptot(i)>iconsumption(i)
        esold = esold + (Ptot(i)-iconsumption(i))*5/60; %if the batteries are full, excess energy is sold
    elseif Ptot(i)>iconsumption(i) && storage(i) <capacity %checks if there is excess power and battery room
        if i >1
            storage(i) = storage(i-1) + (Ptot(i)-iconsumption(i))*5/60; %adds to storage. times 5/60 for the 5 minute step
            if storage(i) > capacity %if the step that was just executed excedes the capacity
                esold = esold + (storage(i)-capacity); %sell the excess
                storage(i) = capacity; %reduce to full capacity
            end
        else
            storage(i) = 0 + (Ptot(i)-iconsumption(i))*5/60; %adds to storage. times 5/60 for the 5 minute step
            if storage(i) > capacity %if the step that was just executed excedes the capacity
                esold = esold + (storage(i)-capacity); %sell the excess
                storage(i) = capacity; %reduce to full capacity
            end
        end
    elseif Ptot(i) <= iconsumption(i) %if we don't have enough solar power
        if iconsumption(i)*5/60 > storage+Ptot(i)*5/60 %not enough battery storage
            cconsumption(i) = (iconsumption(i)*5/60-storage(i)-Ptot(i)*5/60); %some energy is purchased
            storage(i) = 0; %all storage is depleted to decrease purchased amount
        elseif iconsumption(i)*5/60 <storage(i) + Ptot(i)*5/60
            cconsumption(i) = 0;
            storage(i) = storage(i-1) + Ptot(i)*5/60 - iconsumption(i)*5/60;
        end
    end
    
end
    

if N==85
    actual_data = readtable('March 26, 2019 PEC data.csv'); 
elseif N==88
    actual_data = readtable('March 29, 2019 PEC data.csv'); 
end
pec_prod = flip(actual_data{:,3});
pec_consumption = flip(actual_data{:,2});

figure
hold on;
grid on;
xlabel('Time of Day');
ylabel('Power (KW)');
plot(TOD,Ptot,'b-');
plot(TOD,cconsumption,'r-');
plot(TOD,consum,'m-');
plot(TOD,pec_prod,'k-');
plot(TOD,pec_consumption,'k--');
yyaxis right
plot(TOD,storage,'g-'); %Only one on the right bc its KWH
ylabel ('Storage (KWh)');
grid off;
hold off;
title('Power Production vs Time of Day with storage (6X)')
legend('Power produced','Idealized Power Purchased'...
    ,'Idealized Power Consumed','PEC Production','PEC Consumption','Energy stored in batteries')
set(legend,'Location','southoutside','FontSize',12);


    
    