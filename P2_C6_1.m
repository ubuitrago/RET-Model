% 1X congfiguration
% March 26,2019
load('DailyOCI.mat');
global totIr_OCI;
global TOD;
day = 85;
N = day;
P2_C6(day,0,25,46);
% power generated
for i=1:length(TOD)
    time = TOD(i);
    I = totIr_OCI(i);
    panel_temp(i) = T_panel(time,day,I);
end
    
for i=1:length(TOD)
    val = P2_C6(day,0,panel_temp(i),46);
    generated(1,i) = val(i);
end
Ptot = generated;
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
%%%%%%%%%%%%%%%
% battery model
%%%%%%%%%%%%%%%
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


%%%%%%%%%%%%%%%
actual_data = readtable('March 26, 2019 PEC data.csv'); 
pec_prod = flip(actual_data{:,3});
pec_consumption = flip(actual_data{:,2});

figure
hold on;
grid on;
xlabel('Time of Day');
ylabel('Power (Kw)');
plot(TOD,generated,'b-');
plot(TOD,cconsumption,'r-');
yyaxis right
plot(TOD,storage,'g-'); %Only one on the right bc its KWH
ylabel ('Storage (KWh)');
plot(TOD,consum,'m-');
plot(TOD,pec_prod,'k-');
plot(TOD,pec_consumption,'k--');
grid off;
hold off;
title('Power Production vs Time of Day with storage (1X)')
legend('Power produced','Idealized Power Purchased','Energy stored in batteries'...
    ,'Idealized Power Consumed','PEC Production','PEC Consumption')
set(legend,'Location','southoutside','FontSize',12);


    
    