%needs Ptot over the given day, needs to be told the day of the year, and
%the number of batteries.
global TOD;
N = 172;
Ptot;
Batteries = 0; %0,6, or 24
cconsumption = 0; % cummulative consumption in kWh that had to be purchased from Austin Energy
iconsumption = zeros(1,length(TOD)); %instantaneous consumption kW
storage = zeros(1,length(TOD)); %kWh





Capacity = Batteries*210; % 210 kWh per battery
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
    if Ptot(i)>iconsumption(i) && storage <capacity %checks if there is excess power and battery room
        storage(i) = storage(i) + (Ptot(i)-iconsumption(i))*5/60; %adds to storage. times 5/60 for the 5 minute step
        if storage(i) > capacity %if the step that was just executed excedes the capacity
            storage(i) = capacity; %reduce to full capacity
        end
    elseif Ptot(i) < iconsumption(i) %if we don't have enough solar power
        if storage(i) >= iconsumption(i)*5/60 %if there is enough stored to meet full need
            storage(i) = storage(i-1) - iconsumption(i)*5/60; %demand is met by battery
        elseif iconsumption(i)*5/60 > storage %not enough battery storage
            cconsumption = cconsumption + (iconsumption(i)*5/60-storage); %some energy is purchased
            storage(i) = 0; %all storage is depleted to decrease purchased amount
        end
    end
end

    
