clear all
% 1X congfiguration
% March 26,2019
load('DailyOCI.mat');
global totIr_OCI;
global TOD;
panel_temp = zeros(365,length(TOD));
batteries = 0; %0,6, or 24
bought = zeros(365,length(TOD)); % cummulative consumption in kWh that had to be purchased from Austin Energy
iconsumption = zeros(365,length(TOD)); %instantaneous consumption kW
stored = zeros(365,length(TOD)); %kWh
esold = zeros(365,length(TOD)); %energy sold
capacity = batteries*210;
x=6;
for j=1:365
    N=j
    OCI = index_OCI(j);
    P2_C6(N,index_OCI(j),25,46);
    % power Ptot
    for i=1:length(TOD)
        time = TOD(i);
        I = totIr_OCI(i);
        panel_temp(j,i) = T_panel(time,N,I);
    end

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
            Ptot(j,i)=val1(i)+val2(i)+val3(i)+val4(i);
        end
    end
    if x==5
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
            Ptot(j,i)=val1(i)+val2(i)+val3(i)+val4(i)+val5(i);
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
            Ptot(j,i)=val1(i)+val2(i)+val3(i)+val4(i)+val5(i)+val6(i);
        end
    end

    % Idealized power consumption on a winter day
    load('winter_consumption.mat');
    %needs Ptot over the given day, needs to be told the day of the year, and
    %the number of batteries.
 % 210 kWh per battery
    for i = 1:length(TOD)
        if N >= 152 && N <=324 %summer days , June 1 to nov 20
            if TOD(i) <= 6 || TOD(i) >19 %midnight to 6am or 7pm to midnight
                iconsumption(j,i) = 220; %kw
            elseif TOD(i) > 6 && TOD(i) <= 19 %6 to 18
                iconsumption(j,i) = 580; %kw            
            end
        elseif N >= 325 || N<= 151 %winter days, Nov 21 to may 21
            if TOD(i)<= 6 || TOD(i) >18 %midnight to 6 or 6 to midnight
                iconsumption(j,i) = 200; %200 kW
            elseif TOD(i)>6 && TOD(i) <= 18 %6 to 18
                iconsumption(j,i) = 300; %300 kW
            end

        end
        %we now have instantaneous demand for this time of day
        % next we either store battery power, use battery power, or buy energy
        if Ptot(j,i) >= iconsumption(j,i) %more power than needed
            if i>1
                if stored(j,i-1) + (Ptot(j,i)-iconsumption(j,i))*5/60 < capacity % space in storage, but won't exceed
                    stored(j,i) = stored(j,i-1) + (Ptot(j,i)-iconsumption(j,i))*5/60;%storage = storage + power - use
                    %none is bought or sold
                elseif stored(j,i-1) == capacity %no space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60; %sold = power - use                   
                    stored(j,i) = stored(j,i-1);%none bought and stored is still capacity
                elseif stored(j,i-1) + (Ptot(j,i)-iconsumption(j,i))*5/60 > capacity %some space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60 + stored(j,i-1) - capacity;% sold = (power-use) + stored - capacity
                    stored(j,i) = capacity;%stored = capacity
                    %none is bought
                end
            elseif i==1
                if stored(j-1,289) + (Ptot(j,i)-iconsumption(j,i))*5/60 < capacity % space in storage, but won't exceed
                    stored(j,i) = stored(j-1,289) + (Ptot(j,i)-iconsumption(j,i))*5/60;%storage = storage + power - use
                    %none is bought or sold
                elseif stored(j-1,289) == capacity %no space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60; %sold = power - use                   
                    stored(j,i) = stored(j-1,289);%none bought and stored is still capacity
                elseif stored(j-1,289) + (Ptot(j,i)-iconsumption(j,i))*5/60 > capacity %some space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60 + stored(j-1,289) - capacity;% sold = (power-use) + stored - capacity
                    stored(j,i) = capacity;%stored = capacity
                    %none is bought
                end
            end
        elseif Ptot(j,i)<iconsumption(j,i)%less power than needed
            if i>1
                if Ptot(j,i)*5/60 + stored(j,i-1) >= iconsumption(j,i)*5/60% power with storage is enough
                    stored(j,i) = stored(j,i-1) - (iconsumption(j,i)-Ptot(j,i))*5/60;%stored = stored -(use-power)
                    %none is sold or bought
                elseif Ptot(j,i)*5/60 + stored(j,i-1) < iconsumption(j,i)*5/60% power with storage still not enough
                    bought(j,i) = (iconsumption(j,i)-Ptot(j,i))*5/60-stored(j,i-1);%bought = use - stored - power
                    stored(j,i)=0;% stored and sold are 0
                end
            elseif i == 1 && j>1
                if Ptot(j,i)*5/60 + stored(j-1,289) >= iconsumption(j,i)*5/60% power with storage is enough
                    stored(j,i) = stored(j-1,289) - (iconsumption(j,i)-Ptot(j,i))*5/60;%stored = stored -(use-power)
                    %none is sold or bought
                elseif Ptot(j,i)*5/60 + stored(j-1,289) < iconsumption(j,i)*5/60% power with storage still not enough
                    bought(j,i) = (iconsumption(j,i)-Ptot(j,i))*5/60-stored(j-1,289);%bought = use - stored - power
                    stored(j,i)=0;% stored and sold are 0
                end   
            elseif i ==1 && j==1
                if Ptot(j,i)*5/60 >= iconsumption(j,i)*5/60% power with storage is enough
                    stored(j,i) = 0 - (iconsumption(j,i)-Ptot(j,i))*5/60;%stored = stored -(use-power)
                    %none is sold or bought
                elseif Ptot(j,i)*5/60 < iconsumption(j,i)*5/60% power with storage still not enough
                    bought(j,i) = (iconsumption(j,i)-Ptot(j,i))*5/60-0;%bought = use - stored - power
                    stored(j,i)=0;% stored and sold are 0
                end 
            end
        end
    end
end
%i'm now going to store these variables so I can run the next case
%%
bought1 = bought;
esold1 = esold;
Ptot1=Ptot;
totalbought1 = sum(bought(:,:));
totalsold1 = sum(esold(:,:));
stored1=stored;
iconsumption1=iconsumption;

%%%%%%%%%%%%%

%now I will run it again, with the new battery storage
batteries = 6; %0,6, or 24
bought = zeros(365,length(TOD)); % cummulative consumption in kWh that had to be purchased from Austin Energy
iconsumption = zeros(365,length(TOD)); %instantaneous consumption kW
stored = zeros(365,length(TOD)); %kWh
esold = zeros(365,length(TOD)); %energy sold
capacity = batteries*210;
for j=1:365
    N=j
    OCI = index_OCI(j);
    P2_C6(N,index_OCI(j),25,46);
    % power Ptot
    for i=1:length(TOD)
        time = TOD(i);
        I = totIr_OCI(i);
        panel_temp(j,i) = T_panel(time,N,I);
    end

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
            Ptot(j,i)=val1(i)+val2(i)+val3(i)+val4(i);
        end
    end
    if x==5
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
            Ptot(j,i)=val1(i)+val2(i)+val3(i)+val4(i)+val5(i);
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
            Ptot(j,i)=val1(i)+val2(i)+val3(i)+val4(i)+val5(i)+val6(i);
        end
    end

    % Idealized power consumption on a winter day
    load('winter_consumption.mat');
    %needs Ptot over the given day, needs to be told the day of the year, and
    %the number of batteries.
 % 210 kWh per battery
    for i = 1:length(TOD)
        if N >= 152 && N <=324 %summer days , June 1 to nov 20
            if TOD(i) <= 6 || TOD(i) >19 %midnight to 6am or 7pm to midnight
                iconsumption(j,i) = 220; %kw
            elseif TOD(i) > 6 && TOD(i) <= 19 %6 to 18
                iconsumption(j,i) = 580; %kw            
            end
        elseif N >= 325 || N<= 151 %winter days, Nov 21 to may 21
            if TOD(i)<= 6 || TOD(i) >18 %midnight to 6 or 6 to midnight
                iconsumption(j,i) = 200; %200 kW
            elseif TOD(i)>6 && TOD(i) <= 18 %6 to 18
                iconsumption(j,i) = 300; %300 kW
            end

        end
        %we now have instantaneous demand for this time of day
        % next we either store battery power, use battery power, or buy energy
        if Ptot(j,i) >= iconsumption(j,i) %more power than needed
            if i>1
                if stored(j,i-1) + (Ptot(j,i)-iconsumption(j,i))*5/60 < capacity % space in storage, but won't exceed
                    stored(j,i) = stored(j,i-1) + (Ptot(j,i)-iconsumption(j,i))*5/60;%storage = storage + power - use
                    %none is bought or sold
                elseif stored(j,i-1) == capacity %no space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60; %sold = power - use                   
                    stored(j,i) = stored(j,i-1);%none bought and stored is still capacity
                elseif stored(j,i-1) + (Ptot(j,i)-iconsumption(j,i))*5/60 > capacity %some space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60 + stored(j,i-1) - capacity;% sold = (power-use) + stored - capacity
                    stored(j,i) = capacity;%stored = capacity
                    %none is bought
                end
            elseif i==1
                if stored(j-1,289) + (Ptot(j,i)-iconsumption(j,i))*5/60 < capacity % space in storage, but won't exceed
                    stored(j,i) = stored(j-1,289) + (Ptot(j,i)-iconsumption(j,i))*5/60;%storage = storage + power - use
                    %none is bought or sold
                elseif stored(j-1,289) == capacity %no space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60; %sold = power - use                   
                    stored(j,i) = stored(j-1,289);%none bought and stored is still capacity
                elseif stored(j-1,289) + (Ptot(j,i)-iconsumption(j,i))*5/60 > capacity %some space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60 + stored(j-1,289) - capacity;% sold = (power-use) + stored - capacity
                    stored(j,i) = capacity;%stored = capacity
                    %none is bought
                end
            end
        elseif Ptot(j,i)<iconsumption(j,i)%less power than needed
            if i>1
                if Ptot(j,i)*5/60 + stored(j,i-1) >= iconsumption(j,i)*5/60% power with storage is enough
                    stored(j,i) = stored(j,i-1) - (iconsumption(j,i)-Ptot(j,i))*5/60;%stored = stored -(use-power)
                    %none is sold or bought
                elseif Ptot(j,i)*5/60 + stored(j,i-1) < iconsumption(j,i)*5/60% power with storage still not enough
                    bought(j,i) = (iconsumption(j,i)-Ptot(j,i))*5/60-stored(j,i-1);%bought = use - stored - power
                    stored(j,i)=0;% stored and sold are 0
                end
            elseif i == 1 && j>1
                if Ptot(j,i)*5/60 + stored(j-1,289) >= iconsumption(j,i)*5/60% power with storage is enough
                    stored(j,i) = stored(j-1,289) - (iconsumption(j,i)-Ptot(j,i))*5/60;%stored = stored -(use-power)
                    %none is sold or bought
                elseif Ptot(j,i)*5/60 + stored(j-1,289) < iconsumption(j,i)*5/60% power with storage still not enough
                    bought(j,i) = (iconsumption(j,i)-Ptot(j,i))*5/60-stored(j-1,289);%bought = use - stored - power
                    stored(j,i)=0;% stored and sold are 0
                end   
            elseif i ==1 && j==1
                if Ptot(j,i)*5/60 >= iconsumption(j,i)*5/60% power with storage is enough
                    stored(j,i) = 0 - (iconsumption(j,i)-Ptot(j,i))*5/60;%stored = stored -(use-power)
                    %none is sold or bought
                elseif Ptot(j,i)*5/60 < iconsumption(j,i)*5/60% power with storage still not enough
                    bought(j,i) = (iconsumption(j,i)-Ptot(j,i))*5/60-0;%bought = use - stored - power
                    stored(j,i)=0;% stored and sold are 0
                end 
            end
        end
    end
end
%again, I save the variables so that I can start over
bought2 = bought;
esold2 = esold;
Ptot2=Ptot;
totalbought2 = sum(bought(:,:));
totalsold2 = sum(esold(:,:));
stored2=stored;
iconsumption2=iconsumption;

%%%%%%%%%%%%%%%%

%now I will run it again, with the new battery storage

batteries = 24; %0,6, or 24
bought = zeros(365,length(TOD)); % cummulative consumption in kWh that had to be purchased from Austin Energy
iconsumption = zeros(365,length(TOD)); %instantaneous consumption kW
stored = zeros(365,length(TOD)); %kWh
esold = zeros(365,length(TOD)); %energy sold
capacity = batteries*210;
for j=1:365
    N=j
    OCI = index_OCI(j);
    P2_C6(N,index_OCI(j),25,46);
    % power Ptot
    for i=1:length(TOD)
        time = TOD(i);
        I = totIr_OCI(i);
        panel_temp(j,i) = T_panel(time,N,I);
    end

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
            Ptot(j,i)=val1(i)+val2(i)+val3(i)+val4(i);
        end
    end
    if x==5
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
            Ptot(j,i)=val1(i)+val2(i)+val3(i)+val4(i)+val5(i);
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
            Ptot(j,i)=val1(i)+val2(i)+val3(i)+val4(i)+val5(i)+val6(i);
        end
    end

    % Idealized power consumption on a winter day
    load('winter_consumption.mat');
    %needs Ptot over the given day, needs to be told the day of the year, and
    %the number of batteries.
 % 210 kWh per battery
    for i = 1:length(TOD)
        if N >= 152 && N <=324 %summer days , June 1 to nov 20
            if TOD(i) <= 6 || TOD(i) >19 %midnight to 6am or 7pm to midnight
                iconsumption(j,i) = 220; %kw
            elseif TOD(i) > 6 && TOD(i) <= 19 %6 to 18
                iconsumption(j,i) = 580; %kw            
            end
        elseif N >= 325 || N<= 151 %winter days, Nov 21 to may 21
            if TOD(i)<= 6 || TOD(i) >18 %midnight to 6 or 6 to midnight
                iconsumption(j,i) = 200; %200 kW
            elseif TOD(i)>6 && TOD(i) <= 18 %6 to 18
                iconsumption(j,i) = 300; %300 kW
            end

        end
        %we now have instantaneous demand for this time of day
        % next we either store battery power, use battery power, or buy energy
        if Ptot(j,i) >= iconsumption(j,i) %more power than needed
            if i>1
                if stored(j,i-1) + (Ptot(j,i)-iconsumption(j,i))*5/60 < capacity % space in storage, but won't exceed
                    stored(j,i) = stored(j,i-1) + (Ptot(j,i)-iconsumption(j,i))*5/60;%storage = storage + power - use
                    %none is bought or sold
                elseif stored(j,i-1) == capacity %no space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60; %sold = power - use                   
                    stored(j,i) = stored(j,i-1);%none bought and stored is still capacity
                elseif stored(j,i-1) + (Ptot(j,i)-iconsumption(j,i))*5/60 > capacity %some space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60 + stored(j,i-1) - capacity;% sold = (power-use) + stored - capacity
                    stored(j,i) = capacity;%stored = capacity
                    %none is bought
                end
            elseif i==1
                if stored(j-1,289) + (Ptot(j,i)-iconsumption(j,i))*5/60 < capacity % space in storage, but won't exceed
                    stored(j,i) = stored(j-1,289) + (Ptot(j,i)-iconsumption(j,i))*5/60;%storage = storage + power - use
                    %none is bought or sold
                elseif stored(j-1,289) == capacity %no space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60; %sold = power - use                   
                    stored(j,i) = stored(j-1,289);%none bought and stored is still capacity
                elseif stored(j-1,289) + (Ptot(j,i)-iconsumption(j,i))*5/60 > capacity %some space
                    esold(j,i) = (Ptot(j,i)-iconsumption(j,i))*5/60 + stored(j-1,289) - capacity;% sold = (power-use) + stored - capacity
                    stored(j,i) = capacity;%stored = capacity
                    %none is bought
                end
            end
        elseif Ptot(j,i)<iconsumption(j,i)%less power than needed
            if i>1
                if Ptot(j,i)*5/60 + stored(j,i-1) >= iconsumption(j,i)*5/60% power with storage is enough
                    stored(j,i) = stored(j,i-1) - (iconsumption(j,i)-Ptot(j,i))*5/60;%stored = stored -(use-power)
                    %none is sold or bought
                elseif Ptot(j,i)*5/60 + stored(j,i-1) < iconsumption(j,i)*5/60% power with storage still not enough
                    bought(j,i) = (iconsumption(j,i)-Ptot(j,i))*5/60-stored(j,i-1);%bought = use - stored - power
                    stored(j,i)=0;% stored and sold are 0
                end
            elseif i == 1 && j>1
                if Ptot(j,i)*5/60 + stored(j-1,289) >= iconsumption(j,i)*5/60% power with storage is enough
                    stored(j,i) = stored(j-1,289) - (iconsumption(j,i)-Ptot(j,i))*5/60;%stored = stored -(use-power)
                    %none is sold or bought
                elseif Ptot(j,i)*5/60 + stored(j-1,289) < iconsumption(j,i)*5/60% power with storage still not enough
                    bought(j,i) = (iconsumption(j,i)-Ptot(j,i))*5/60-stored(j-1,289);%bought = use - stored - power
                    stored(j,i)=0;% stored and sold are 0
                end   
            elseif i ==1 && j==1
                if Ptot(j,i)*5/60 >= iconsumption(j,i)*5/60% power with storage is enough
                    stored(j,i) = 0 - (iconsumption(j,i)-Ptot(j,i))*5/60;%stored = stored -(use-power)
                    %none is sold or bought
                elseif Ptot(j,i)*5/60 < iconsumption(j,i)*5/60% power with storage still not enough
                    bought(j,i) = (iconsumption(j,i)-Ptot(j,i))*5/60-0;%bought = use - stored - power
                    stored(j,i)=0;% stored and sold are 0
                end 
            end
        end
    end
end
%again, I save the variables.

%%
bought3 = bought;
esold3 = esold;
Ptot3=Ptot;
totalbought3 = sum(bought(:,:));
totalsold3 = sum(esold(:,:));
stored3=stored;
iconsumption3=iconsumption;

totalbought1= sum(totalbought1);
totalbought2 = sum(totalbought2);
totalbought3 = sum(totalbought3);

totalsold1 = sum(totalsold1);
totalsold2 = sum(totalsold2);
totalsold3 = sum(totalsold3);

buyprice = .06:.01:.18; %dollars per kWh
sellprice = [0 
    .5 
    1]*buyprice; %each row is a "sell price" case, each column is a "buy price" case

%cases for 0,6, and 24 batteries and 0 buy back
spent11 = totalbought1*buyprice - totalsold1*sellprice(1,:);
spent21 = totalbought2*buyprice - totalsold2*sellprice(1,:);
spent31 = totalbought3*buyprice - totalsold3*sellprice(1,:);

%cases for 0,6, and 24 batteries and .5 buy back
spent12 = totalbought1*buyprice - totalsold1*sellprice(2,:);
spent22 = totalbought2*buyprice - totalsold2*sellprice(2,:);
spent32 = totalbought3*buyprice - totalsold3*sellprice(2,:);

%cases for 0, 6, 24 batteries and 1 buy back
spent13 = totalbought1*buyprice - totalsold1*sellprice(3,:);
spent23 = totalbought2*buyprice - totalsold2*sellprice(3,:);
spent33 = totalbought3*buyprice - totalsold3*sellprice(3,:);

figure
plot(buyprice,spent11)
hold on
plot(buyprice,spent12)
plot(buyprice,spent13)
plot(buyprice,spent21)
plot(buyprice,spent22)
plot(buyprice,spent23)
plot(buyprice,spent31)
plot(buyprice,spent32)
plot(buyprice,spent33)
ylabel('Average Electricity Spending ($/Year)')
xlabel('Austin Electricity Cost ($/kWh)')
grid on
title('Yearly Electricity Spending for Various Cases')
legend({'No Batteries, 0% Buy Back','No Batteries, 50% Buy Back','No Batteries, 100% Buy Back','6 Batteries, 0% Buy Back','6 Batteries, 50% Buy Back','6 Batteries, 100% Buy Back','24 Batteries, 0% Buy Back','24 Batteries, 50% Buy Back','24 Batteries, 100% Buy Back'},'location','southoutside')
hold off

    